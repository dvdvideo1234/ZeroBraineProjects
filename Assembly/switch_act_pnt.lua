local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki").addBase("D:/LuaIDE").setBase(1)

local common = require("common")

require("gmodlib")
require("trackasmlib")
local asmlib = trackasmlib

if(asmlib.InitBase("track","assembly")) then
asmlib.SetIndexes("V","x","y","z")
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)
asmlib.SetOpVar("MODE_DATABASE", "SQL")
-- asmlib.SetOpVar("LOG_DEBUGEN",true)
asmlib.SetLogControl(10000, false)
asmlib.SetOpVar("TRACE_MARGIN", 0.5)
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gaTimerSet = ("/"):Explode("CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1")

asmlib.CreateTable("PIECES",{
  Timer = gaTimerSet[1],
  Index = {{1},{4},{1,4}},
  Trigs = {
    Record = function(arLine, vSrc)
      local noMD  = asmlib.GetOpVar("MISS_NOMD")
      local noTY  = asmlib.GetOpVar("MISS_NOTP")
      local noSQL = asmlib.GetOpVar("MISS_NOSQL")
      local trCls = asmlib.GetOpVar("TRACE_CLASS")
      arLine[2] = asmlib.GetTerm(arLine[2], noTY, asmlib.GetCategory())
      arLine[3] = asmlib.GetTerm(arLine[3], noMD, asmlib.ModelToName(arLine[1]))
      arLine[8] = asmlib.GetTerm(arLine[8], noSQL, noSQL)
      if(not (asmlib.IsNull(arLine[8]) or trCls[arLine[8]] or asmlib.IsBlank(arLine[8]))) then
        trCls[arLine[8]] = true; asmlib.LogInstance("Register trace <"..
          tostring(arLine[8]).."@"..arLine[1]..">",vSrc)
      end; return true
    end -- Register the class provided to the trace hit list
  },
  Cache = {
    Record = function(makTab, tCache, snPK, arLine, vSrc)
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Type)) then stData.Type = arLine[2] end
      if(not asmlib.IsHere(stData.Name)) then stData.Name = arLine[3] end
      if(not asmlib.IsHere(stData.Unit)) then stData.Unit = arLine[8] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      local nOffsID = makTab:Match(arLine[4],4); if(not asmlib.IsHere(nOffsID)) then
        asmlib.LogInstance("Cannot match <"..tostring(arLine[4])..
          "> to "..defTab[4][1].." for "..tostring(snPK),vSrc); return false end
      local stPOA = asmlib.RegisterPOA(stData,nOffsID,arLine[5],arLine[6],arLine[7])
        if(not asmlib.IsHere(stPOA)) then
        asmlib.LogInstance("Cannot process offset #"..tostring(nOffsID).." for "..
          tostring(snPK),vSrc); return false end
      if(nOffsID > stData.Size) then stData.Size = nOffsID else
        asmlib.LogInstance("Offset #"..tostring(nOffsID)..
          " sequential mismatch",vSrc); return false end
      return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSrc)
      local tData, defTab = {}, makTab:GetDefinition()
      for mod, rec in pairs(tCache) do
        tData[mod] = {KEY = (rec.Type..rec.Name..mod)} end
      local tSort = asmlib.Sort(tData,{"KEY"})
      if(not tSort) then oFile:Flush(); oFile:Close()
        asmlib.LogInstance("("..fPref..") Cannot sort cache data",vSrc); return false end
      for iIdx = 1, tSort.Size do local stRec = tSort[iIdx]
        local tData = tCache[stRec.Key]
        local sData, tOffs = defTab.Name, tData.Offs
              sData = sData..sDelim..makTab:Match(stRec.Key,1,true,"\"")..sDelim..
                makTab:Match(tData.Type,2,true,"\"")..sDelim..
                makTab:Match(((asmlib.ModelToName(stRec.Key) == tData.Name) and symOff or tData.Name),3,true,"\"")
        -- Matching crashes only for numbers. The number is already inserted, so there will be no crash
        for iInd = 1, #tOffs do local stPnt = tData.Offs[iInd]
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
    Record = {"%s","%s","%s","%d","%s","%s","%s","%s"},
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

asmlib.CreateTable("ADDITIONS",{
  Timer = gaTimerSet[2],
  Index = {{1},{4},{1,4}},
  Query = {
    Record = {"%s","%s","%s","%d","%s","%s","%d","%d","%d","%d","%d","%d"},
    ExportDSV = {1,4}
  },
  Cache = {
    Record = function(makTab, tCache, snPK, arLine, vSrc)
      local defTab = makTab:GetDefinition()
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      local nCnt, sFld, nAddID = 2, "", makTab:Match(arLine[4],4)
      if(not asmlib.IsHere(nAddID)) then asmlib.LogInstance("Cannot match "..defTab.Nick.." <"..
        tostring(arLine[4]).."> to "..defTab[4][1].." for "..tostring(snPK),vSrc); return false end
      stData[nAddID] = {} -- LineID has to be set properly
      while(nCnt <= defTab.Size) do sFld = defTab[nCnt][1]
        stData[nAddID][sFld] = makTab:Match(arLine[nCnt],nCnt)
        if(not asmlib.IsHere(stData[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          asmlib.LogInstance("Cannot match "..defTab.Nick.." <"..tostring(arLine[nCnt]).."> to "..
            defTab[nCnt][1].." for "..tostring(snPK),vSrc); return false
        end; nCnt = (nCnt + 1)
      end; stData.Size = nAddID; return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSrc)
      local defTab = makTab:GetDefinition()
      for mod, rec in pairs(tCache) do
        local sData = defTab.Name..sDelim..mod
        for iIdx = 1, #rec do local tData = rec[iIdx]; oFile:Write(sData)
          for iID = 2, defTab.Size do local vData = tData[defTab[iID][1]]
            oFile:Write(sDelim..makTab:Match(tData[defTab[iID][1]],iID,true,"\""))
          end; oFile:Write("\n") -- Data is already inserted, there will be no crash
        end
      end; return true
    end
  },
  [1]  = {"MODELBASE", "TEXT"   , "LOW", "QMK"},
  [2]  = {"MODELADD" , "TEXT"   , "LOW", "QMK"},
  [3]  = {"ENTCLASS" , "TEXT"   ,  nil ,  nil },
  [4]  = {"LINEID"   , "INTEGER", "FLR",  nil },
  [5]  = {"POSOFF"   , "TEXT"   ,  nil ,  nil },
  [6]  = {"ANGOFF"   , "TEXT"   ,  nil ,  nil },
  [7]  = {"MOVETYPE" , "INTEGER", "FLR",  nil },
  [8]  = {"PHYSINIT" , "INTEGER", "FLR",  nil },
  [9]  = {"DRSHADOW" , "INTEGER", "FLR",  nil },
  [10] = {"PHMOTION" , "INTEGER", "FLR",  nil },
  [11] = {"PHYSLEEP" , "INTEGER", "FLR",  nil },
  [12] = {"SETSOLID" , "INTEGER", "FLR",  nil },
},true,true)

local PIECES = asmlib.GetBuilderNick("PIECES")

PIECES:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 1, "", "!test", "", "aaa"})
PIECES:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 2, "", "1,2,4", "", "aaa"})
PIECES:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 3, "", "1,2,4", "!test", "aaa"})
PIECES:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 4, "", "1,2,4", "!test", "aaa"})

local p = asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl")
common.logTable(p,"RECORD")

local TOOL = makeTool(asmlib.GetOpVar("TOOLNAME_NL"))
TOOL.ClientConVar = {
  ["pointid"] = 2,
  ["pnextid"] = 1,
  ["model"] = "models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl",
}

function TOOL:GetPointID()
  return (self:GetClientNumber("pointid") or 1), (self:GetClientNumber("pnextid") or 2)
end

function TOOL:GetModel()
  return tostring(self:GetClientInfo("model") or "")
end

function TOOL:SwitchPoint(vDir, bNxt)
  local oRec = asmlib.CacheQueryPiece(self:GetModel()); if(not oRec) then
    asmlib.LogInstance("Invalid record",gtArgsLogs); return 1, 2 end
  local nDir = (tonumber(vDir) or 0) -- Normalize switch direction
  local pointid, pnextid = self:GetPointID()
  if(bNxt) then pnextid = asmlib.SwitchID(pnextid,nDir,oRec)
  else          pointid = asmlib.SwitchID(pointid,nDir,oRec) end
  if(pnextid == pointid) then pnextid = asmlib.SwitchID(pnextid,nDir,oRec) end
  RunConsoleCommand(gsToolPrefL.."pnextid", pnextid)
  RunConsoleCommand(gsToolPrefL.."pointid", pointid)
  asmlib.LogInstance("("..nDir..","..tostring(bNxt)..") Success",gtArgsLogs)
  return pointid, pnextid
end

print(TOOL:SwitchPoint(1,false))
print(TOOL:SwitchPoint(1,false))
print(TOOL:SwitchPoint(1,false))
print(TOOL:SwitchPoint(1,false))

end