local Color = Color
local IsValid = IsValid
local RealTime = RealTime

local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect

local FPS_Cap = 30
local FPS_Smoother = CreateClientConVar( "cinema_smoother", 1, true, false, "Make some videos smoother at the cost of FPS" )

local function ChangeFrameCap()
	local bool = FPS_Smoother:GetBool()
	FPS_Cap = bool and 60 or 30
end
ChangeFrameCap()
cvars.AddChangeCallback( FPS_Smoother:GetName(), ChangeFrameCap)

function draw.TheaterText(text, font, x, y, colour, xalign, yalign)
	draw_SimpleText(text, font, x, y + 4, Color(0,0,0,colour.a), xalign, yalign)
	draw_SimpleText(text, font, x + 1, y + 2, Color(0,0,0,colour.a), xalign, yalign)
	draw_SimpleText(text, font, x - 1, y + 2, Color(0,0,0,colour.a), xalign, yalign)
	draw_SimpleText(text, font, x, y, colour, xalign, yalign)
end

function draw.HTMLTexture( panel, w, h )
	if not (panel and IsValid(panel) and w and h) then return end

	-- Recalculate cache if dimensions changed
	if not panel._cachedWidth or panel._cachedTargetW ~= w or panel._cachedTargetH ~= h then
		local pw, ph = panel:GetSize()
		local pw_adjusted = math.power2(pw)
		local ph_adjusted = math.power2(ph)

		panel._cachedWidth = w * (pw_adjusted / pw)
		panel._cachedHeight = h * (ph_adjusted / ph)
		panel._cachedTargetW = w
		panel._cachedTargetH = h
	end

	-- Update texture at throttled rate
	if not panel.NextHTMLTextureThink or RealTime() > panel.NextHTMLTextureThink then
		panel:UpdateHTMLTexture()
		panel.NextHTMLTextureThink = RealTime() + (1 / FPS_Cap)
		panel._cachedMaterial = panel:GetHTMLMaterial()
	end

	-- Render using cached values
	if panel._cachedMaterial then
		surface_SetDrawColor( 255, 255, 255, 255 )
		surface_SetMaterial( panel._cachedMaterial )
		surface_DrawTexturedRect( 0, 0, panel._cachedWidth, panel._cachedHeight )
	else
		surface_SetDrawColor( 0, 0, 0, 255 )
		surface_DrawRect( 0, 0, panel._cachedWidth, panel._cachedHeight )
	end
end