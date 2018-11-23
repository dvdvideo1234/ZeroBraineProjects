require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
local common = require("../dvdlualib/common")
local asmlib = trackasmlib

if(asmlib.InitBase("track","assembly")) then
local gaTimerSet = ("/"):Explode("CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1")
asmlib.SetIndexes("V","x","y","z")
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.SetOpVar("LOG_DEBUGEN",true)
asmlib.SetLogControl(10000, false)
asmlib.SetOpVar("TRACE_MARGIN", 0.5)
asmlib.SetOpVar("DIRPATH_BAS","E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/Assembly/")
local gtArgsLogs  = {"", false, 0}

asmlib.CreateTable("PIECES",{
  Timer = gaTimerSet[1],
  Index = {{1},{4},{1,4}},
  Trigs = {
    InsertRecord = function(arLine) gtArgsLogs[1] = "*PIECES.Trigs.InsertRecord"
      local trCls = asmlib.GetOpVar("TRACE_CLASS")
      arLine[2] = asmlib.DisableString(arLine[2],asmlib.DefaultType(),"TYPE")
      arLine[3] = asmlib.DisableString(arLine[3],asmlib.ModelToName(arLine[1]),"MODEL")
      arLine[8] = asmlib.DisableString(arLine[8],"NULL","NULL")
      if(not ((arLine[8] == "NULL") or trCls[arLine[8]] or asmlib.IsBlank(arLine[8]))) then
        trCls[arLine[8]] = true; asmlib.LogInstance("Register trace <"..
          tostring(arLine[8]).."@"..arLine[1]..">",gtArgsLogs)
      end; return true
    end -- Register the class provided to the trace hit list
  },
  Cache = {
    InsertRecord = function(makTab, tCache, snPK, arLine)
      gtArgsLogs[1] = "*PIECES.Cache.InsertRecord"
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Type)) then stData.Type = arLine[2] end
      if(not asmlib.IsHere(stData.Name)) then stData.Name = arLine[3] end
      if(not asmlib.IsHere(stData.Unit)) then stData.Unit = arLine[8] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      local nOffsID = makTab:Match(arLine[4],4); if(not asmlib.IsHere(nOffsID)) then
        asmlib.LogInstance("Cannot match <"..tostring(arLine[4])..
          "> to "..defTab[4][1].." for "..tostring(snPK),gtArgsLogs); return false end
      local stPOA = asmlib.RegisterPOA(stData,nOffsID,arLine[5],arLine[6],arLine[7])
        if(not asmlib.IsHere(stPOA)) then
        asmlib.LogInstance("Cannot process offset #"..tostring(nOffsID).." for "..
          tostring(snPK),gtArgsLogs); return false end
      if(nOffsID > stData.Size) then stData.Size = nOffsID else
        asmlib.LogInstance("Offset #"..tostring(nOffsID)..
          " sequential mismatch",gtArgsLogs); return false end
      return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim)
      gtArgsLogs[1] = "*PIECES.Cache.ExportDSV"
      local tData, defTab = {}, makTab:GetDefinition()
      for mod, rec in pairs(tCache) do
        tData[mod] = {KEY = (rec.Type..rec.Name..mod)} end
      local tSort = asmlib.Sort(tData,{"KEY"})
      if(not tSort) then oFile:Flush(); oFile:Close()
        asmlib.LogInstance("("..fPref..") Cannot sort cache data",gtArgsLogs); return false end
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

asmlib.CreateTable("PHYSPROPERTIES",{
  Timer = gaTimerSet[3],
  Index = {{1},{2},{1,2}},
  Trigs = {
    InsertRecord = function(atRow)
      asmlib.LogSet("PHYSPROPERTIES.Trigs.InsertRecord")
      atRow[1] = asmlib.DisableString(atRow[1],asmlib.DefaultType(),"TYPE")
      asmlib.LogSet()
    end
  },
  Cache = {
    InsertRecord = function(makTab, tCache, snPK, arLine)
      gtArgsLogs[1] = "*PHYSPROPERTIES.Cache.ExportDSV"
      local skName = asmlib.GetOpVar("HASH_PROPERTY_NAMES")
      local skType = asmlib.GetOpVar("HASH_PROPERTY_TYPES")
      local tTypes = tCache[skType]; if(not tTypes) then
        tCache[skType] = {}; tTypes = tCache[skType]; tTypes.Size = 0 end
      local tNames = tCache[skName]; if(not tNames) then
        tCache[skName] = {}; tNames = tCache[skName] end
      local iNameID = makTab:Match(arLine[2],2)
      if(not asmlib.IsHere(iNameID)) then -- LineID has to be set properly
        asmlib.LogInstance("Cannot match "..defTab.Nick.." <"..tostring(arLine[2])..
          "> to "..defTab[2][1].." for "..tostring(snPK)); return nil end
      if(not asmlib.IsHere(tNames[snPK])) then
        -- If a new type is inserted
        tTypes.Size = tTypes.Size + 1
        tTypes[tTypes.Size] = snPK
        tNames[snPK] = {}
        tNames[snPK].Size = 0
        tNames[snPK].Slot = snPK
      end -- Data matching crashes only on numbers
      tNames[snPK].Size = iNameID
      tNames[snPK][iNameID] = makTab:Match(arLine[3],3)
    end,
    ExportDSV = function(oFile, makTab, tCache, sDelim)
      gtArgsLogs[1] = "*PHYSPROPERTIES.Cache.ExportDSV" 
      local defTab = makTab:GetDefinition()
      local tTypes = tCache[asmlib.GetOpVar("HASH_PROPERTY_TYPES")]
      local tNames = tCache[asmlib.GetOpVar("HASH_PROPERTY_NAMES")]
      if(not (tTypes or tNames)) then F:Flush(); F:Close()
        asmlib.LogInstance("("..fPref..") No data found"); return false end
      for iInd = 1, tTypes.Size do
        local sType = tTypes[iInd]
        local tType = tNames[sType]
        if(not tType) then F:Flush(); F:Close()
          LogInstance("("..fPref..") Missing index #"..iInd.." on type <"..sType..">"); return false end
        for iCnt = 1, tType.Size do
          oFile:Write(defTab.Name..sDelim..makTab:Match(sType      ,1,true,"\"")..
                                   sDelim..makTab:Match(iCnt       ,2,true,"\"")..
                                   sDelim..makTab:Match(tType[iCnt],3,true,"\"").."\n")
        end
      end; return true
    end
  },
  Query = {
    InsertRecord = {"%s","%d","%s"},
    ExportDSV = {1,2}
  },
  [1] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [2] = {"LINEID", "INTEGER", "FLR",  nil },
  [3] = {"NAME"  , "TEXT"   ,  nil ,  nil }
},true,true)

local a = asmlib.GetTable("PIECES"):Select():Where({1,"aaa"}):Order(-2)
local d = a:GetDefinition()
local c = a:GetCommand()
a:Index({1,2},{3,4})
c = a:GetCommand(); a:Index()
c = a:GetCommand(); common.logTable(c,"CMD")


asmlib.DefaultType("TEST-O")
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl", "#", "x1", 1, "", "!test", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl", "#", "x1", 2, "", "1,2,4", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl", "#", "#", 1, "", "0,0,0", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl", "#", "x1", 2, "", "#1,2,3", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl", "#", "x1", 3, "", "#aaaa", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl", "#", "#", 4, "", "", "", "aaa"})

asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl")
asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x612.mdl")
asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x613.mdl")

asmlib.ExportDSV("PIECES","xxx_")


--[[


  asmlib.DefaultTable("ADDITIONS")
  --- Shinji's Switchers ---
  asmlib.InsertRecord({"models/shinji85/train/rail_r_switch.mdl","models/shinji85/train/sw_lever.mdl"        ,"buttonswitch",1,"-100,125,0","",-1,-1,-1,0,-1,-1})
  asmlib.InsertRecord({"models/shinji85/train/rail_r_switch.mdl","models/shinji85/train/rail_r_switcher1.mdl","prop_dynamic",2,"","",123,456,-1,-1,1,333})
  asmlib.InsertRecord({"models/shinji85/train/rail_r_switch.mdl","models/shinji85/train/rail_r_switcher2.mdl","prop_dynamic",3,"","",123,456,-1, 0,-1,444})

asmlib.ExportDSV("ADDITIONS","xxx_")
]]
--[[
asmlib.DefaultTable("PHYSPROPERTIES")
asmlib.DefaultType("Miscellaneous")
asmlib.InsertRecord({"#", 1 , "carpet"       })
asmlib.InsertRecord({"#", 2 , "ceiling_tile" })
asmlib.InsertRecord({"#", 3 , "computer"     })
asmlib.InsertRecord({"#", 4 , "pottery"      })
asmlib.DefaultType("Organic")
asmlib.InsertRecord({"#", 1 , "alienflesh"  })
asmlib.InsertRecord({"#", 2 , "antlion"     })
asmlib.InsertRecord({"#", 3 , "armorflesh"  })
asmlib.InsertRecord({"#", 4 , "bloodyflesh" })
asmlib.InsertRecord({"#", 5 , "flesh"       })
asmlib.InsertRecord({"#", 6 , "foliage"     })
asmlib.InsertRecord({"#", 7 , "watermelon"  })
asmlib.InsertRecord({"#", 8 , "zombieflesh" })


asmlib.LogTable(asmlib.CacheQueryProperty(),"RECORD")
asmlib.LogTable(asmlib.CacheQueryProperty("Organic"),"RECORD")

asmlib.ExportDSV("PHYSPROPERTIES","xxx_")
]]


end