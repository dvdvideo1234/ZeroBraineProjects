local drpath = require("directories")
      drpath.addPath("myprograms",
                     "CorporateProjects",
                     "ZeroBraineProjects",
                     -- When not located in general directory search in projects
                     "ZeroBraineProjects/dvdlualib",
                     "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local common = require("common")

SERVER = true
CLIENT = true

require("gmodlib")
require("trackasmlib")
asmlib = trackasmlib

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetOpVar("DIRPATH_BAS", drpath.getBase(2).."/ZeroBraineProjects/Assembly/trackassembly/")
asmlib.SetLogControl(1000,false)

PIECES = asmlib.GetBuilderNick("PIECES")

local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gsDataRoot  = asmlib.GetOpVar("DIRPATH_BAS")
local gsDataSet   = asmlib.GetOpVar("DIRPATH_SET")
local tableConcat = table.concat 
---------------------------------------------------------------------------------------

if(not asmlib.ProcessDSV()) then -- Default tab delimiter
  local sDSV = gsDataRoot..gsDataSet..gsLibName.."_dsv.txt"
  asmlib.LogInstance("Processing DSV fail <"..sDSV..">")
end

local oRec = asmlib.CacheQueryPiece("models/props_lab/blastdoor001b.mdl")
if (not oRec) then asmlib.LogInstance("Unable to load model"); return end

common.logTable(oRec, 'oRec')

asmlib.LocatePOA(oRec, 1)

for i = 1, oRec.Size do
  local tPOA = oRec.Offs[i]
  local sP = asmlib.StringPOA(tPOA.P, "V")
  local sO = asmlib.StringPOA(tPOA.O, "V")
  local sA = asmlib.StringPOA(tPOA.A, "A")
  print("["..i.."]", sP, sO, sA)
end


function NewPOA()
  local self, mRaw = {0, 0, 0}
  local mMis = asmlib.GetOpVar("MISS_NOSQL")
  local nDis = asmlib.GetOpVar("OPSYM_DISABLE")
  local mSep = asmlib.GetOpVar("OPSYM_SEPARATOR")
  function self:Get()
    return unpack(self)
  end
  function self:Table()
    return {unpack(self)}
  end
  function self:Vector()
    return Vector(unpack(self))
  end
  function self:Angle()
    return Angle(unpack(self))
  end
  function self:String()
    return tableConcat(self, mSep)
  end
  function self:Set(nA, nB, nC)
    self[1] = (tonumber(nA) or 0)
    self[2] = (tonumber(nB) or 0)
    self[3] = (tonumber(nC) or 0)
    return self
  end
  function self:Raw(sRaw)
    if(IsHere(sRaw)) then
      mRaw = tostring(sRaw or "") end
    return mRaw -- Source data manager
  end
  function self:IsSame(tPOA)
    for iD = 1, 3 do
      if(tPOA[iD] ~= self[iD]) then return false end
    end; return true
  end
  function self:IsZero()
    for iD = 1, 3 do
      if(self[iD] ~= 0) then return false end
    end; return true
  end
  function self:Export(sDes)
    local sS = self:String()
    local sD = tostring(sDes or mMis)
    local sE = (self:IsZero() and sD or sS)
    return (mRaw and mRaw or sE)
  end
  function self:Decode(sStr)
    local sStr = tostring(sStr or "")    -- Default to string
    local tPOA = mSep:Explode(sStr)      -- Read the components
    for iD = 1, 3 do                     -- Apply on all components
      local nCom = tonumber(tPOA[iD])    -- Is the data really a number
      if(not IsHere(nCom)) then nCom = 0 -- If not write zero and report it
        LogInstance("Mismatch "..GetReport(sStr)) end; self[iD] = nCom
    end; return self
  end
  function self:Scan(sStr)
    local sS = tostring(sStr or "")  -- Default to string
    local bD = (asmlib.IsBlank(sS) or asmlib.IsNull(sS) or sS:sub(1,1) == nDis)
    return (not bD), sS
  end
  setmetatable(self, asmlib.GetOpVar("TYPEMT_POA")); return self
end


local POA = NewPOA():Set(1,2,26)

print(Vector(unpack({POA:Get()})))
print(POA:String())
print(POA:Scan("#1,2,3"))

if(POA:Scan("#1,2,3")) then print(1) end

