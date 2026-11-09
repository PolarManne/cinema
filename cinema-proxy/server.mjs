import http from "node:http";
import net from "node:net";

const host = process.env.HOST || "127.0.0.1";
const port = Number(process.env.PORT || 8090);
const maxRedirects = 5;
const timeoutMs = 30_000;
const requestHeaders = ["accept", "accept-language", "range", "if-none-match", "if-modified-since", "if-range"];
const responseHeaders = ["accept-ranges", "cache-control", "content-length", "content-range", "content-type", "etag", "last-modified"];

function isPrivateHostname(hostname) {
  const host = String(hostname || "").toLowerCase().replace(/^\[|\]$/g, "").replace(/\.+$/u, "");
  if (!host || !host.includes(".") || host === "localhost" || host.endsWith(".local") ||
      host.endsWith(".localhost") || host.endsWith(".internal") || host.endsWith(".lan")) return true;
  const version = net.isIP(host);
  if (version === 4) {
    const [a, b] = host.split(".").map(Number);
    return a === 0 || a === 10 || a === 127 || (a === 169 && b === 254) ||
      (a === 172 && b >= 16 && b <= 31) || (a === 192 && b === 168);
  }
  if (version === 6) return host === "::1" || host.startsWith("fc") || host.startsWith("fd") || host.startsWith("fe80:");
  return false;
}

function publicUrl(value) {
  let url;
  try { url = new URL(String(value || "")); } catch { return null; }
  if (!["http:", "https:"].includes(url.protocol) || url.username || url.password ||
      isPrivateHostname(url.hostname)) return null;
  return url;
}

function upstreamHeaders(request) {
  const headers = { "accept-encoding": "identity" };
  for (const name of requestHeaders) {
    if (request.headers[name]) headers[name] = request.headers[name];
  }
  return headers;
}

async function handle(request, response) {
  if (request.method !== "GET" && request.method !== "HEAD") {
    response.writeHead(405, { Allow: "GET, HEAD" });
    response.end("Method not allowed");
    return;
  }

  let target = publicUrl(new URL(request.url, "http://localhost").searchParams.get("url"));
  if (!target) {
    response.writeHead(400, { "Content-Type": "text/plain; charset=utf-8" });
    response.end("A public HTTP(S) url query parameter is required");
    return;
  }

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), timeoutMs);
  try {
    let upstream;
    for (let redirects = 0; redirects <= maxRedirects; redirects += 1) {
      upstream = await fetch(target, {
        method: request.method,
        headers: upstreamHeaders(request),
        redirect: "manual",
        signal: controller.signal,
      });
      if (![301, 302, 303, 307, 308].includes(upstream.status)) break;
      const location = upstream.headers.get("location");
      target = publicUrl(location ? new URL(location, target).href : "");
      if (!target || redirects === maxRedirects) {
        response.writeHead(502);
        response.end("The media redirect target is not allowed");
        return;
      }
    }

    response.statusCode = upstream.status;
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Expose-Headers", responseHeaders.join(", "));
    response.setHeader("Cross-Origin-Resource-Policy", "cross-origin");
    for (const name of responseHeaders) {
      const value = upstream.headers.get(name);
      if (value) response.setHeader(name, value);
    }
    if (request.method === "HEAD" || !upstream.body) {
      response.end();
      return;
    }
    for await (const chunk of upstream.body) response.write(chunk);
    response.end();
  } catch (error) {
    response.writeHead(error.name === "AbortError" ? 504 : 502);
    response.end(error.name === "AbortError" ? "Media request timed out" : "Media request failed");
  } finally {
    clearTimeout(timeout);
  }
}

http.createServer((request, response) => {
  if (!request.url?.startsWith("/media-proxy")) {
    response.writeHead(404);
    response.end("Not found");
    return;
  }
  handle(request, response);
}).listen(port, host, () => {
  console.log(`Cinema media proxy listening on ${host}:${port}`);
});
