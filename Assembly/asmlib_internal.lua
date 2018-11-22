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

asmlib.CreateTable("ADDITIONS",{
  Timer = gaTimerSet[2],
  Index = {{1},{4},{1,4}},
  Query = {
    InsertRecord = {"%s","%s","%s","%d","%s","%s","%d","%d","%d","%d","%d","%d"},
    ExportDSV = {1,4}
  },
  Cache = {
    InsertRecord = function(makTab, tCache, snPK, arLine)
      local defTab = makTab:GetDefinition()
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      local nCnt, sFld, nAddID = 2, "", makTab:Match(arLine[4],4)
      if(not asmlib.IsHere(nAddID)) then asmlib.LogInstance("Cannot match "..defTab.Nick.." <"..
        tostring(arLine[4]).."> to "..defTab[4][1].." for "..tostring(snPK)); return false end
      stData[nAddID] = {} -- LineID has to be set properly
      while(nCnt <= defTab.Size) do
        sFld = defTab[nCnt][1]
        stData[nAddID][sFld] = makTab:Match(arLine[nCnt],nCnt)
        if(not asmlib.IsHere(stData[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          asmlib.LogInstance("Cannot match "..defTab.Nick.." <"..tostring(arLine[nCnt]).."> to "..
            defTab[nCnt][1].." for "..tostring(snPK)); return false end
        nCnt = nCnt + 1
      end; stData.Size = nAddID; return true
    end,
    ExportDSV = function(oFile, makTab, tCache, sDelim)
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


--[[

asmlib.DefaultType("TEST-O")
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 1, "", "!test", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 2, "", "1,2,4", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl"   , "#", "x1", 1, "", "!test", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl"   , "#", "x1", 2, "", "!test", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl"   , "#", "x1", 3, "", "!test", "", "aaa"})
asmlib.InsertRecord("PIECES",{"models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl"   , "#", "x1", 4, "", "!test", "", "aaa"})



asmlib.ExportDSV("PIECES","xxx_")



asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x61.mdl")
asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x612.mdl")
asmlib.CacheQueryPiece("models/sprops/cuboids/height06/size_1/cube_6x6x613.mdl")

]]

--[[


  asmlib.DefaultTable("ADDITIONS")
  --- Shinji's Switchers ---
  asmlib.InsertRecord({"models/shinji85/train/rail_r_switch.mdl","models/shinji85/train/sw_lever.mdl"        ,"buttonswitch",1,"-100,125,0","",-1,-1,-1,0,-1,-1})
  asmlib.InsertRecord({"models/shinji85/train/rail_r_switch.mdl","models/shinji85/train/rail_r_switcher1.mdl","prop_dynamic",2,"","",123,456,-1,-1,1,333})
  asmlib.InsertRecord({"models/shinji85/train/rail_r_switch.mdl","models/shinji85/train/rail_r_switcher2.mdl","prop_dynamic",3,"","",123,456,-1, 0,-1,444})

asmlib.ExportDSV("ADDITIONS","xxx_")
]]

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

end