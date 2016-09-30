local envFile  = "#" -- File load prefix ( setgravity #propfly loads propfly file )
local envDiv   = " " -- File storage delimiter
local envDir   = "envorganiser/" -- Place where data is saved
local envPrefx = "envorganiser_"
local envAddon = "envOrganizer: "

local enLog = true

local function envPrint(...)
  if(not enLog) then return end;
  print(envAddon,...)
end

function CreateConVar(...)
  envPrint(...)
end

local function envCreateMemberConvars(tMembers)
  local envList = tMembers.List
  for ID = 1, #tMembers, 1 do
    local envMember = tMembers[ID]
    local envKeyID  = envMember[3]
    if(envKeyID ~= nil) then
      CreateConVar(envPrefx..envMember[1], tostring(envList["INIT"][envKeyID]), envFvars, envMember[2])
    else -- Scalar value
      CreateConVar(envPrefx..envMember[1], tostring(envList["INIT"]), envFvars, envMember[2])
    end
  end
end


  -- https://wiki.garrysmod.com/page/Category:number
  local airMembers = { -- AIR DENSITY
    Name = "envSetAirDensity",
    List = {["user"] = 0},
    Ctrl = {["get"] = 1, ["set"] = 3},
    {"airdensity", "Air density affecting props", nil, "float", "+"}
  }

  -- https://wiki.garrysmod.com/page/Category:Vector
  local gravMembers = { -- GRAVITY
    Name = "envSetGravity",
    List = {["user"] = 1},
    Ctrl = {["get"] = 3, ["set"] = 4},
    {"gravitydrx", "Component X of the gravity affecting props", "x", "float", nil},
    {"gravitydry", "Component Y of the gravity affecting props", "y", "float", nil},
    {"gravitydrz", "Component Z of the gravity affecting props", "z", "float", nil}
  }

  -- https://wiki.garrysmod.com/page/Category:physenv
  local perfMembers = { -- PERFORMANCE SETTINGS
    Name = "envSetPerformance",
    List = {["user"] = {}},
    Ctrl = {["get"] = 2, ["set"] = 4},
    {"perfmaxangvel", "Maximum rotation velocity"                                        , "MaxAngularVelocity"               , "float", "+"},
    {"perfmaxlinvel", "Maximum speed of an object"                                       , "MaxVelocity"                      , "float", "+"},
    {"perfminfrmass", "Minimum mass of an object to be affected by friction"             , "MinFrictionMass"                  , "float", "+"},
    {"perfmaxfrmass", "Maximum mass of an object to be affected by friction"             , "MaxFrictionMass"                  , "float", "+"},
    {"perflooktmovo", "Maximum amount of seconds to precalculate collisions with objects", "LookAheadTimeObjectsVsObject"     , "float", "+"},
    {"perflooktmovw", "Maximum amount of seconds to precalculate collisions with world"  , "LookAheadTimeObjectsVsWorld"      , "float", "+"},
    {"perfmaxcolchk", "Maximum collision checks per tick"                                , "MaxCollisionChecksPerTimestep"    , "float", "+"},
    {"perfmaxcolobj", "Maximum collision per object per tick"                            , "MaxCollisionsPerObjectPerTimestep", "float", "+"}
  }




