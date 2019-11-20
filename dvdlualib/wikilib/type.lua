local wiki_type =
{
  list = {
    {"a"  , "Angle"        , "[Angle] class"           , "https://en.wikipedia.org/wiki/Euler_angles"},
    {"b"  , "Bone"         , "[Bone] class"            , "https://github.com/wiremod/wire/wiki/Expression-2#Bone"},
    {"c"  , "ComplexNumber", "[Complex] number"        , "https://en.wikipedia.org/wiki/Complex_number"},
    {"e"  , "Entity"       , "[Entity] class"          , "https://en.wikipedia.org/wiki/Entity"},
    {"xm2", "Matrix2"      , "[Matrix] 2x2"            , "https://en.wikipedia.org/wiki/Matrix_(mathematics)"},
    {"m"  , "Matrix"       , "[Matrix] 3x3"            , "https://en.wikipedia.org/wiki/Matrix_(mathematics)"},
    {"xm4", "Matrix4"      , "[Matrix] 4x4"            , "https://en.wikipedia.org/wiki/Matrix_(mathematics)"},
    {"n"  , "Number"       , "[Number]"                , "https://en.wikipedia.org/wiki/Number"},
    {"q"  , "Quaternion"   , "[Quaternion]"            , "https://en.wikipedia.org/wiki/Quaternion"},
    {"r"  , "Array"        , "[Array]"                 , "https://en.wikipedia.org/wiki/Array_data_structure"},
    {"s"  , "String"       , "[String] class"          , "https://en.wikipedia.org/wiki/String_(computer_science)"},
    {"t"  , "Table"        , "[Table]"                 , "https://github.com/wiremod/wire/wiki/Expression-2#Table"},
    {"xv2", "Vector2"      , "[Vector] 2D class"       , "https://en.wikipedia.org/wiki/Euclidean_vector"},
    {"v"  , "Vector"       , "[Vector] 3D class"       , "https://en.wikipedia.org/wiki/Euclidean_vector"},
    {"xv4", "Vector4"      , "[Vactor] 4D class"       , "https://en.wikipedia.org/wiki/4D_vector"},
    {"xrd", "RangerData"   , "[Ranger data] class"     , "https://github.com/wiremod/wire/wiki/Expression-2#BuiltIn_Ranger"},
    {"xwl", "WireLink"     , "[Wire link] class"       , "https://github.com/wiremod/wire/wiki/Expression-2#Wirelink"},
    {"xft", ""             , "[Flash tracer] class"    , "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FTracer"},
    {"xsc", ""             , "[State controller] class", "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl"},
    {"xxx", ""             , "[Void] data type"        , "https://en.wikipedia.org/wiki/Void_type"}
  },
  idx = {
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
    ["void"]       = 20
  }
}

return wiki_type
