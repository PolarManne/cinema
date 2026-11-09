# Cinema media proxy

This standalone Node.js service proxies public HTTP(S) media for
`raw-player.html`, allowing Movi and JASSUB to read media that does not provide
CORS headers. It is independent of the web relay.

Run it with:

```text
npm start
```

Configure `HOST` and `PORT` as needed. The service forwards byte ranges and
rejects private or local targets to avoid turning the endpoint into an SSRF
proxy.

## systemd service

The included [cinema-media-proxy.service](cinema-media-proxy.service) runs the
proxy from `/data/cinema-proxy` as the `srcds` user and restarts it if it
fails. Copy `server.mjs`, `package.json`, and the service file to that
directory, then install the unit:

```text
sudo chown -R srcds:srcds /data/cinema-proxy
sudo install -m 0644 /data/cinema-proxy/cinema-media-proxy.service /etc/systemd/system/cinema-media-proxy.service
sudo systemd-analyze verify /etc/systemd/system/cinema-media-proxy.service
sudo systemctl daemon-reload
sudo systemctl enable --now cinema-media-proxy.service
sudo systemctl status cinema-media-proxy.service
```

Follow logs with:

```text
sudo journalctl -u cinema-media-proxy.service -f
```

The service binds to `127.0.0.1:8090` by default. Keep nginx in front of it
and expose only the configured `/media-proxy` location.
