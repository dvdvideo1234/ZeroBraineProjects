package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local tableConcat = table and table.concat

local common = require("common")
require("../dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
require("../dvdlualib/common")

local asmlib     = trackasmlib
local gaTimerSet = {} -- ("/"):Explode("CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1")
asmlib.InitBase("track", "assembly")
asmlib.SetOpVar("MODE_DATABASE", "SQL")
asmlib.SetOpVar("DATE_FORMAT","%d-%m-%y")
asmlib.SetOpVar("TIME_FORMAT","%H:%M:%S")
asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("S",4,5,6,7)
asmlib.SetOpVar("DIRPATH_BAS", "Assembly/")
asmlib.SetLogControl(1000,false)

------ INITIALIZE DB ------
asmlib.CreateTable("PIECES",{
  Timer = nil, --gaTimerSet[1],
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
      local defTab = makTab:GetDefinition()
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
      if(not asmlib.IsHere(nAddID)) then asmlib.LogInstance("Cannot match <"..
        tostring(arLine[4]).."> to "..defTab[4][1].." for "..tostring(snPK),vSrc); return false end
      stData[nAddID] = {} -- LineID has to be set properly
      while(nCnt <= defTab.Size) do sFld = defTab[nCnt][1]
        stData[nAddID][sFld] = makTab:Match(arLine[nCnt],nCnt)
        if(not asmlib.IsHere(stData[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          asmlib.LogInstance("Cannot match <"..tostring(arLine[nCnt]).."> to "..
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

asmlib.CreateTable("PHYSPROPERTIES",{
  Timer = gaTimerSet[3],
  Index = {{1},{2},{1,2}},
  Trigs = {
    Record = function(arLine)
      arLine[1] = asmlib.GetTerm(arLine[1],"TYPE",asmlib.GetCategory()); return true
    end
  },
  Cache = {
    Record = function(makTab, tCache, snPK, arLine, vSrc)
      local skName = asmlib.GetOpVar("HASH_PROPERTY_NAMES")
      local skType = asmlib.GetOpVar("HASH_PROPERTY_TYPES")
      local defTab = makTab:GetDefinition()
      local tTypes = tCache[skType]; if(not tTypes) then
        tCache[skType] = {}; tTypes = tCache[skType]; tTypes.Size = 0 end
      local tNames = tCache[skName]; if(not tNames) then
        tCache[skName] = {}; tNames = tCache[skName] end
      local iNameID = makTab:Match(arLine[2],2)
      if(not asmlib.IsHere(iNameID)) then -- LineID has to be set properly
        asmlib.LogInstance("Cannot match <"..tostring(arLine[2])..
          "> to "..defTab[2][1].." for <"..tostring(snPK)..">",vSrc); return false end
      if(not asmlib.IsHere(tNames[snPK])) then -- If a new type is inserted
        tTypes.Size = (tTypes.Size + 1)
        tTypes[tTypes.Size] = snPK; tNames[snPK] = {}
        tNames[snPK].Size, tNames[snPK].Slot = 0, snPK
      end -- Data matching crashes only on numbers
      tNames[snPK].Size = iNameID
      tNames[snPK][iNameID] = makTab:Match(arLine[3],3); return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSrc)
      local defTab = makTab:GetDefinition()
      local tTypes = tCache[asmlib.GetOpVar("HASH_PROPERTY_TYPES")]
      local tNames = tCache[asmlib.GetOpVar("HASH_PROPERTY_NAMES")]
      if(not (tTypes or tNames)) then F:Flush(); F:Close()
        asmlib.LogInstance("("..fPref..") No data found",vSrc); return false end
      for iInd = 1, tTypes.Size do local sType = tTypes[iInd]
        local tType = tNames[sType]; if(not tType) then F:Flush(); F:Close()
          asmlib.LogInstance("("..fPref..") Missing index #"..iInd.." on type <"..sType..">",vSrc); return false end
        for iCnt = 1, tType.Size do local vType = tType[iCnt]
          oFile:Write(defTab.Name..sDelim..makTab:Match(sType,1,true,"\"")..
                                   sDelim..makTab:Match(iCnt ,2,true,"\"")..
                                   sDelim..makTab:Match(vType,3,true,"\"").."\n")
        end
      end; return true
    end
  },
  Query = {
    Record = {"%s","%d","%s"},
    ExportDSV = {1,2}
  },
  [1] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [2] = {"LINEID", "INTEGER", "FLR",  nil },
  [3] = {"NAME"  , "TEXT"   ,  nil ,  nil }
},true,true)

asmlib.SetOpVar("STRUCT_SPAWN",{
  Name = "Spawn data definition", Size = 4,
  Draw = {"%+6s",
    ["REC"] = function(scr, key, typ, inf, def, spn)
      local fmt = asmlib.GetOpVar("FORM_DRAWDBG")
      local out = tostring(spn[key] or ""):sub(8, -1)
      local fky = tostring(def.Draw[1] or "%s")
      scr:DrawText(fmt:format(fky:format(key), typ, out, inf))
    end,
    ["MTX"] = function(scr, key, typ, inf, def, spn)
      local fmt = asmlib.GetOpVar("FORM_DRAWDBG")
      local tab = spn[key]:ToTable()
      local fky = tostring(def.Draw[1] or "%s")
      for iR = 1, 4 do
        local out = "{"..tostring(iR).."}["..tableConcat(tab[iR], ",").."]"
        scr:DrawText(fmt:format(fky:format(key), typ, out, inf))
      end
    end,
  },
  {Name = "Origin", Size = 11,
    {"F"   , "VEC", "Origin forward vector"},
    {"R"   , "VEC", "Origin right vector"},
    {"U"   , "VEC", "Origin up vector"},
    {"BPos", "VEC", "Base coordinate position"},
    {"BAng", "ANG", "Base coordinate angle"},
    {"OPos", "VEC", "Origin position"},
    {"OAng", "ANG", "Origin angle"},
    {"SPos", "VEC", "Piece spawn position"},
    {"SAng", "ANG", "Piece spawn angle"},
    {"SMtx", "MTX", "Spawn translation and rotation matrix"},
    {"RLen", "NUM", "Piece active radius"}
  },
  {Name = "Holder", Size = 6,
    {"HRec", "REC", "Pointer to the holder record"},
    {"HID" , "NUM", "Point ID the holder has selected"},
    {"HPnt", "VEC", "P # Holder active point location"},
    {"HOrg", "VEC", "O # Holder piece location origin when snapped"},
    {"HAng", "ANG", "A # Holder piece orientation origin when snapped"},
    {"HMtx", "MTX", "Holder translation and rotation matrix"}
  },
  {Name = "Traced", Size = 6,
    {"TRec", "REC", "Pointer to the trace record"},
    {"TID" , "NUM", "Point ID that the trace has found"},
    {"TPnt", "VEC", "P # Trace active point location"},
    {"TOrg", "VEC", "O # Trace piece location origin when snapped"},
    {"TAng", "ANG", "A # Trace piece orientation origin when snapped"},
    {"TMtx", "MTX", "Trace translation and rotation matrix"}
  },
  {Name = "Offsets", Size = 2,
    {"ANxt", "ANG", "Origin angle offsets"},
    {"PNxt", "VEC", "Piece position offsets"}
  }
})

-- asmlib.ProcessDSV()

-- local sModel = "models/props_phx/construct/1windows/window1x2.mdl"
-- local stPOA = asmlib.LocatePOA(asmlib.CacheQueryPiece(sModel), 1)

-- common.logTable(asmlib.GetBuilderID(1))
-- common.logTable(asmlib.GetCacheSpawn(LocalPlayer()))

function DrawTextSpawn(oScreen, sCol, sMeth, tArgs)
  local ply = LocalPlayer()
  local gnR = asmlib.GetOpVar("GOLDEN_RATIO")
  local stS = asmlib.GetCacheSpawn(ply)
  local arK = asmlib.GetOpVar("STRUCT_SPAWN")
  local w,h = oScreen:GetSize()
  oScreen:SetTextEdge(w - (2 - gnR)*w,0)
  oScreen:DrawText(tostring(arK.Name),sCol,sMeth,tArgs)
  for iD = 1, arK.Size, 1 do local def = arK[iD]
    oScreen:DrawText("---- "..tostring(def.Name).." ----")
    for iK = 1, def.Size do local row = def[iK]
      if(asmlib.IsHere(row[1])) then
        local key = tostring(row[1] or "")
        local typ = tostring(row[2] or "")
        local inf = tostring(row[3] or "")
        local foo = arK.Draw[typ]
        if(foo) then
          local bs, se = pcall(foo, oScreen, key, typ, inf, arK, stS)
          if(not bs) then asmlib.LogInstance(se); return end
        else
          local fmt = asmlib.GetOpVar("FORM_DRAWDBG")
          local val = tostring(stS[key] or "")
          local fky = tostring(arK.Draw[1] or "%s")
          oScreen:DrawText(fmt:format(fky:format(key), typ, val, inf))
        end
      end
    end
  end
end


asmlib.SetButtonSlider = function(cPanel,sVar,sTyp,nMin,nMax,nDec,tBtn)
  local sY, pY, dX, dY = 45, 0, 2, 2; pY = dY
  local sX = asmlib.GetOpVar("WIDTH_CPANEL")
  local sNam = asmlib.GetOpVar("TOOLNAME_PL")..sVar
  local sTag = "tool."..asmlib.GetOpVar("TOOLNAME_NL").."."..sVar
  if(asmlib.IsTable(tBtn) and tBtn[1]) then
    local sPtn = asmlib.GetOpVar("FORM_LOGBTNSLD")
    local nBtn, iCnt, bX, bY = #tBtn, 1, dX, pY
    local wB, hB = ((sX - ((nBtn + 1) * dX)) / nBtn), 20
    while(tBtn[iCnt]) do local vBtn = tBtn[iCnt]
      local sTxt, sTyp = tostring(vBtn.Text), tostring(vBtn.Tip)
      local pButton = {}; if(not IsValid(pButton)) then
        LogInstance(sPtn:format(sVar,sTxt,"Panel invalid")); return nil end
      if(vBtn.Tip) then pButton:SetTooltip(tostring(vBtn.Tip)) end
      pButton.DoClick = function()
        local pS, sE = pcall(vBtn.Click, pButton, sVar, asmlib.GetAsmConvar(sVar, sTyp))
        if(not pS) then asmlib.LogInstance(sPtn:format(sVar,sTxt,"Error: "..sE)); return nil end
      end
      tBtn.__obj = tBtn.__obj or {}
      tBtn.__obj[iCnt] = pButton
      bX, iCnt = (bX + (wB + dX)), (iCnt + 1)
    end; pY = pY + (dY + hB)
  end
  return tBtn
end


 local a = asmlib.SetButtonSlider({},"nextz","FLT",-5, 5,7,
    {{Text="+"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,snapInc(pBut,vV, asmlib.GetAsmConvar("incsnplin","FLT"))) end},
     {Text="-"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,snapInc(pBut,vV,-asmlib.GetAsmConvar("incsnplin","FLT"))) end},
     {Text="+/-" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,-vV) end},
     {Text="@M"  , Click=function(pBut, sNam, vV) SetClipboardText(vV) end},
     {Text="@0"  , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam, 0) end}})

--common.logTable(a)
--a.__obj[5].DoClick()

