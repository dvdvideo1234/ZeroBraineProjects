require("directories")

local common = require("common")
require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
require("../dvdlualib/common")
local asmlib = trackasmlib

asmlib.InitBase("track", "assembly")
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.SetOpVar("DATE_FORMAT","%d-%m-%y")
asmlib.SetOpVar("TIME_FORMAT","%H:%M:%S")
asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("S",4,5,6,7)
asmlib.SetOpVar("DIRPATH_BAS", "Assembly/")
asmlib.SetLogControl(1000,false)

asmlib.CreateTable("PIECES",{
  Timer = "CQT@1800@1@1",
  Index = {{1},{4},{1,4}},
  Trigs = {
    InsertRecord = function(arLine, vSource)
      local trCls = asmlib.GetOpVar("TRACE_CLASS")
      arLine[2] = asmlib.DisableString(arLine[2],asmlib.DefaultType(),"TYPE")
      arLine[3] = asmlib.DisableString(arLine[3],asmlib.ModelToName(arLine[1]),"MODEL")
      arLine[8] = asmlib.DisableString(arLine[8],"NULL","NULL")
      if(not ((arLine[8] == "NULL") or trCls[arLine[8]] or asmlib.IsBlank(arLine[8]))) then
        trCls[arLine[8]] = true; asmlib.LogInstance("Register trace <"..
          tostring(arLine[8]).."@"..arLine[1]..">",vSource)
      end; return true
    end -- Register the class provided to the trace hit list
  },
  Cache = {
    InsertRecord = function(makTab, tCache, snPK, arLine, vSource)
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Type)) then stData.Type = arLine[2] end
      if(not asmlib.IsHere(stData.Name)) then stData.Name = arLine[3] end
      if(not asmlib.IsHere(stData.Unit)) then stData.Unit = arLine[8] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      local nOffsID = makTab:Match(arLine[4],4); if(not asmlib.IsHere(nOffsID)) then
        asmlib.LogInstance("Cannot match <"..tostring(arLine[4])..
          "> to "..defTab[4][1].." for "..tostring(snPK),vSource); return false end
      local stPOA = asmlib.RegisterPOA(stData,nOffsID,arLine[5],arLine[6],arLine[7])
        if(not asmlib.IsHere(stPOA)) then
        asmlib.LogInstance("Cannot process offset #"..tostring(nOffsID).." for "..
          tostring(snPK),vSource); return false end
      if(nOffsID > stData.Size) then stData.Size = nOffsID else
        asmlib.LogInstance("Offset #"..tostring(nOffsID)..
          " sequential mismatch",vSource); return false end
      return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSource)
      local tData, defTab = {}, makTab:GetDefinition()
      for mod, rec in pairs(tCache) do
        tData[mod] = {KEY = (rec.Type..rec.Name..mod)} end
      local tSort = asmlib.Sort(tData,{"KEY"})
      if(not tSort) then oFile:Flush(); oFile:Close()
        asmlib.LogInstance("("..fPref..") Cannot sort cache data",vSource); return false end
      for iIdx = 1, tSort.Size do local stRec = tSort[iIdx]
        local tData = tCache[stRec.Key]
        local sData, tOffs = defTab.Name, tData.Offs
              sData = sData..sDelim..makTab:Match(stRec.Key,1,true,"\"")..sDelim..
                makTab:Match(tData.Type,2,true,"\"")..sDelim..
                makTab:Match(((asmlib.ModelToName(stRec.Key) == tData.Name) and symOff or tData.Name),3,true,"\"")
        -- Matching crashes only for numbers. The number is already inserted, so there will be no crash
        for iInd = 1, #tOffs do
          local stPnt = tData.Offs[iInd]
          local sP = (asmlib.IsEqualPOA(stPnt.P,stPnt.O) and "" or asmlib.StringPOA(stPnt.P,"V"))
          local sO = (asmlib.IsZeroPOA(stPnt.O,"V") and "" or asmlib.StringPOA(stPnt.O,"V"))
                sO = (stPnt.O.Slot and stPnt.O.Slot or sO)
          local sA = (asmlib.IsZeroPOA(stPnt.A,"A") and "" or asmlib.StringPOA(stPnt.A,"A"))
                sA = (stPnt.A.Slot and stPnt.A.Slot or sA)
          local sC = (tData.Unit and tostring(tData.Unit or "") or "")
          oFile:Write(sData..sDelim..makTab:Match(iInd,4,true,"\"")..sDelim..
            "\""..sP.."\""..sDelim.."\""..sO.."\""..sDelim.."\""..sA.."\""..sDelim.."\""..sC.."\"\n")
        end
      end; return true
    end
  },
  Query = {
    InsertRecord = {"%s","%s","%s","%d","%s","%s","%s","%s"},
    ExportDSV = {2,3,1,4}
  },
  [1] = {"MODEL" , "TEXT"   , "LOW", "QMK"},
  [2] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [3] = {"NAME"  , "TEXT"   ,  nil , "QMK"},
  [4] = {"LINEID", "INTEGER", "FLR",  nil },
  [5] = {"POINT" , "TEXT"   ,  nil ,  nil },
  [6] = {"ORIGIN", "TEXT"   ,  nil ,  nil },
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil },
  [8] = {"CLASS" , "TEXT"   ,  nil ,  nil }
},true,true)

asmlib.ImportDSV("PIECES", true, "ex_")
local sModel = "models/props_phx/construct/4metal_plate1x2.mdl"
local stPOA = asmlib.LocatePOA(asmlib.CacheQueryPiece(sModel), 1)

local gsINS = "asmlib.InsertRecord({\"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", \"%s\"})"
local gsDSV = "TRACKASSEMBLY_PIECES\t\"%s\"\t\"%s\"\t\"%s\"\t%d\t\"%s\"\t\"%s\"\t\"%s\"\t\"%s\""
local enFlag = true
local cvX, cvY, cvZ = asmlib.GetIndexes("V")
local caP, caY, caR = asmlib.GetIndexes("A")



local function getDataFormat(sForm, oEnt, ucsEnt, sType, sName, nPnt, sP)
  if(not (oEnt and oEnt:IsValid() and enFlag)) then return "" end
  if(not (ucsEnt and ucsEnt:IsValid())) then return "" end
  local ucsPos, ucsAng, sM = ucsEnt:GetPos(), ucsEnt:GetAngles(), oEnt:GetModel()
  print("lol", ucsPos)
  local sO = ""; if(ucsPos[cvX] ~= 0 or ucsPos[cvY] ~= 0 or ucsPos[cvZ] ~= 0) then
    sO = tostring(ucsPos[cvX])..","..tostring(ucsPos[cvY])..","..tostring(ucsPos[cvZ]) end
  local sA = ""; if(ucsAng[caP] ~= 0 or ucsAng[caY] ~= 0 or ucsAng[caP] ~= 0) then
    sA = tostring(ucsAng[caP])..","..tostring(ucsAng[caY])..","..tostring(ucsAng[caR]) end
  local sC = (oEnt:GetClass() ~= "prop_physics" and oEnt:GetClass() or "")
  local sN = asmlib.IsBlank(sName) and asmlib.ModelToName(sM) or sName
  return sForm:format(sM, sType, sN, tonumber(nPnt or 0), sP, sO, sA, sC)
end

local B = makeEntity()
local U = makeEntity()
B:SetModel("models/props_phx/construct/1windows/window1x2.mdl")
U:SetPos(Vector(7,8,9))
U:SetAngles(Angle(17,18,19))
B:SetClass("asdfg")

print(getDataFormat(gsINS, B, U, "TEST", "", 4, "1,2,3"))





