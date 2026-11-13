-- gmodlib/draw.lua
-- Built on gmodlib/surface. Primitives are recorded by surface; this file
-- additionally records one entry per public draw.* call.
local surface = require("gmodlib/surface")

local draw = {}

---------------------------------------------------------------
-- Globals
---------------------------------------------------------------
TEXT_ALIGN_LEFT   = TEXT_ALIGN_LEFT   or 0
TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER or 1
TEXT_ALIGN_RIGHT  = TEXT_ALIGN_RIGHT  or 2
TEXT_ALIGN_TOP    = TEXT_ALIGN_TOP    or 3
TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM or 4

if not math.Round then
    function math.Round(num, idp)
        if idp == nil or idp == 0 then return math.floor(num + 0.5) end
        local mult = 10 ^ idp
        return math.floor(num * mult + 0.5) / mult
    end
end

---------------------------------------------------------------
-- Helpers
---------------------------------------------------------------
local calls, recording = {}, true

local function record(fn, e)
    if not recording then return end
    e.fn = fn
    calls[#calls + 1] = e
end

local function copy(c)
    return { r = c.r, g = c.g, b = c.b, a = c.a == nil and 255 or c.a }
end

local function white() return { r = 255, g = 255, b = 255, a = 255 } end

-- The checkers below raise at level 3, so the error points at the addon's
-- call to the draw function (they must be called directly from the public function).
local function req(fname, n, ...)
    for i = 1, n do
        local v = select(i, ...)
        if type(v) ~= "number" then
            error(("bad argument #%d to '%s' (number expected, got %s)")
                :format(i, fname, type(v)), 3)
        end
    end
end

local function needColor(fname, n, c)
    if type(c) ~= "table" then
        error(("bad argument #%d to '%s' (Color expected, got %s)")
            :format(n, fname, type(c)), 3)
    end
end

---------------------------------------------------------------
-- Private implementations (no recording, so nested calls
-- don't show up as extra high-level entries)
---------------------------------------------------------------
local function roundedBoxEx(bordersize, x, y, w, h, color, a, b, c, d)
    surface.SetDrawColor(color.r, color.g, color.b, color.a)

    -- no rounding requested
    if bordersize <= 0 then
        surface.DrawRect(x, y, w, h)
        return
    end

    x, y, w, h = math.Round(x), math.Round(y), math.Round(w), math.Round(h)
    bordersize = math.min(math.Round(bordersize), math.floor(w / 2))

    -- body: one wide rect in the middle, two side strips
    surface.DrawRect(x + bordersize, y, w - bordersize * 2, h)
    surface.DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
    surface.DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)

    -- corners: textured quads, or plain squares when a flag is false.
    -- This leaves the corner texture selected, exactly as in GMod.
    surface.SetTexture(surface.GetTextureID(bordersize > 8 and "gui/corner16" or "gui/corner8"))

    if a ~= false then   -- top left
        surface.DrawTexturedRectUV(x, y, bordersize, bordersize, 0, 0, 1, 1)
    else
        surface.DrawRect(x, y, bordersize, bordersize)
    end
    if b ~= false then   -- top right
        surface.DrawTexturedRectUV(x + w - bordersize, y, bordersize, bordersize, 1, 0, 0, 1)
    else
        surface.DrawRect(x + w - bordersize, y, bordersize, bordersize)
    end
    if c ~= false then   -- bottom left
        surface.DrawTexturedRectUV(x, y + h - bordersize, bordersize, bordersize, 0, 1, 1, 0)
    else
        surface.DrawRect(x, y + h - bordersize, bordersize, bordersize)
    end
    if d ~= false then   -- bottom right
        surface.DrawTexturedRectUV(x + w - bordersize, y + h - bordersize, bordersize, bordersize, 1, 1, 0, 0)
    else
        surface.DrawRect(x + w - bordersize, y + h - bordersize, bordersize, bordersize)
    end
end

local function simpleText(text, font, x, y, colour, xalign, yalign)
    text   = tostring(text)
    font   = font   or "DermaDefault"
    x      = x      or 0
    y      = y      or 0
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    surface.SetFont(font)
    local w, h = surface.GetTextSize(text)

    if xalign == TEXT_ALIGN_CENTER then
        x = x - w / 2
    elseif xalign == TEXT_ALIGN_RIGHT then
        x = x - w
    end

    if yalign == TEXT_ALIGN_CENTER then
        y = y - h / 2
    elseif yalign == TEXT_ALIGN_BOTTOM then
        y = y - h
    end

    surface.SetTextPos(math.ceil(x), math.ceil(y))

    if colour ~= nil then
        surface.SetTextColor(colour.r, colour.g, colour.b, colour.a)
    else
        surface.SetTextColor(255, 255, 255, 255)
    end

    surface.DrawText(text)
    return w, h
end

---------------------------------------------------------------
-- Boxes
---------------------------------------------------------------
function draw.RoundedBox(bordersize, x, y, w, h, color)
    req("RoundedBox", 5, bordersize, x, y, w, h)
    needColor("RoundedBox", 6, color)
    roundedBoxEx(bordersize, x, y, w, h, color)
    record("RoundedBox", { radius = bordersize, x = x, y = y, w = w, h = h, color = copy(color) })
end

-- a, b, c, d: top left, top right, bottom left, bottom right. false = square corner.
function draw.RoundedBoxEx(bordersize, x, y, w, h, color, a, b, c, d)
    req("RoundedBoxEx", 5, bordersize, x, y, w, h)
    needColor("RoundedBoxEx", 6, color)
    roundedBoxEx(bordersize, x, y, w, h, color, a, b, c, d)
    record("RoundedBoxEx", {
        radius = bordersize, x = x, y = y, w = w, h = h, color = copy(color),
        corners = { tl = a ~= false, tr = b ~= false, bl = c ~= false, br = d ~= false },
    })
end

---------------------------------------------------------------
-- Text
---------------------------------------------------------------
function draw.SimpleText(text, font, x, y, colour, xalign, yalign)
    local w, h = simpleText(text, font, x, y, colour, xalign, yalign)
    record("SimpleText", {
        text = tostring(text), font = font or "DermaDefault", x = x or 0, y = y or 0,
        color = colour and copy(colour) or white(),
        xalign = xalign or TEXT_ALIGN_LEFT, yalign = yalign or TEXT_ALIGN_TOP,
        w = w, h = h,
    })
    return w, h
end

-- Draws the outline as a grid of offset copies, then the text on top
function draw.SimpleTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour)
    if type(outlinewidth) ~= "number" then
        error(("bad argument #8 to 'SimpleTextOutlined' (number expected, got %s)")
            :format(type(outlinewidth)), 2)
    end
    x, y = x or 0, y or 0

    local steps = (outlinewidth * 2) / 3
    if steps < 1 then steps = 1 end

    for ox = -outlinewidth, outlinewidth, steps do
        for oy = -outlinewidth, outlinewidth, steps do
            simpleText(text, font, x + ox, y + oy, outlinecolour, xalign, yalign)
        end
    end

    local w, h = simpleText(text, font, x, y, colour, xalign, yalign)
    record("SimpleTextOutlined", {
        text = tostring(text), font = font or "DermaDefault", x = x, y = y,
        color = colour and copy(colour) or white(),
        outlinewidth = outlinewidth,
        outlinecolor = outlinecolour and copy(outlinecolour) or white(),
        xalign = xalign or TEXT_ALIGN_LEFT, yalign = yalign or TEXT_ALIGN_TOP,
        w = w, h = h,
    })
    return w, h
end

-- Multi-line text. Lines are split on "\n"; xalign applies to every line.
function draw.DrawText(text, font, x, y, colour, xalign)
    font   = font or "DermaDefault"
    text   = text ~= nil and tostring(text) or ""
    x, y   = x or 0, y or 0
    xalign = xalign or TEXT_ALIGN_LEFT

    surface.SetFont(font)
    local _, lineHeight = surface.GetTextSize("\n")

    local cy = y
    for line in (text .. "\n"):gmatch("(.-)\n") do
        if line ~= "" then
            simpleText(line, font, x, cy, colour, xalign, TEXT_ALIGN_TOP)
        end
        cy = cy + lineHeight
    end

    record("DrawText", {
        text = text, font = font, x = x, y = y,
        color = colour and copy(colour) or white(), xalign = xalign,
    })
end

-- tab = { text, font, pos = {x, y}, color, xalign, yalign }
function draw.Text(tab)
    if type(tab) ~= "table" then
        error(("bad argument #1 to 'Text' (table expected, got %s)"):format(type(tab)), 2)
    end
    local pos = tab.pos or { 0, 0 }
    local w, h = simpleText(tab.text or "", tab.font, pos[1], pos[2], tab.color, tab.xalign, tab.yalign)
    record("Text", {
        text = tostring(tab.text or ""), font = tab.font or "DermaDefault",
        x = pos[1] or 0, y = pos[2] or 0,
        color = tab.color and copy(tab.color) or white(),
        xalign = tab.xalign or TEXT_ALIGN_LEFT, yalign = tab.yalign or TEXT_ALIGN_TOP,
        w = w, h = h,
    })
    return w, h
end

-- Same table as draw.Text; draws a black copy offset by `distance`, then the text.
-- The caller's table is not modified.
function draw.TextShadow(tab, distance, alpha)
    if type(tab) ~= "table" then
        error(("bad argument #1 to 'TextShadow' (table expected, got %s)"):format(type(tab)), 2)
    end
    if type(distance) ~= "number" then
        error(("bad argument #2 to 'TextShadow' (number expected, got %s)"):format(type(distance)), 2)
    end
    alpha = alpha or 200

    local pos    = tab.pos or { 0, 0 }
    local shadow = { r = 0, g = 0, b = 0, a = alpha }
    local text   = tab.text or ""

    simpleText(text, tab.font, (pos[1] or 0) + distance, (pos[2] or 0) + distance,
               shadow, tab.xalign, tab.yalign)
    local w, h = simpleText(text, tab.font, pos[1], pos[2], tab.color, tab.xalign, tab.yalign)

    record("TextShadow", {
        text = tostring(text), font = tab.font or "DermaDefault",
        x = pos[1] or 0, y = pos[2] or 0, distance = distance, alpha = alpha,
        color = tab.color and copy(tab.color) or white(),
        w = w, h = h,
    })
    return w, h
end

-- A box sized to fit the text. Returns the box width and height.
function draw.WordBox(bordersize, x, y, text, font, color, fontcolor, xalign, yalign)
    req("WordBox", 3, bordersize, x, y)
    needColor("WordBox", 6, color)
    needColor("WordBox", 7, fontcolor)
    text = tostring(text)

    surface.SetFont(font)
    local w, h = surface.GetTextSize(text)

    if xalign == TEXT_ALIGN_CENTER then
        x = x - (bordersize + w / 2)
    elseif xalign == TEXT_ALIGN_RIGHT then
        x = x - (bordersize * 2 + w)
    end

    if yalign == TEXT_ALIGN_CENTER then
        y = y - (bordersize + h / 2)
    elseif yalign == TEXT_ALIGN_BOTTOM then
        y = y - (bordersize * 2 + h)
    end

    roundedBoxEx(bordersize, x, y, w + bordersize * 2, h + bordersize * 2, color)

    surface.SetTextColor(fontcolor.r, fontcolor.g, fontcolor.b, fontcolor.a)
    surface.SetTextPos(x + bordersize, y + bordersize)
    surface.DrawText(text)

    record("WordBox", {
        bordersize = bordersize, x = x, y = y, text = text, font = font,
        color = copy(color), fontcolor = copy(fontcolor),
        w = w + bordersize * 2, h = h + bordersize * 2,
    })
    return w + bordersize * 2, h + bordersize * 2
end

function draw.GetFontHeight(font)
    surface.SetFont(font)
    local _, h = surface.GetTextSize("W")
    return h
end

---------------------------------------------------------------
-- Textures
---------------------------------------------------------------
function draw.NoTexture()
    surface.SetTexture(surface.GetTextureID("vgui/white"))
    record("NoTexture", {})
end

-- tab = { texture = <id>, color, x, y, w, h }
function draw.TexturedQuad(tab)
    if type(tab) ~= "table" then
        error(("bad argument #1 to 'TexturedQuad' (table expected, got %s)"):format(type(tab)), 2)
    end
    local color = tab.color or white()
    surface.SetTexture(tab.texture)
    surface.SetDrawColor(color.r, color.g, color.b, color.a)
    surface.DrawTexturedRect(tab.x, tab.y, tab.w, tab.h)
    record("TexturedQuad", {
        texture = tab.texture, x = tab.x, y = tab.y, w = tab.w, h = tab.h, color = copy(color),
    })
end

---------------------------------------------------------------
-- Test helpers (not part of real GMod)
---------------------------------------------------------------
-- High-level draw.* calls, oldest first. Pass a name to filter: "RoundedBox".
function draw.Mock_GetCalls(fn)
    local out = {}
    for _, c in ipairs(calls) do
        if fn == nil or c.fn == fn then out[#out + 1] = c end
    end
    return out
end

function draw.Mock_ClearCalls()       calls = {} end
function draw.Mock_SetRecording(b)    recording = b and true or false end
function draw.Mock_Reset()            calls, recording = {}, true end

_G.draw = draw

return draw
