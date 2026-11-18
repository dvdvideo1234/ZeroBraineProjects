local json = require("dkjson")

util = util or {}

function util.IsValidModel(sM)
  if(string.sub(tostring(sM),-4,-1) == ".mdl") then return true end
  return false
end

function util.GetPlayerTrace(pl)
  return {}
end

function util.TraceLine(dt)
  return {
    Entity = 0,
    Fraction = 1,
    FractionLeftSolid = 0,
    Hit = false,
    HitBox = 0,
    HitGroup = 0,
    HitNoDraw = false,
    HitNonWorld = false,
    HitNormal = Vector(0,0,1),
    HitPos = Vector(10,10,10),
    HitSky = false,
    HitTexture = "**studio**",
    HitWorld = false,
    MatType = 0,
    Normal = 0.5,
    PhysicsBone = 0,
    StartPos = Vector(0,0,0),
    SurfaceProps = 0,
    StartSolid = false,
    AllSolid = false,
    SurfaceFlags = 0,
    DispFlags = 0,
    Contents = 0    
  }
end

function util.AddNetworkString(sS)
  print("util.AddNetworkString:", sS)
end

function util.JSONToTable(sJson, bNoLimits, bNoConversions)
  return json.decode()
end

function util.TableToJSON(tSors, bPretty)
  return json.encode(tSors, 1, "NULL")
end

return util