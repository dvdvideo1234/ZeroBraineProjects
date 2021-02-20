local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(1)

local com = require("common")


local api = "ftrace"

function registerType() end
E2Lib = {RegisterExtension = function(...) print(...) end}

HUD_PRINTTALK = 50

require("dvdlualib/gmodlib")
local common = require("dvdlualib/common")
require("dvdlualib/e2_"..api)

local ATTACH = ents.Create() -- ENT{1}{prop_physics}

local set = {
  [getmetatable(Vector())] = tostring,
  [getmetatable(ATTACH)] = tostring
}; local function dump(o) com.logTable(o, api, nil, set) end

local oSelf = {
  entity = ents.Create("gmod_wire_e2"),
  player = LocalPlayer(),
  mFlt = {Ear = {ents.Create(1), ents.Create(2)}}
} -- ENT{2}{prop_physics}
oSelf.entity:SetPos(Vector(100,100,100))
ATTACH:SetPos(Vector(500,500,500))

local a = newItem(oSelf, ATTACH, Vector(0,0,0), Vector(0,0,1), -25)
      a:addEntHitSkip(ATTACH)--:addEntHitSkip(ents.Create("alabala")):addEntHitOnly(ents.Create("gaga"))
      a:addHitSkip("GetClass", "prop"):addHitSkip("GetModel", "model"):addHitSkip("GetClass", "TEST")
      
local b = newItem(oSelf, ATTACH, Vector(0,0,0), Vector(0,0,1), -25)
      b:addEntHitSkip(ATTACH):addEntHitSkip(ents.Create("alabala")):addEntHitOnly(ents.Create("gaga"))
      b:addHitSkip("physics", 2):addHitOnly("GetClass", "func"):addHitOnly("GetClass", "door"):addHitSkip("GetClass", "TEST")
      
GetConVar("wire_expression2_"..api.."_enst"):SetData(1)
GetConVar("wire_expression2_"..api.."_only"):SetData("IsVehicle/GetModel")

--a:dumpItem("TALK", "test")

--a:rayAim(6,6,6)

---a:dumpItem("TALK", "test")

local h = 14.433756729741
-- print(Vector(h,h,h):Length())

local function isValid(vE, vT)
  if(vT) then local sT = tostring(vT or "")
    if(sT ~= type(vE)) then return false end end
  return (vE and vE.IsValid and vE:IsValid())
end

local function getEntityList(oFTrc, bID)
  if(not oFTrc) then return nil end
  local tO, iO = {}, 0
  local tE, iD = oFTrc.mFlt.Ear, 1
  while(tE[iD]) do local vE = tE[iD]
    if(isValid(vE)) then iO = iO + 1
      if(bID) then
        tO[iO] = vE:EntIndex()
      else tO[iO] = vE end
    end; iD = iD + 1
  end; return tO
end

--[[
 * Moves only the entities from source to destination
 * oFTrc > Reference to tracer object
 * tData > Source data table to read from
]]
local function putFunctionalList(oFTrc, tData)
  oFTrc.mFnc = oFTrc.mHit
  com.logTable(oFTrc.mFnc, "A")
  com.logTable(tData     , "B")
  
  for iD = 1, tData.Size do local vD = tData[iD]
    if(vD.SKIP) then for key, val in pairs(vD.SKIP) do
      setHitFilter(oFTrc, oSelf, vD.CALL, "SKIP", key, true) end end
    if(vD.ONLY) then for key, val in pairs(vD.ONLY) do
      setHitFilter(oFTrc, oSelf, vD.CALL, "ONLY", key, true) end end
  end
  
  for key, val in pairs(tData.Ent.SKIP) do
    oFTrc.mFnc.Ent.SKIP[key] = val end
  for key, val in pairs(tData.Ent.ONLY) do
    oFTrc.mFnc.Ent.ONLY[key] = val end
    
    
  com.logTable(oFTrc.mHit, "AS")
end

putFunctionalList(a, b.mHit)
