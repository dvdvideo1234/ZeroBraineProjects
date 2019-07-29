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

local myPrefix = "aaa"
local myType = "TEST"
local myName = "TEST-NAME"
local myScript = "zzzzzzz"

asmlib.LogInstance(">>> "..myScript)

local myTable = {
  ["models/props_phx/construct/metal_plate1x2.mdl"] = { -- Here goes the model of your pack
    {myType ,myName, 1, "","0,-47.455105,1.482965","0,-90,0",""}, -- The first point parameter
    {myType ,myName, 2, "","0, 47.455105,1.482965","0, 90,0",""}  -- The second point parameter
  },
  ["models/props_phx/construct/windows/window1x2.mdl"] = {
    {myType ,myName, 1, "","0,-23.73248,1.482965","0,-90,0",""},
    {myType ,myName, 2, "","0, 71.17773,1.482965","0, 90,0",""}
  }
}

if(not asmlib.SynchronizeDSV("PIECES", myTable, true, myPrefix)) then
  error("Failed to synchronize track pieces")
else
  if(not asmlib.TranslateDSV("PIECES", myPrefix)) then
    error("Failed to translate DSV into Lua") end
end -- Now we have Lua inserts and DSV

trackasmlib.LogInstance("<<< "..myScript)
