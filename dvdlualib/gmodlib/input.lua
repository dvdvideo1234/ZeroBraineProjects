-- gmodlib/input.lua
local input = {}

---------------------------------------------------------------
-- Constants and key names
---------------------------------------------------------------
local names, codes = {}, {}   -- code -> name, name -> code

-- Defines a global constant (unless it already exists) and records its name
local function define(const, code, keyname)
    if _G[const] == nil then _G[const] = code end
    if keyname then
        names[_G[const]] = keyname
        codes[keyname]   = _G[const]
    end
end

local n = 0   -- sequential code counter, same order as GMod's KEY_ enums
local function nextkey(const, keyname)
    define(const, n, keyname)
    n = n + 1
end

nextkey("KEY_NONE")
for i = 0, 9 do nextkey("KEY_" .. i, tostring(i)) end
for c = ("a"):byte(), ("z"):byte() do
    local ch = string.char(c)
    nextkey("KEY_" .. ch:upper(), ch)
end

local pad = { "ins", "end", "downarrow", "pgdn", "leftarrow",
              "5", "rightarrow", "home", "uparrow", "pgup" }
for i = 0, 9 do nextkey("KEY_PAD_" .. i, "kp_" .. pad[i + 1]) end

for _, k in ipairs({
    { "KEY_PAD_DIVIDE",   "kp_slash" },    { "KEY_PAD_MULTIPLY", "kp_multiply" },
    { "KEY_PAD_MINUS",    "kp_minus" },    { "KEY_PAD_PLUS",     "kp_plus" },
    { "KEY_PAD_ENTER",    "kp_enter" },    { "KEY_PAD_DECIMAL",  "kp_del" },
    { "KEY_LBRACKET",     "[" },           { "KEY_RBRACKET",     "]" },
    { "KEY_SEMICOLON",    ";" },           { "KEY_APOSTROPHE",   "'" },
    { "KEY_BACKQUOTE",    "`" },           { "KEY_COMMA",        "," },
    { "KEY_PERIOD",       "." },           { "KEY_SLASH",        "/" },
    { "KEY_BACKSLASH",    "\\" },          { "KEY_MINUS",        "-" },
    { "KEY_EQUAL",        "=" },           { "KEY_ENTER",        "enter" },
    { "KEY_SPACE",        "space" },       { "KEY_BACKSPACE",    "backspace" },
    { "KEY_TAB",          "tab" },         { "KEY_CAPSLOCK",     "capslock" },
    { "KEY_NUMLOCK",      "numlock" },     { "KEY_ESCAPE",       "escape" },
    { "KEY_SCROLLLOCK",   "scrolllock" },  { "KEY_INSERT",       "ins" },
    { "KEY_DELETE",       "del" },         { "KEY_HOME",         "home" },
    { "KEY_END",          "end" },         { "KEY_PAGEUP",       "pgup" },
    { "KEY_PAGEDOWN",     "pgdn" },        { "KEY_BREAK",        "break" },
    { "KEY_LSHIFT",       "shift" },       { "KEY_RSHIFT",       "rshift" },
    { "KEY_LALT",         "alt" },         { "KEY_RALT",         "ralt" },
    { "KEY_LCONTROL",     "ctrl" },        { "KEY_RCONTROL",     "rctrl" },
    { "KEY_LWIN",         "lwin" },        { "KEY_RWIN",         "rwin" },
    { "KEY_APP",          "app" },         { "KEY_UP",           "uparrow" },
    { "KEY_LEFT",         "leftarrow" },   { "KEY_DOWN",         "downarrow" },
    { "KEY_RIGHT",        "rightarrow" },
}) do nextkey(k[1], k[2]) end

for i = 1, 12 do nextkey("KEY_F" .. i, "f" .. i) end
nextkey("KEY_CAPSLOCKTOGGLE",   "capslocktoggle")
nextkey("KEY_NUMLOCKTOGGLE",    "numlocktoggle")
nextkey("KEY_SCROLLLOCKTOGGLE", "scrolllocktoggle")

assert(n == 107, "input: key table out of sync")   -- catches typos in the list above

define("KEY_FIRST", 0)
define("KEY_LAST",  106)
define("KEY_COUNT", 107)

nextkey("MOUSE_LEFT",       "mouse1")
nextkey("MOUSE_RIGHT",      "mouse2")
nextkey("MOUSE_MIDDLE",     "mouse3")
nextkey("MOUSE_4",          "mouse4")
nextkey("MOUSE_5",          "mouse5")
nextkey("MOUSE_WHEEL_UP",   "mwheelup")
nextkey("MOUSE_WHEEL_DOWN", "mwheeldown")

define("MOUSE_FIRST", 107)
define("MOUSE_LAST",  111)
define("MOUSE_COUNT", 5)

define("BUTTON_CODE_INVALID", -1)
define("BUTTON_CODE_NONE",    0)
define("BUTTON_CODE_LAST",    159)
define("BUTTON_CODE_COUNT",   160)

---------------------------------------------------------------
-- State
---------------------------------------------------------------
local down = {}                                   -- code -> true while held
local pressed, released, typed, dbl = {}, {}, {}, {}   -- per-frame flags
local binds = {}                                  -- code -> console command
local cursor = { x = 0, y = 0 }
local trapping, trapped = false, nil
local selectedWeapon

local function isKey(c)   return type(c) == "number" and c >= KEY_0 and c <= KEY_LAST end
local function isMouse(c) return type(c) == "number" and c >= MOUSE_FIRST and c <= MOUSE_LAST end

---------------------------------------------------------------
-- The real input library
---------------------------------------------------------------
function input.IsKeyDown(key)      return isKey(key) and down[key] == true end
function input.IsMouseDown(mouse)  return isMouse(mouse) and down[mouse] == true end
function input.IsButtonDown(btn)   return down[btn] == true end
function input.IsShiftDown()       return down[KEY_LSHIFT] == true or down[KEY_RSHIFT] == true end
function input.IsControlDown()     return down[KEY_LCONTROL] == true or down[KEY_RCONTROL] == true end

-- Per-frame events (cleared by input.Mock_NextFrame)
function input.WasKeyPressed(key)       return isKey(key) and pressed[key] == true end
function input.WasKeyReleased(key)      return isKey(key) and released[key] == true end
function input.WasKeyTyped(key)         return isKey(key) and typed[key] == true end
function input.WasMousePressed(m)       return isMouse(m) and pressed[m] == true end
function input.WasMouseReleased(m)      return isMouse(m) and released[m] == true end
function input.WasMouseDoublePressed(m) return isMouse(m) and dbl[m] == true end

-- Cursor
function input.GetCursorPos() return cursor.x, cursor.y end
function input.SetCursorPos(x, y)
    cursor.x, cursor.y = tonumber(x) or 0, tonumber(y) or 0
end

-- Names
function input.GetKeyName(code)  return names[code] end
function input.GetKeyCode(name)
    if type(name) ~= "string" then return KEY_NONE end
    return codes[name:lower()] or KEY_NONE
end

-- Bindings
function input.LookupKeyBinding(key) return binds[key] end

function input.LookupBinding(binding, exact)
    local best
    for code, cmd in pairs(binds) do
        local match
        if exact then
            match = (cmd == binding)
        else
            match = cmd:find(binding, 1, true) ~= nil
        end
        if match and (best == nil or code < best) then best = code end
    end
    return best and names[best] or nil
end

-- Key trapping (for "press a key to bind" UIs)
function input.StartKeyTrapping() trapping, trapped = true, nil end
function input.IsKeyTrapping()    return trapping end
function input.CheckKeyTrapping()
    if trapping and trapped then
        local k = trapped
        trapping, trapped = false, nil
        return k
    end
    return nil
end

function input.SelectWeapon(weapon) selectedWeapon = weapon end

---------------------------------------------------------------
-- Test helpers: play the user (not part of real GMod)
---------------------------------------------------------------
-- Press or release one button. Mouse buttons use the same codes.
function input.Mock_SetButton(code, isDown)
    assert(names[code], "input.Mock_SetButton: unknown button code " .. tostring(code))
    isDown = isDown and true or false
    if (down[code] == true) == isDown then return end

    down[code] = isDown or nil
    if isDown then
        pressed[code], typed[code] = true, true
        if trapping and trapped == nil then trapped = code end
    else
        released[code] = true
    end
end

-- A full click/tap: down, then up
function input.Mock_Press(code)
    input.Mock_SetButton(code, true)
    input.Mock_SetButton(code, false)
end

function input.Mock_DoubleClick(code)
    input.Mock_Press(code)
    dbl[code] = true
end

-- Simulates OS key repeat while a key is held
function input.Mock_Repeat(code) typed[code] = true end

-- Ends the current frame: clears every Was* flag, held keys stay held
function input.Mock_NextFrame()
    pressed, released, typed, dbl = {}, {}, {}, {}
end

function input.Mock_Bind(key, command) binds[key] = command end
function input.Mock_GetSelectedWeapon() return selectedWeapon end

function input.Mock_Reset()
    down, pressed, released, typed, dbl, binds = {}, {}, {}, {}, {}, {}
    cursor.x, cursor.y = 0, 0
    trapping, trapped, selectedWeapon = false, nil, nil
end

_G.input = input

return input
