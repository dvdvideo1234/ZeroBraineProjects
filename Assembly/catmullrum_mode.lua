local common = require("../dvdlualib/common")
local gmodlib = require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")

local asmlib = trackasmlib

local GetOpVar = asmlib.GetOpVar
local IsTable  = asmlib.IsTable
local LogInstance = asmlib.LogInstance

asmlib.InitBase("track","assembly")
asmlib.SetLogControl(10000,false)


local v1 = Vector(1,2,3)
local v2 = Vector(3,2,1)
local v3 = Vector(2,1,7.1)
local v4 = Vector(10,-5,2)
local v5 = Vector(11,-3,7)


function GetLinearSpace(nBeg, nEnd, nAmt)
  local fAmt = math.floor(tonumber(nAmt) or 0); if(fAmt < 0) then
    return common.logStatus("Samples count invalid <"..tostring(fAmt)..">",nil) end
  local iAmt, dAmt = (fAmt + 1), (nEnd - nBeg)
  local fBeg, fEnd, nAdd = 1, (fAmt+2), (dAmt / iAmt)
  local tO = {[fBeg] = nBeg, [fEnd] = nEnd}
  while(fBeg <= fEnd) do fBeg, fEnd = (fBeg + 1), (fEnd - 1)
    tO[fBeg], tO[fEnd] = (tO[fBeg-1] + nAdd), (tO[fEnd+1] - nAdd)
  end return tO
end

local function GetCatmullRomCurveTangent(cS, cE, nT, nA)
  local vD = Vector(); vD:Set(cE); vD:Sub(cS)
  return ((vD:Length()^(tonumber(nA) or 0.5))+nT)
end

local function GetCatmullRomCurveSegment(vP0, vP1, vP2, vP3, nN, nA)
  local nT0, tC = 0, {} -- Start point is always zero
  local nT1 = GetCatmullRomCurveTangent(vP0, vP1, nT0, nA)
  local nT2 = GetCatmullRomCurveTangent(vP1, vP2, nT1, nA)
  local nT3 = GetCatmullRomCurveTangent(vP2, vP3, nT2, nA)
  local tTN = GetLinearSpace(nT1, nT2, nN)
  local vB1, vB2 = Vector(), Vector()
  local vA1, vA2, vA3 = Vector(), Vector(), Vector()
  for iD = 1, #tTN do tC[iD] = Vector(); local nTn, vTn = tTN[iD], tC[iD]
    vA1:Set(vP0); vA1:Mul((nT1-nTn)/(nT1-nT0)); vA1:Add(vP1 * ((nTn-nT0)/(nT1-nT0)))
    vA2:Set(vP1); vA2:Mul((nT2-nTn)/(nT2-nT1)); vA2:Add(vP2 * ((nTn-nT1)/(nT2-nT1)))
    vA3:Set(vP2); vA3:Mul((nT3-nTn)/(nT3-nT2)); vA3:Add(vP3 * ((nTn-nT2)/(nT3-nT2)))
    vB1:Set(vA1); vB1:Mul((nT2-nTn)/(nT2-nT0)); vB1:Add(vA2 * ((nTn-nT0)/(nT2-nT0)))
    vB2:Set(vA2); vB2:Mul((nT3-nTn)/(nT3-nT1)); vB2:Add(vA3 * ((nTn-nT1)/(nT3-nT1)))
    vTn:Set(vB1); vTn:Mul((nT2-nTn)/(nT2-nT1)); vTn:Add(vB2 * ((nTn-nT1)/(nT2-nT1)))
  end; return tC
end

function GetCatmullRomCurve(tV, nT, nA) if(not IsTable(tV)) then
    LogInstance("Curve vertices {"..type(tV).."}<"..tostring(tV).."> not table"); return nil end
  nT, nV = math.floor(tonumber(nT) or 100), #tV; if(nT < 0) then
    LogInstance("Curve samples count invalid <"..tostring(nT)..">",nil); return nil end
  if(not (tV[1] and tV[2])) then LogInstance("Two vertices are needed",nil); return nil end
  local vM, iC, tC = GetOpVar("EPSILON_ZERO"), 1, {}
  local cS = Vector(); cS:Set(tV[ 1]); cS:Sub(tV[2])   ; cS:Normalize(); cS:Mul(vM); cS:Add(tV[1])
  local cE = Vector(); cE:Set(tV[nV]); cE:Sub(tV[nV-1]); cE:Normalize(); cE:Mul(vM); cE:Add(tV[nV])
  table.insert(tV, 1, cS); table.insert(tV, cE); nV = (nV + 2);
  for iD = 1, (nV-3) do
    local cA, cB, cC, cD = tV[iD], tV[iD+1], tV[iD+2], tV[iD+3]
    local tS = GetCatmullRomCurveSegment(cA, cB, cC, cD, nT, nA)
    for iK = 1, (nT+1) do tC[iC] = tS[iK]; iC = (iC + 1) end
  end; tC[iC] = Vector(); tC[iC]:Set(tV[nV-1]); return tC
end

common.logTable(GetCatmullRomCurve({v1,v2,v3,v4,v5},5),"CRV",{},{["Vector"]=tostring})

