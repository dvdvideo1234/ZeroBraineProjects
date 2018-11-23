require("dvdlualib/common")
require("dvdlualib/gmodlib")
require("dvdlualib/asmlib")
local asmlib = trackasmlib
local string = string
      string.Trim = stringTrim
local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format
local gaTimerSet = ("CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1"):Explode("/")

asmlib.InitBase("track","assembly")
asmlib.SetOpVar("MODE_DATABASE" , "LUA")
asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)

asmlib.SetLogControl(1000,false)
asmlib.SetOpVar("DIRPATH_BAS", "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/Assembly/")

asmlib.CreateTable("PIECES",{
  Timer = gaTimerSet[1],
  Index = {{1},{4},{1,4}},
  Trigs = {
    InsertRecord = function(stRow)
      local trCls = asmlib.GetOpVar("TRACE_CLASS")
      stRow[2] = asmlib.DisableString(stRow[2],asmlib.DefaultType(),"TYPE")
      stRow[3] = asmlib.DisableString(stRow[3],asmlib.ModelToName(stRow[1]),"MODEL")
      stRow[8] = asmlib.DisableString(stRow[8],"NULL","NULL")
      if(not ((stRow[8] == "NULL") or trCls[stRow[8]] or asmlib.IsBlank(stRow[8]))) then
        trCls[stRow[8]] = true
        asmlib.LogInstance("Register trace <"..tostring(stRow[8]).."@"..stRow[1]..">")
      end
    end -- Register the class provided to the trace hit list
  },
  Cache = {
    InsertRecord = function(makTab, tCache, snPK, arLine)
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Type)) then stData.Type = arLine[2] end
      if(not asmlib.IsHere(stData.Name)) then stData.Name = arLine[3] end
      if(not asmlib.IsHere(stData.Unit)) then stData.Unit = arLine[8] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      local nOffsID = makTab:Match(arLine[4],4); if(not asmlib.IsHere(nOffsID)) then
        asmlib.LogInstance("Cannot match <"..tostring(arLine[4])..
          "> to "..defTab[4][1].." for "..tostring(snPK)); return false end
      local stPOA = asmlib.RegisterPOA(stData,nOffsID,arLine[5],arLine[6],arLine[7])
        if(not asmlib.IsHere(stPOA)) then
        asmlib.LogInstance("Cannot process offset #"..tostring(nOffsID).." for "
          ..tostring(snPK)); return false end
      if(nOffsID > stData.Size) then stData.Size = nOffsID else
        asmlib.LogInstance("Offset #"..tostring(nOffsID).." sequential mismatch"); return false end
      return true
    end,
    ExportDSV = function(oFile, makTab, tCache, sDelim)
      local tData, defTab = {}, makTab:GetDefinition()
      for mod, rec in pairs(tCache) do
        tData[mod] = {Key = (rec.Type..rec.Name..mod)} end
      local tSort = asmlib.Sort(tData,{Key})
      if(not tSort) then oFile:Flush(); oFile:Close()
        asmlib.LogInstance("("..fPref..") Cannot sort cache data"); return false end
      for iIdx = 1, tSort.Size do local stRec = tSort[iIdx]
        local tData = tCache[stRec.Key]
        local sData = defTab.Name
              sData = sData..sDelim..makTab:Match(stRec.Key,1,true,"\"")..sDelim..
                makTab:Match(tData.Type,2,true,"\"")..sDelim..
                makTab:Match(((asmlib.ModelToName(stRec.Key) == tData.Name) and symOff or tData.Name),3,true,"\"")
        local tOffs = tData.Offs
        -- Matching crashes only for numbers. The number is already inserted, so there will be no crash
        for iInd = 1, #tOffs do
          local stPnt = tData.Offs[iInd]
          oFile:Write(sData..sDelim..makTab:Match(iInd,4,true,"\"")..sDelim..
                   "\""..(asmlib.IsEqualPOA(stPnt.P,stPnt.O) and "" or asmlib.StringPOA(stPnt.P,"V")).."\""..sDelim..
                   "\""..  asmlib.StringPOA(stPnt.O,"V").."\""..sDelim..
                   "\""..( asmlib.IsZeroPOA(stPnt.A,"A") and "" or asmlib.StringPOA(stPnt.A,"A")).."\""..sDelim..
                   "\""..(tData.Unit and tostring(tData.Unit or "") or "").."\"\n")
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

local myTable = {
  ["models/props_phx/construct/metal_plate1x2.mdl"] = { -- Here goes the model of your pack
    {myType ,"#", 1, "","0,-47.455105,1.482965","0,-90,0",""}, -- The first point parameter
    {myType ,"#", 2, "","0, 47.455105,1.482965","0, 90,0",""}  -- The second point parameter
  },
  ["models/props_phx/construct/windows/window1x2.mdl"] = {
    {myType ,"#", 1, "","0,-23.73248,1.482965","0,-90,0",""},
    {myType ,"#", 2, "","0, 71.17773,1.482965","0, 90,0",""}
  }
}

local myPrefix = "xxx_"

if(not asmlib.SynchronizeDSV("PIECES", myTable, true, myPrefix)) then
  error("Failed to synchronize track pieces")
else -- You are saving me from all the work for manually generating these
  asmlib.LogInstance("TranslateDSV start <"..myPrefix..">")
  if(not asmlib.TranslateDSV("PIECES", myPrefix)) then
    error("Failed to translate DSV into Lua") end
  asmlib.LogInstance("TranslateDSV done <"..myPrefix..">")
end -- Now we have Lua inserts and DSV

