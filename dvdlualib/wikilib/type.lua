--[[
  [1] -> Internal [wiremod addon](https://github.com/wiremod/wire) class or data type sent to `registerType` second argument
  [2] -> [Wiremod](https://github.com/wiremod/wire) dedicated external data type names for using in `printTypeReference`
  [3] -> Data type description to display with words in brackets converted to links
  [4] -> The type that is used when writing an actual [expression 2](https://github.com/wiremod/wire/wiki/Expression-2) source for `[1]`
  [5] -> General link description that is used for linking arguments in brackets `[]` in `[4]`
]]--
local wikiType =
{
  list = {
    {"a"  , "Angle"        , "[Angle] class"           , "angle"     , "https://en.wikipedia.org/wiki/Euler_angles"},
    {"b"  , "Bone"         , "[Bone] class"            , "bone"      , "https://github.com/wiremod/wire/wiki/Expression-2#Bone"},
    {"c"  , "ComplexNumber", "[Complex] number"        , "complex"   , "https://en.wikipedia.org/wiki/Complex_number"},
    {"e"  , "Entity"       , "[Entity] class"          , "entity"    , "https://en.wikipedia.org/wiki/Entity"},
    {"xm2", "Matrix2"      , "[Matrix] 2x2"            , "matrix2"   , "https://en.wikipedia.org/wiki/Matrix_(mathematics)"},
    {"m"  , "Matrix"       , "[Matrix] 3x3"            , "matrix"    , "https://en.wikipedia.org/wiki/Matrix_(mathematics)"},
    {"xm4", "Matrix4"      , "[Matrix] 4x4"            , "matrix4"   , "https://en.wikipedia.org/wiki/Matrix_(mathematics)"},
    {"n"  , "Number"       , "[Number]"                , "number"    , "https://en.wikipedia.org/wiki/Number"},
    {"q"  , "Quaternion"   , "[Quaternion]"            , "quaternion", "https://en.wikipedia.org/wiki/Quaternion"},
    {"r"  , "Array"        , "[Array]"                 , "array"     , "https://en.wikipedia.org/wiki/Array_data_structure"},
    {"s"  , "String"       , "[String] class"          , "string"    , "https://en.wikipedia.org/wiki/String_(computer_science)"},
    {"t"  , "Table"        , "[Table]"                 , "table"     , "https://github.com/wiremod/wire/wiki/Expression-2#Table"},
    {"xv2", "Vector2"      , "[Vector] 2D class"       , "vector2"   , "https://en.wikipedia.org/wiki/Euclidean_vector"},
    {"v"  , "Vector"       , "[Vector] 3D class"       , "vector"    , "https://en.wikipedia.org/wiki/Euclidean_vector"},
    {"xv4", "Vector4"      , "[Vactor] 4D class"       , "vector4"   , "https://en.wikipedia.org/wiki/4D_vector"},
    {"xrd", "RangerData"   , "[Ranger data] class"     , "ranger"    , "https://github.com/wiremod/wire/wiki/Expression-2#BuiltIn_Ranger"},
    {"xwl", "WireLink"     , "[Wire link] class"       , "wirelink"  , "https://github.com/wiremod/wire/wiki/Expression-2#Wirelink"},
    {"xft", ""             , "[Flash tracer] class"    , "ftrace"    , "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FTracer"},
    {"xsc", ""             , "[State controller] class", "stcontrol" , "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl"},
    {"xxx", ""             , "[Void] data type"        , "void"      , "https://en.wikipedia.org/wiki/Void_type"},
    {"...", ""             , "[Vararg] data type"      , "..."       , "https://www.lua.org/pil/5.2.html"}
  },
  idx = { -- Used for finding data type description by its wire internal E2 type name
    ["angle"]      = 1,
    ["bone"]       = 2,
    ["complex"]    = 3,
    ["entity"]     = 4,
    ["matrix2"]    = 5,
    ["matrix"]     = 6,
    ["matrix4"]    = 7,
    ["number"]     = 8,
    ["quaternion"] = 9,
    ["array"]      = 10,
    ["string"]     = 11,
    ["table"]      = 12,
    ["vector2"]    = 13,
    ["vector"]     = 14,
    ["vector4"]    = 15,
    ["ranger"]     = 16,
    ["wirelink"]   = 17,
    ["ftrace"]     = 18,
    ["stcontrol"]  = 19,
    ["void"]       = 20,
    ["..."]        = 21
  },
  spec = {}, -- Wiremod internal type being a special case start character
  delm = { -- Patterns used for splitting parameters and types for functions
    -- IN  (parameter info, pattern start, pattern end)
    -- OUT (parameter type, parameter name)
    ["%s"] = function(p, s, e) -- When having a space
      return p:sub(1, s - 1), p:sub(e + 1, -1)
    end,
    ["%.%.%."] = function(p, s, e) -- When using varargs
      return p:sub(s, e), p:sub(e + 1, -1)
    end
  }
}

for idx = 1, #wikiType.list do
  local v = wikiType.list[idx]
  if(v[1]:len() > 1) then
    local ty = v[1]:sub(1,1)
    if(not wikiType.spec[ty]) then
      wikiType.spec[ty] = true
    end
  end
end

return wikiType
