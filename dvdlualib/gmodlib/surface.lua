-- gmodlib/surface.lua
local surface = {}

---------------------------------------------------------------
-- Helpers
---------------------------------------------------------------
local function copy(c) return { r = c.r, g = c.g, b = c.b, a = c.a } end

-- Uses the real Color() if gmodlib has one, otherwise a plain table
local function mkColor(c)
    if _G.Color then return _G.Color(c.r, c.g, c.b, c.a) end
    return copy(c)
end

local function argmsg(fname, n, expected, v)
    return ("bad argument #%d to '%s' (%s expected, got %s)"):format(n, fname, expected, type(v))
end

-- The checkers below call error() directly at level 3, so the error points at
-- the addon's call to the surface function, not at this file.
local function req(fname, n, ...)       -- first n args must be numbers; returns all args
    for i = 1, n do
        local v = select(i, ...)
        if type(v) ~= "number" then error(argmsg(fname, i, "number", v), 3) end
    end
    return ...
end

local function str(fname, n, v)         -- strings (numbers are coerced, like Lua does)
    if type(v) == "number" then return tostring(v) end
    if type(v) ~= "string" then error(argmsg(fname, n, "string", v), 3) end
    return v
end

-- Accepts (r, g, b [, a]) or a Color table. `base` is the argument position
-- of r, for error messages.
local function readColor(fname, base, a1, a2, a3, a4)
    local vals
    if type(a1) == "table" then
        vals = { a1.r, a1.g, a1.b, a1.a == nil and 255 or a1.a }
        base = base  -- all four components are reported against the Color argument
        for i = 1, 4 do
            if type(vals[i]) ~= "number" then error(argmsg(fname, base, "number", vals[i]), 3) end
        end
    else
        vals = { a1, a2, a3, a4 == nil and 255 or a4 }
        for i = 1, 4 do
            if type(vals[i]) ~= "number" then error(argmsg(fname, base + i - 1, "number", vals[i]), 3) end
        end
    end
    return { r = vals[1], g = vals[2], b = vals[3], a = vals[4] }
end

---------------------------------------------------------------
-- State
---------------------------------------------------------------
local screen = { w = 1920, h = 1080 }
local state, fonts, textures, pathToId, nextId
local calls, sounds, recording, strictFonts, metrics

local function builtinFonts()
    return {
        Default          = { font = "Tahoma",        size = 13 },
        DermaDefault     = { font = "Tahoma",        size = 13 },
        DermaDefaultBold = { font = "Tahoma",        size = 13, weight = 800 },
        DermaLarge       = { font = "Roboto",        size = 32 },
        Trebuchet18      = { font = "Trebuchet MS",  size = 18 },
        Trebuchet24      = { font = "Trebuchet MS",  size = 24 },
    }
end

local function reset()
    state = {
        drawColor = { r = 255, g = 255, b = 255, a = 255 },
        textColor = { r = 255, g = 255, b = 255, a = 255 },
        textX = 0, textY = 0,
        font = "Default",
        texture = nil,      -- { kind = "id", value = n } or { kind = "material", value = mat }
        alphaMul = 1,
        noClip = false,
    }
    fonts = builtinFonts()
    textures, pathToId, nextId = {}, {}, 1
    calls, sounds = {}, {}
    recording, strictFonts, metrics = true, false, nil
    screen.w, screen.h = 1920, 1080
end
reset()

local function record(fn, e)
    if not recording then return end
    e.fn    = fn
    e.alpha = state.alphaMul
    e.color = e.color or copy(state.drawColor)
    calls[#calls + 1] = e
end

---------------------------------------------------------------
-- Colors, position, font
---------------------------------------------------------------
function surface.SetDrawColor(...)  state.drawColor = readColor("SetDrawColor", 1, ...) end
function surface.GetDrawColor()     return mkColor(state.drawColor) end

function surface.SetTextColor(...)  state.textColor = readColor("SetTextColor", 1, ...) end
function surface.GetTextColor()
    local c = state.textColor
    return c.r, c.g, c.b, c.a
end

function surface.SetTextPos(...)
    local x, y = req("SetTextPos", 2, ...)
    state.textX, state.textY = x, y
end
function surface.GetTextPos() return state.textX, state.textY end

function surface.SetAlphaMultiplier(...)
    state.alphaMul = (req("SetAlphaMultiplier", 1, ...))
end
function surface.GetAlphaMultiplier() return state.alphaMul end

-- Returns the previous state so callers can restore it
function surface.DisableClipping(disable)
    local old = state.noClip
    state.noClip = disable and true or false
    return old
end

---------------------------------------------------------------
-- Fonts and text
---------------------------------------------------------------
local function fontData(name)
    local f = fonts[name]
    if not f then
        if strictFonts then
            error(("surface: font '%s' does not exist"):format(tostring(name)), 3)
        end
        f = fonts.Default
    end
    return f
end

function surface.CreateFont(name, data)
    if type(name) ~= "string" then error(argmsg("CreateFont", 1, "string", name), 2) end
    if type(data) ~= "table"  then error(argmsg("CreateFont", 2, "table",  data), 2) end
    local f = {}
    for k, v in pairs(data) do f[k] = v end
    f.size = tonumber(f.size) or 13
    fonts[name] = f
end

function surface.SetFont(name)
    name = str("SetFont", 1, name)
    fontData(name)               -- raises in strict mode
    state.font = name
end

-- Rough estimate: every character is about half the font size wide.
-- Override with surface.Mock_SetTextMetrics for exact numbers.
local function defaultMetrics(text, f)
    local len  = (utf8 and utf8.len(text)) or #text
    local size = f.size or 13
    return len * math.floor(size / 2 + 0.5), math.ceil(size * 13 / 10)
end

function surface.GetTextSize(text)
    text = str("GetTextSize", 1, text)
    return (metrics or defaultMetrics)(text, fontData(state.font))
end

function surface.DrawText(text, forceAdditive)
    text = str("DrawText", 1, text)
    record("DrawText", {
        text = text, font = state.font,
        x = state.textX, y = state.textY,
        color = copy(state.textColor),
        additive = forceAdditive and true or false,
    })
end

---------------------------------------------------------------
-- Textures and materials
---------------------------------------------------------------
function surface.GetTextureID(path)
    path = str("GetTextureID", 1, path)
    local id = pathToId[path]
    if not id then
        id = nextId
        nextId = nextId + 1
        pathToId[path] = id
        textures[id] = { path = path, w = 64, h = 64 }
    end
    return id
end

function surface.GetTextureNameFromID(id)
    local t = textures[id]
    return t and t.path
end

function surface.GetTextureSize(id)
    local t = textures[id]
    if t then return t.w, t.h end
    return 0, 0
end

function surface.SetTexture(...)
    local id = req("SetTexture", 1, ...)
    state.texture = { kind = "id", value = id }
end

function surface.SetMaterial(mat)
    if mat == nil then error(argmsg("SetMaterial", 1, "IMaterial", mat), 2) end
    state.texture = { kind = "material", value = mat }
end

---------------------------------------------------------------
-- Drawing (validated, then recorded)
---------------------------------------------------------------
function surface.DrawRect(...)
    local x, y, w, h = req("DrawRect", 4, ...)
    record("DrawRect", { x = x, y = y, w = w, h = h })
end

function surface.DrawOutlinedRect(...)
    local x, y, w, h, thickness = req("DrawOutlinedRect", 4, ...)
    record("DrawOutlinedRect", { x = x, y = y, w = w, h = h, thickness = thickness or 1 })
end

function surface.DrawLine(...)
    local x1, y1, x2, y2 = req("DrawLine", 4, ...)
    record("DrawLine", { x1 = x1, y1 = y1, x2 = x2, y2 = y2 })
end

-- Takes its own color, separate from SetDrawColor
function surface.DrawCircle(...)
    local x, y, radius = req("DrawCircle", 3, ...)
    local col = readColor("DrawCircle", 4, select(4, ...))
    record("DrawCircle", { x = x, y = y, radius = radius, color = col })
end

function surface.DrawPoly(verts)
    if type(verts) ~= "table" then error(argmsg("DrawPoly", 1, "table", verts), 2) end
    local pts = {}
    for i, p in ipairs(verts) do
        pts[i] = { x = p.x, y = p.y, u = p.u, v = p.v }
    end
    record("DrawPoly", { vertices = pts, texture = state.texture })
end

function surface.DrawTexturedRect(...)
    local x, y, w, h = req("DrawTexturedRect", 4, ...)
    record("DrawTexturedRect", { x = x, y = y, w = w, h = h, texture = state.texture })
end

function surface.DrawTexturedRectRotated(...)
    local x, y, w, h, rot = req("DrawTexturedRectRotated", 5, ...)
    record("DrawTexturedRectRotated", { x = x, y = y, w = w, h = h, rot = rot, texture = state.texture })
end

function surface.DrawTexturedRectUV(...)
    local x, y, w, h, su, sv, eu, ev = req("DrawTexturedRectUV", 8, ...)
    record("DrawTexturedRectUV", {
        x = x, y = y, w = w, h = h,
        startU = su, startV = sv, endU = eu, endV = ev,
        texture = state.texture,
    })
end

---------------------------------------------------------------
-- Sound and screen
---------------------------------------------------------------
function surface.PlaySound(path)
    path = str("PlaySound", 1, path)
    sounds[#sounds + 1] = path
end

function surface.ScreenWidth()  return screen.w end
function surface.ScreenHeight() return screen.h end

-- Globals that real addon code uses (only defined if missing)
if not ScrW then function ScrW() return screen.w end end
if not ScrH then function ScrH() return screen.h end end
if not DisableClipping then DisableClipping = surface.DisableClipping end

---------------------------------------------------------------
-- Test helpers (not part of real GMod)
---------------------------------------------------------------
-- All recorded draw calls, oldest first. Pass a name to filter: "DrawRect".
function surface.Mock_GetCalls(fn)
    local out = {}
    for _, c in ipairs(calls) do
        if fn == nil or c.fn == fn then out[#out + 1] = c end
    end
    return out
end

function surface.Mock_ClearCalls() calls, sounds = {}, {} end
function surface.Mock_GetSounds()  return { unpack and unpack(sounds) and sounds or sounds } end
function surface.Mock_SetRecording(b) recording = b and true or false end

function surface.Mock_SetScreenSize(w, h) screen.w, screen.h = w, h end

-- fn(text, fontData) -> width, height. Pass nil to go back to the estimate.
function surface.Mock_SetTextMetrics(fn) metrics = fn end

-- In strict mode, SetFont raises on a font that was never created
function surface.Mock_StrictFonts(b) strictFonts = b and true or false end

-- Accepts a texture id or a path
function surface.Mock_SetTextureSize(idOrPath, w, h)
    local id = idOrPath
    if type(idOrPath) == "string" then id = surface.GetTextureID(idOrPath) end
    assert(textures[id], "surface.Mock_SetTextureSize: unknown texture " .. tostring(idOrPath))
    textures[id].w, textures[id].h = w, h
end

function surface.Mock_GetState()
    return {
        drawColor = copy(state.drawColor), textColor = copy(state.textColor),
        textX = state.textX, textY = state.textY, font = state.font,
        alphaMul = state.alphaMul, noClip = state.noClip, texture = state.texture,
    }
end

function surface.Mock_Reset() reset() end

_G.surface = surface

return surface
