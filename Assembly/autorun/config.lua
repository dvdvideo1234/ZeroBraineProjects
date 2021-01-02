local pcall                         = pcall
local Angle                         = Angle
local Vector                        = Vector
local IsValid                       = IsValid
local tobool                        = tobool
local tonumber                      = tonumber
local tostring                      = tostring
local CreateConVar                  = CreateConVar
local SetClipboardText              = SetClipboardText
local osDate                        = os and os.date
local netStart                      = net and net.Start
local netSendToServer               = net and net.SendToServer
local netReceive                    = net and net.Receive
local netReadEntity                 = net and net.ReadEntity
local netReadVector                 = net and net.ReadVector
local netReadString                 = net and net.ReadString
local netReadUInt                   = net and net.ReadUInt
local netWriteString                = net and net.WriteString
local netWriteEntity                = net and net.WriteEntity
local netWriteUInt                  = net and net.WriteUInt
local bitBor                        = bit and bit.bor
local sqlQuery                      = sql and sql.Query
local sqlBegin                      = sql and sql.Begin
local sqlCommit                     = sql and sql.Commit
local guiMouseX                     = gui and gui.MouseX
local guiMouseY                     = gui and gui.MouseY
local guiEnableScreenClicker        = gui and gui.EnableScreenClicker
local entsGetByIndex                = ents and ents.GetByIndex
local mathFloor                     = math and math.floor
local mathClamp                     = math and math.Clamp
local mathRound                     = math and math.Round
local mathMin                       = math and math.min
local gameGetWorld                  = game and game.GetWorld
local tableConcat                   = table and table.concat
local mathAbs                       = math and math.abs
local utilAddNetworkString          = util and util.AddNetworkString
local utilIsValidModel              = util and util.IsValidModel
local vguiCreate                    = vgui and vgui.Create
local fileExists                    = file and file.Exists
local fileFind                      = file and file.Find
local fileWrite                     = file and file.Write
local fileDelete                    = file and file.Delete
local fileTime                      = file and file.Time
local fileSize                      = file and file.Size
local fileOpen                      = file and file.Open
local inputIsKeyDown                = input and input.IsKeyDown
local inputIsMouseDown              = input and input.IsMouseDown
local inputGetCursorPos             = input and input.GetCursorPos
local surfaceScreenWidth            = surface and surface.ScreenWidth
local surfaceScreenHeight           = surface and surface.ScreenHeight
local gamemodeCall                  = gamemode and gamemode.Call
local cvarsAddChangeCallback        = cvars and cvars.AddChangeCallback
local cvarsRemoveChangeCallback     = cvars and cvars.RemoveChangeCallback
local propertiesAdd                 = properties and properties.Add
local propertiesGetHovered          = properties and properties.GetHovered
local propertiesCanBeTargeted       = properties and properties.CanBeTargeted
local constraintFindConstraints     = constraint and constraint.FindConstraints
local constraintFind                = constraint and constraint.Find
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier

------ MODULE POINTER -------
local asmlib     = trackasmlib
local gtArgsLogs = {"", false, 0}
local gtInitLogs = {"*Init", false, 0}

------ CONFIGURE ASMLIB ------
asmlib.InitBase("track","assembly")
asmlib.SetOpVar("TOOL_VERSION","7.596")
asmlib.SetIndexes("V" ,    "x",  "y",   "z")
asmlib.SetIndexes("A" ,"pitch","yaw","roll")
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)

------ CONFIGURE GLOBAL INIT OPVARS ------
local gsNoID      = asmlib.GetOpVar("MISS_NOID") -- No such ID
local gsNoMD      = asmlib.GetOpVar("MISS_NOMD") -- No model
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVISION")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gnRatio     = asmlib.GetOpVar("GOLDEN_RATIO")
local gnMaxOffRot = asmlib.GetOpVar("MAX_ROTATION")
local gsLimitName = asmlib.GetOpVar("CVAR_LIMITNAME")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")
local gsToolNameU = asmlib.GetOpVar("TOOLNAME_NU")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsToolPrefU = asmlib.GetOpVar("TOOLNAME_PU")
local gsLangForm  = asmlib.GetOpVar("FORM_LANGPATH")
local gsNoAnchor  = gsNoID..gsSymRev..gsNoMD
local gtTransFile = fileFind(gsLangForm:format("lua/", "*.lua"), "GAME")
local gsFullDSV   = asmlib.GetOpVar("DIRPATH_BAS")..asmlib.GetOpVar("DIRPATH_DSV")..
                    asmlib.GetInstPref()..asmlib.GetOpVar("TOOLNAME_PU")

------ VARIABLE FLAGS ------
local varLanguage = GetConVar("gmod_language")
-- Client and server have independent value
local gnIndependentUsed = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
-- Server tells the client what value to use
local gnServerControled = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY, FCVAR_REPLICATED)

------ CONFIGURE LOGGING ------
asmlib.SetOpVar("LOG_DEBUGEN",false)
asmlib.MakeAsmConvar("logsmax"  , 0 , {0}   , gnIndependentUsed, "Maximum logging lines being written")
asmlib.MakeAsmConvar("logfile"  , 0 , {0, 1}, gnIndependentUsed, "File logging output flag control")
asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"),asmlib.GetAsmConvar("logfile","BUL"))
asmlib.SettingsLogs("SKIP"); asmlib.SettingsLogs("ONLY")

------ CONFIGURE NON-REPLICATED CVARS ----- Client's got a mind of its own
asmlib.MakeAsmConvar("modedb"   , "LUA",     nil , gnIndependentUsed, "Database storage operating mode LUA or SQL")
asmlib.MakeAsmConvar("devmode"  ,    0 , {0, 1  }, gnIndependentUsed, "Toggle developer mode on/off server side")
asmlib.MakeAsmConvar("maxtrmarg", 0.02 , {0.0001}, gnIndependentUsed, "Maximum time to avoid performing new traces")
asmlib.MakeAsmConvar("timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1", nil, gnIndependentUsed, "Memory management setting when DB mode is SQL")

------ CONFIGURE REPLICATED CVARS ----- Server tells the client what value to use
asmlib.MakeAsmConvar("maxmass"  , 50000 ,  {1}, gnServerControled, "Maximum mass that can be applied on a piece")
asmlib.MakeAsmConvar("maxlinear", 1000  ,  {1}, gnServerControled, "Maximum linear offset of the piece")
asmlib.MakeAsmConvar("maxforce" , 100000,  {0}, gnServerControled, "Maximum force limit when creating welds")
asmlib.MakeAsmConvar("maxactrad", 150, {1,500}, gnServerControled, "Maximum active radius to search for a point ID")
asmlib.MakeAsmConvar("maxstcnt" , 200, {1,800}, gnServerControled, "Maximum spawned pieces in stacking mode")
asmlib.MakeAsmConvar("enwiremod", 1  , {0, 1 }, gnServerControled, "Toggle the wire extension on/off server side")
asmlib.MakeAsmConvar("enctxmenu", 1  , {0, 1 }, gnServerControled, "Toggle the context menu on/off in general")
asmlib.MakeAsmConvar("enctxmall", 0  , {0, 1 }, gnServerControled, "Toggle the context menu on/off for all props")
asmlib.MakeAsmConvar("endsvlock", 0  , {0, 1 }, gnServerControled, "Toggle the DSV external database file update on/off")

if(SERVER) then
  asmlib.MakeAsmConvar("bnderrmod","LOG",   nil  , gnServerControled, "Unreasonable position error handling mode")
  asmlib.MakeAsmConvar("maxfruse" ,  50 , {1,100}, gnServerControled, "Maximum frequent pieces to be listed")
  asmlib.MakeAsmConvar("*sbox_max"..gsLimitName, 1500, {0}, gnServerControled, "Maximum number of tracks to be spawned")
end

------ CONFIGURE INTERNALS -----
asmlib.IsFlag("new_close_frame", false) -- The old state for frame shorcut detecting a pulse
asmlib.IsFlag("old_close_frame", false) -- The new state for frame shorcut detecting a pulse
asmlib.IsFlag("tg_context_menu", false) -- Raises whenever the user opens the game context menu
asmlib.IsFlag("en_dsv_datalock", asmlib.GetAsmConvar("endsvlock", "BUL"))
asmlib.SetOpVar("MODE_DATABASE", asmlib.GetAsmConvar("modedb"   , "STR"))
asmlib.SetOpVar("TRACE_MARGIN" , asmlib.GetAsmConvar("maxtrmarg", "FLT"))

------ BORDERS -------------
asmlib.SetBorder("non-neg", 0, asmlib.GetOpVar("INFINITY"))

------ GLOBAL VARIABLES ------
local gsMoDB      = asmlib.GetOpVar("MODE_DATABASE")
local gaTimerSet  = asmlib.GetOpVar("OPSYM_DIRECTORY"):Explode(asmlib.GetAsmConvar("timermode","STR"))
local conPalette  = asmlib.MakeContainer("COLORS_LIST")
      conPalette:Record("a" ,asmlib.GetColor(  0,  0,  0,  0)) -- Invisible
      conPalette:Record("r" ,asmlib.GetColor(255,  0,  0,255)) -- Red
      conPalette:Record("g" ,asmlib.GetColor(  0,255,  0,255)) -- Green
      conPalette:Record("b" ,asmlib.GetColor(  0,  0,255,255)) -- Blue
      conPalette:Record("c" ,asmlib.GetColor(  0,255,255,255)) -- Cyan
      conPalette:Record("m" ,asmlib.GetColor(255,  0,255,255)) -- Magenta
      conPalette:Record("y" ,asmlib.GetColor(255,255,  0,255)) -- Yellow
      conPalette:Record("w" ,asmlib.GetColor(255,255,255,255)) -- White
      conPalette:Record("k" ,asmlib.GetColor(  0,  0,  0,255)) -- Black
      conPalette:Record("gh",asmlib.GetColor(255,255,255,150)) -- Ghosts base color
      conPalette:Record("tx",asmlib.GetColor( 80, 80, 80,255)) -- Panel names text color
      conPalette:Record("an",asmlib.GetColor(180,255,150,255)) -- Selected anchor
      conPalette:Record("db",asmlib.GetColor(220,164, 52,255)) -- Database mode
      conPalette:Record("ry",asmlib.GetColor(230,200, 80,255)) -- Ray tracing
      conPalette:Record("wm",asmlib.GetColor(143,244, 66,255)) -- Working mode HUD
      conPalette:Record("bx",asmlib.GetColor(250,250,200,255)) -- Radial menu box

local conElements = asmlib.MakeContainer("LIST_VGUI")
local conWorkMode = asmlib.MakeContainer("WORK_MODE")
      conWorkMode:Push("SNAP" ) -- General spawning and snapping mode
      conWorkMode:Push("CROSS") -- Ray cross intersect interpolation

-------- CALLBACKS ----------
local gsVarName -- This stores current variable name
local gsCbcHash = "_init" -- This keeps suffix realted to the file

gsVarName = asmlib.GetAsmConvar("maxtrmarg", "NAM")
cvarsRemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvarsAddChangeCallback(gsVarName, function(sVar, vOld, vNew)
  local nM = (tonumber(vNew) or 0)
        nM = ((nM > 0) and nM or 0)
  asmlib.SetOpVar("TRACE_MARGIN", nM)
end, gsVarName..gsCbcHash)

gsVarName = asmlib.GetAsmConvar("logsmax", "NAM")
cvarsRemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvarsAddChangeCallback(gsVarName, function(sVar, vOld, vNew)
  local nM = asmlib.BorderValue((tonumber(vNew) or 0), "non-neg")
  asmlib.SetOpVar("LOG_MAXLOGS", nM)
end, gsVarName..gsCbcHash)

gsVarName = asmlib.GetAsmConvar("logfile", "NAM")
cvarsRemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvarsAddChangeCallback(gsVarName, function(sVar, vOld, vNew)
  asmlib.IsFlag("en_logging_file", tobool(vNew))
end, gsVarName..gsCbcHash)

gsVarName = asmlib.GetAsmConvar("endsvlock", "NAM")
cvarsRemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvarsAddChangeCallback(gsVarName, function(sVar, vOld, vNew)
  asmlib.IsFlag("en_dsv_datalock", tobool(vNew))
end, gsVarName..gsCbcHash)

gsVarName = asmlib.GetAsmConvar("timermode", "NAM")
cvarsRemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvarsAddChangeCallback(gsVarName, function(sVar, vOld, vNew)
  local arTim = asmlib.GetOpVar("OPSYM_DIRECTORY"):Explode(vNew)
  local mkTab, ID = asmlib.GetBuilderID(1), 1
  while(mkTab) do local sTim = arTim[ID]
    local defTab = mkTab:GetDefinition(); mkTab:TimerSetup(sTim)
    asmlib.LogInstance("Timer apply "..asmlib.GetReport2(defTab.Nick,sTim),gtInitLogs)
    ID = ID + 1; mkTab = asmlib.GetBuilderID(ID) -- Next table on the list
  end; asmlib.LogInstance("Timer update "..asmlib.GetReport(vNew),gtInitLogs)
end, gsVarName..gsCbcHash)

-------- RECORDS ----------
asmlib.SetOpVar("STRUCT_SPAWN",{
  Name = "Spawn data definition",
  Draw = {
    ["RDB"] = function(scr, key, typ, inf, def, spn)
      local rec, fmt = spn[key], asmlib.GetOpVar("FORM_DRAWDBG")
      local fky, nav = asmlib.GetOpVar("FORM_DRWSPKY"), asmlib.GetOpVar("MISS_NOAV")
      local out = (rec and tostring(rec.Slot:GetFileFromFilename()) or nav)
      scr:DrawText(fmt:format(fky:format(key), typ, out, inf))
    end,
    ["MTX"] = function(scr, key, typ, inf, def, spn)
      local tab = spn[key]:ToTable()
      local fmt = asmlib.GetOpVar("FORM_DRAWDBG")
      local fky = asmlib.GetOpVar("FORM_DRWSPKY")
      for iR = 1, 4 do
        local out = asmlib.GetReport2(iR,tableConcat(tab[iR], ","))
        scr:DrawText(fmt:format(fky:format(key), typ, out, inf))
      end
    end,
  },
  {Name = "Origin",
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
  {Name = "Holder",
    {"HRec", "RDB", "Pointer to the holder record"},
    {"HID" , "NUM", "Point ID the holder has selected"},
    {"HPnt", "VEC", "P # Holder active point location"},
    {"HOrg", "VEC", "O # Holder piece location origin when snapped"},
    {"HAng", "ANG", "A # Holder piece orientation origin when snapped"},
    {"HMtx", "MTX", "Holder translation and rotation matrix"}
  },
  {Name = "Traced",
    {"TRec", "RDB", "Pointer to the trace record"},
    {"TID" , "NUM", "Point ID that the trace has found"},
    {"TPnt", "VEC", "P # Trace active point location"},
    {"TOrg", "VEC", "O # Trace piece location origin when snapped"},
    {"TAng", "ANG", "A # Trace piece orientation origin when snapped"},
    {"TMtx", "MTX", "Trace translation and rotation matrix"}
  },
  {Name = "Offsets",
    {"ANxt", "ANG", "Origin angle offsets"},
    {"PNxt", "VEC", "Piece position offsets"}
  }
})

-------- ACTIONS ----------
if(SERVER) then

  -- Send language definitions to the client to populate the menu
  for iD = 1, #gtTransFile do AddCSLuaFile(gsLangForm:format("",gtTransFile[iD])) end

  utilAddNetworkString(gsLibName.."SendIntersectClear")
  utilAddNetworkString(gsLibName.."SendIntersectRelate")

  asmlib.SetAction("DUPE_PHYS_SETTINGS", -- Duplicator wrapper
    function(oPly,oEnt,tData) gtArgsLogs[1] = "*DUPE_PHYS_SETTINGS"
      if(not asmlib.ApplyPhysicalSettings(oEnt,tData[1],tData[2],tData[3],tData[4])) then
        asmlib.LogInstance("Failed to apply physical settings on "..tostring(oEnt),gtArgsLogs); return nil end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end)

  asmlib.SetAction("PLAYER_QUIT",
    function(oPly) gtArgsLogs[1] = "*PLAYER_QUIT" -- Clear player cache when disconnects
      if(not asmlib.CacheClear(oPly)) then
        asmlib.LogInstance("Failed swiping stuff "..tostring(oPly),gtArgsLogs); return nil end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end)

  asmlib.SetAction("PHYSGUN_DROP",
    function(pPly, trEnt) gtArgsLogs[1] = "*PHYSGUN_DROP"
      if(not asmlib.IsPlayer(pPly)) then
        asmlib.LogInstance("Player invalid",gtArgsLogs); return nil end
      if(pPly:GetInfoNum(gsToolPrefL.."engunsnap", 0) == 0) then
        asmlib.LogInstance("Snapping disabled",gtArgsLogs); return nil end
      if(not (trEnt and trEnt:IsValid())) then
        asmlib.LogInstance("Trace entity invalid",gtArgsLogs); return nil end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel()); if(not trRec) then
        asmlib.LogInstance("Trace not piece",gtArgsLogs); return nil end
      local nMaxOffLin = asmlib.GetAsmConvar("maxlinear","FLT")
      local bnderrmod  = asmlib.GetAsmConvar("bnderrmod","STR")
      local ignphysgn  = (pPly:GetInfoNum(gsToolPrefL.."ignphysgn" , 0) ~= 0)
      local freeze     = (pPly:GetInfoNum(gsToolPrefL.."freeze"    , 0) ~= 0)
      local gravity    = (pPly:GetInfoNum(gsToolPrefL.."gravity"   , 0) ~= 0)
      local weld       = (pPly:GetInfoNum(gsToolPrefL.."weld"      , 0) ~= 0)
      local nocollide  = (pPly:GetInfoNum(gsToolPrefL.."nocollide" , 0) ~= 0)
      local nocollidew = (pPly:GetInfoNum(gsToolPrefL.."nocollidew", 0) ~= 0)
      local spnflat    = (pPly:GetInfoNum(gsToolPrefL.."spnflat"   , 0) ~= 0)
      local igntype    = (pPly:GetInfoNum(gsToolPrefL.."igntype"   , 0) ~= 0)
      local physmater  = (pPly:GetInfo   (gsToolPrefL.."physmater" , "metal"))
      local nextx      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextx"   , 0),-nMaxOffLin , nMaxOffLin)
      local nexty      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nexty"   , 0),-nMaxOffLin , nMaxOffLin)
      local nextz      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextz"   , 0),-nMaxOffLin , nMaxOffLin)
      local nextpic    = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextpic" , 0),-gnMaxOffRot,gnMaxOffRot)
      local nextyaw    = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextyaw" , 0),-gnMaxOffRot,gnMaxOffRot)
      local nextrol    = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextrol" , 0),-gnMaxOffRot,gnMaxOffRot)
      local forcelim   = mathClamp(pPly:GetInfoNum(gsToolPrefL.."forcelim", 0),0,asmlib.GetAsmConvar("maxforce" , "FLT"))
      local activrad   = mathClamp(pPly:GetInfoNum(gsToolPrefL.."activrad", 0),1,asmlib.GetAsmConvar("maxactrad", "FLT"))
      local trPos, trAng, trRad, trID, trTr = trEnt:GetPos(), trEnt:GetAngles(), activrad, 0
      for ID = 1, trRec.Size, 1 do -- Hits distance shorter than the active radius
        local oTr, oDt = asmlib.GetTraceEntityPoint(trEnt, ID, activrad)
        local rTr = (activrad * oTr.Fraction) -- Estimate active fraction length
        if(oTr and oTr.Hit and (rTr < trRad)) then local eTr = oTr.Entity
          if(eTr and eTr:IsValid()) then trRad, trID, trTr = rTr, ID, oTr end
        end
      end -- The trace with the shortest distance is found
      if(trTr and trTr.Hit and (trID > 0) and (trID <= trRec.Size)) then
        local stSpawn = asmlib.GetEntitySpawn(pPly,trTr.Entity,trTr.HitPos,trRec.Slot,trID,
                          activrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
        if(stSpawn) then
          if(not asmlib.SetPosBound(trEnt,stSpawn.SPos or GetOpVar("VEC_ZERO"),pPly,bnderrmod)) then
            asmlib.LogInstance("User "..pPly:Nick().." snapped <"..trRec.Slot.."> outside bounds",gtArgsLogs); return nil end
          trEnt:SetAngles(stSpawn.SAng)
          if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
            asmlib.LogInstance("Failed to apply physical settings",gtArgsLogs); return nil end
          if(not asmlib.ApplyPhysicalAnchor(trEnt,trTr.Entity,weld,nocollide,nocollidew,forcelim)) then
            asmlib.LogInstance("Failed to apply physical anchor",gtArgsLogs); return nil end
        end
      end
    end)
end

if(CLIENT) then asmlib.InitLocalify(varLanguage:GetString())

  asmlib.ToIcon(gsToolPrefU.."PIECES"        , "database_connect")
  asmlib.ToIcon(gsToolPrefU.."ADDITIONS"     , "bricks"          )
  asmlib.ToIcon(gsToolPrefU.."PHYSPROPERTIES", "wand"            )
  asmlib.ToIcon(gsToolPrefL.."context_menu"  , "database_gear"   )
  asmlib.ToIcon("category_item", "folder"         )
  asmlib.ToIcon("pn_externdb_1", "database"       )
  asmlib.ToIcon("pn_externdb_2", "folder_database")
  asmlib.ToIcon("pn_externdb_3", "database_table" )
  asmlib.ToIcon("pn_externdb_4", "database_link"  )
  asmlib.ToIcon("pn_externdb_5", "time_go"        )
  asmlib.ToIcon("pn_externdb_6", "compress"       )
  asmlib.ToIcon("pn_externdb_7", "database_edit"  )
  asmlib.ToIcon("pn_externdb_8", "database_delete")
  asmlib.ToIcon("model"        , "brick"          )
  asmlib.ToIcon("mass"         , "basket_put"     )
  asmlib.ToIcon("bgskids"      , "layers"         )
  asmlib.ToIcon("phyname"      , "wand"           )
  asmlib.ToIcon("ignphysgn"    , "lightning_go"   )
  asmlib.ToIcon("freeze"       , "lock"           )
  asmlib.ToIcon("gravity"      , "ruby_put"       )
  asmlib.ToIcon("weld"         , "wrench"         )
  asmlib.ToIcon("nocollide"    , "shape_group"    )
  asmlib.ToIcon("nocollidew"   , "world_go"       )
  asmlib.ToIcon("dsvlist_extdb", "database_go"    )

  asmlib.SetAction("CTXMENU_OPEN" , function() asmlib.IsFlag("tg_context_menu", true ) end)
  asmlib.SetAction("CTXMENU_CLOSE", function() asmlib.IsFlag("tg_context_menu", false) end)

  asmlib.SetAction("CLEAR_RELATION",
    function(nLen) local oPly = netReadEntity(); gtArgsLogs[1] = "*CLEAR_RELATION"
      asmlib.LogInstance("{"..tostring(nLen)..","..tostring(oPly).."}",gtArgsLogs)
      if(not asmlib.IntersectRayClear(oPly, "relate")) then
        asmlib.LogInstance("Failed clearing ray",gtArgsLogs); return nil end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end) -- Net receive intersect relation clear client-side

  asmlib.SetAction("CREATE_RELATION",
    function(nLen) gtArgsLogs[1] = "*CREATE_RELATION"
      local oEnt, vHit, oPly = netReadEntity(), netReadVector(), netReadEntity()
      asmlib.LogInstance("{"..tostring(nLen)..","..tostring(oPly).."}",gtArgsLogs)
      if(not asmlib.IntersectRayCreate(oPly, oEnt, vHit, "relate")) then
        asmlib.LogInstance("Failed updating ray",gtArgsLogs); return nil end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end) -- Net receive intersect relation create client-side

  asmlib.SetAction("BIND_PRESS", -- Must have the same parameters as the hook
    function(oPly,sBind,bPress) gtArgsLogs[1] = "*BIND_PRESS"
      local oPly, actSwep, actTool = asmlib.GetHookInfo(gtArgsLogs)
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",gtArgsLogs); return nil end
      if(((sBind == "invnext") or (sBind == "invprev")) and bPress) then
        -- Switch functionality of the mouse wheel only for TA
        if(not inputIsKeyDown(KEY_LALT)) then
          asmlib.LogInstance("Active key missing",gtArgsLogs); return nil end
        if(not actTool:GetScrollMouse()) then
          asmlib.LogInstance("(SCROLL) Scrolling disabled",gtArgsLogs); return nil end
        local nDir = ((sBind == "invnext") and -1) or ((sBind == "invprev") and 1) or 0
        actTool:SwitchPoint(nDir,inputIsKeyDown(KEY_LSHIFT))
        asmlib.LogInstance("("..sBind..") Processed",gtArgsLogs); return true
      elseif((sBind == "+zoom") and bPress) then -- Workmode radial menu selection
        if(inputIsMouseDown(MOUSE_MIDDLE)) then -- Reserve the mouse middle for radial menu
          if(not actTool:GetRadialMenu()) then -- Zoom is bind on the middle mouse button
            asmlib.LogInstance("("..sBind..") Menu disabled",gtArgsLogs); return nil end
          asmlib.LogInstance("("..sBind..") Processed",gtArgsLogs); return true
        end; return nil -- Need to disable the zoom when bind on the mouse middle
      end -- Override only for TA and skip touching anything else
      asmlib.LogInstance("("..sBind..") Skipped",gtArgsLogs); return nil
    end) -- Read client configuration

  asmlib.SetAction("DRAW_RADMENU", -- Must have the same parameters as the hook
    function() gtArgsLogs[1] = "*DRAW_RADMENU"
      local oPly, actSwep, actTool = asmlib.GetHookInfo(gtArgsLogs)
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",gtArgsLogs) return nil end
      if(not actTool:GetRadialMenu()) then
        asmlib.LogInstance("Menu disabled",gtArgsLogs); return nil end
      if(inputIsMouseDown(MOUSE_MIDDLE)) then guiEnableScreenClicker(true) else
        guiEnableScreenClicker(false); asmlib.LogInstance("Scroll release",gtArgsLogs); return nil
      end -- Draw while holding the mouse middle button
      local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
      local actMonitor = asmlib.MakeScreen(0,0,scrW,scrH,conPalette,"GAME")
      if(not actMonitor) then asmlib.LogInstance("Invalid screen",gtArgsLogs); return nil end
      local vBs = asmlib.NewXY(4,4)
      local nN  = conWorkMode:GetSize()
      local nDr = asmlib.GetOpVar("DEG_RAD")
      local sM  = asmlib.GetOpVar("MISS_NOAV")
      local nR  = (asmlib.GetOpVar("GOLDEN_RATIO")-1)
      local vCn = asmlib.NewXY(mathFloor(scrW/2),mathFloor(scrH/2))
      -- Calculate dependent parameters
      local vFr = asmlib.NewXY(vCn.y*nR) -- Far radius vector
      local vNr = asmlib.NewXY(vFr.x*nR) -- Near radius vector
      local dQb = (vFr.x - vNr.x) -- Bigger selected size
      local dQs = (dQb * nR) -- Smaller not selected size
      local vMr = asmlib.NewXY(dQb / 2 + vNr.x) -- Middle radius vector
      local vNt, vFt = asmlib.NewXY(), asmlib.NewXY() -- Temp storage
      local nMx = (asmlib.GetOpVar("MAX_ROTATION") * nDr) -- Max angle [2pi]
      local dA, rA = (nMx / (2 * nN)), 0; actMonitor:GetColor() -- Angle delta
      local mP = asmlib.NewXY(guiMouseX(), guiMouseY())
      actMonitor:DrawCircle(mP, 10, "y", "SURF") -- Draw mouse position
      -- Obtain the wiper angle relative to screen center
      local aW = asmlib.GetAngleXY(asmlib.NegY(asmlib.SubXY(vNt, mP, vCn)))
      -- Move menu selection wiper based on the calculated angle
      asmlib.SetXY(vNt, vNr); asmlib.NegY(asmlib.RotateXY(vNt, aW)); asmlib.AddXY(vNt, vNt, vCn)
      actMonitor:DrawLine(vCn, vNt, "w", "SURF"); actMonitor:DrawCircle(vNt, 8);
      -- Convert wiper angle to selection ID
      aW = ((aW < 0) and (aW + nMx) or aW) -- Convert [0;+pi;-pi;0] to [0;2pi]
      local iW = mathFloor(((aW / nMx) * nN) + 1) -- Calculate fraction ID
      -- Draw segment line dividers
      for iD = 1, nN do
        asmlib.SetXY(vNt, vNr); asmlib.NegY(asmlib.RotateXY(vNt, rA))
        asmlib.SetXY(vFt, vFr); asmlib.NegY(asmlib.RotateXY(vFt, rA))
        asmlib.AddXY(vNt, vNt, vCn); asmlib.AddXY(vFt, vFt, vCn)
        actMonitor:DrawLine(vNt, vFt, "w") -- Draw divider line
        rA = (rA + dA) -- Calculate text center position
        asmlib.SetXY(vNt, vMr); asmlib.NegY(asmlib.RotateXY(vNt, rA))
        asmlib.AddXY(vNt, vNt, vCn) -- Rectangle center point in /vNt/
        if(iD == iW) then asmlib.SetXY(vFt, dQb, dQb) else asmlib.SetXY(vFt, dQs, dQs) end
        actMonitor:DrawRect(vNt,vFt,"k","SURF",{"vgui/white", rA})
        asmlib.SubXY(vFt, vFt, vBs); actMonitor:DrawRect(vNt,vFt,"bx")
        local sW = tostring(conWorkMode:Select(iD) or sM) -- Read selection name
        actMonitor:DrawTextCenter(vNt,sW,"k","SURF",{"Trebuchet24"})
        rA = (rA + dA) -- Prepare to draw the next divider line
      end; asmlib.SetAsmConvar(oPly, "workmode", iW); return true
    end)

  asmlib.SetAction("DRAW_GHOSTS", -- Must have the same parameters as the hook
    function() gtArgsLogs[1] = "*DRAW_GHOSTS"
      local oPly, actSwep, actTool = asmlib.GetHookInfo(gtArgsLogs)
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",gtArgsLogs); return nil end
      local model    = actTool:GetModel()
      local stackcnt = actTool:GetStackCount()
      local ghostcnt = actTool:GetGhostsCount()
      local depthcnt = mathMin(stackcnt, ghostcnt)
      local atGhosts = asmlib.GetOpVar("ARRAY_GHOST")
      if(utilIsValidModel(model)) then
        if(not (asmlib.HasGhosts() and depthcnt == atGhosts.Size and atGhosts.Slot == model)) then
          if(not asmlib.MakeGhosts(depthcnt, model)) then
            asmlib.LogInstance("Ghosting fail",gtArgsLogs); return nil end
          actTool:ElevateGhost(atGhosts[1], oPly) -- Elevate the properly created ghost
        end; actTool:UpdateGhost(oPly) -- Update ghosts stack for the local player
      end
    end) -- Read client configuration

  asmlib.SetAction("OPEN_EXTERNDB", -- Must have the same parameters as the hook
    function(oPly,oCom,oArgs) gtArgsLogs[1] = "*OPEN_EXTERNDB"
      local scrW = surfaceScreenWidth()
      local scrH = surfaceScreenHeight()
      local nRat = asmlib.GetOpVar("GOLDEN_RATIO")
      local sVer = asmlib.GetOpVar("TOOL_VERSION")
      local xyPos, nAut  = asmlib.NewXY(scrW/4,scrH/4), (nRat - 1)
      local xyDsz, xyTmp = asmlib.NewXY(5,5), asmlib.NewXY()
      local xySiz = asmlib.NewXY(nAut * scrW, nAut * scrH)
      local pnFrame = vguiCreate("DFrame"); if(not IsValid(pnFrame)) then
        asmlib.LogInstance("Frame invalid",gtArgsLogs); return nil end
      pnFrame:SetPos(xyPos.x, xyPos.y)
      pnFrame:SetSize(xySiz.x, xySiz.y)
      pnFrame:SetTitle(asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb_hd").." "..oPly:Nick().." {"..sVer.."}")
      pnFrame:SetDraggable(true)
      pnFrame:SetDeleteOnClose(false)
      pnFrame.OnClose = function(pnSelf)
        local iK = conElements:Find(pnSelf) -- Find panel key index
        if(IsValid(pnSelf)) then pnSelf:Remove() end -- Delete the valid panel
        if(asmlib.IsHere(iK)) then conElements:Pull(iK) end -- Pull the key out
      end
      local pnSheet = vguiCreate("DPropertySheet")
      if(not IsValid(pnSheet)) then pnFrame:Close()
        asmlib.LogInstance("Sheet invalid",gtArgsLogs); return nil end
      pnSheet:SetParent(pnFrame)
      pnSheet:Dock(FILL)
      local sOff = asmlib.GetOpVar("OPSYM_DISABLE")
      local sMis = asmlib.GetOpVar("MISS_NOAV")
      local sLib = asmlib.GetOpVar("NAME_LIBRARY")
      local sBas = asmlib.GetOpVar("DIRPATH_BAS")
      local sPrU = asmlib.GetOpVar("TOOLNAME_PU")
      local sRev = asmlib.GetOpVar("OPSYM_REVISION")
      local sDsv = sBas..asmlib.GetOpVar("DIRPATH_DSV")
      local fDSV = sDsv..("%s"..sPrU.."%s.txt")
      local sNam = (sBas..sLib.."_dsv.txt")
      local pnDSV = vguiCreate("DPanel")
      if(not IsValid(pnDSV)) then pnFrame:Close()
        asmlib.LogInstance("DSV list invalid",gtArgsLogs); return nil end
      pnDSV:SetParent(pnSheet)
      pnDSV:DockMargin(xyDsz.x, xyDsz.y, xyDsz.x, xyDsz.y)
      pnDSV:DockPadding(xyDsz.x, xyDsz.y, xyDsz.x, xyDsz.y)
      pnDSV:Dock(FILL)
      local tInfo = pnSheet:AddSheet("DSV", pnDSV, asmlib.ToIcon("dsvlist_extdb"))
      tInfo.Tab:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb").." DSV")
      local nW, nH = pnFrame:GetSize()
      xyPos.x, xyPos.y = xyDsz.x, xyDsz.y
      xySiz.x = (nW - 6 * xyDsz.x)
      xySiz.y = ((nH - 6 * xyDsz.y) - 52)
      local wUse = mathFloor(0.803398874 * xySiz.x)
      local wAct = mathFloor(0.196601126 * xySiz.x)
      local pnListView = vguiCreate("DListView")
      if(not IsValid(pnListView)) then pnFrame:Close()
        asmlib.LogInstance("Listview invalid",gtArgsLogs); return nil end
      pnListView:SetParent(pnDSV)
      pnListView:SetVisible(true)
      pnListView:SetSortable(false)
      pnListView:SetMultiSelect(false)
      pnListView:SetPos(xyPos.x,xyPos.y)
      pnListView:SetSize(xySiz.x,xySiz.y)
      pnListView:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_ext_dsv_lb"))
      pnListView:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_ext_dsv_hd"))
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_ext_dsv_1")):SetFixedWidth(wUse)
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_ext_dsv_2")):SetFixedWidth(wAct)
      pnListView:AddColumn(""):SetFixedWidth(0) -- The hidden path to the population file
      if(not fileExists(sNam, "DATA")) then fileWrite(sNam, "") end
      local oDSV = fileOpen(sNam, "rb", "DATA"); if(not oDSV) then pnFrame:Close()
        asmlib.LogInstance("DSV list missing",gtArgsLogs); return nil end
      local sDel, sLine, bEOF, bAct = "\t", "", false, true
      while(not bEOF) do
        sLine, bEOF = asmlib.GetStringFile(oDSV)
        if(not asmlib.IsBlank(sLine)) then local sKey, sPrg
          if(sLine:sub(1,1) ~= sOff) then bAct = true else
            bAct, sLine = false, sLine:sub(2,-1):Trim() end
          local nB, nE = sLine:find("%s+")
          if(nB and nE) then
            sKey = sLine:sub(1, nB-1)
            sPrg = sLine:sub(nE+1,-1)
          else sKey, sPrg = sLine, sMis end
          pnListView:AddLine(sKey, tostring(bAct), sPrg):SetTooltip(sPrg)
        end
      end; oDSV:Close()
      pnListView.OnRowSelected = function(pnSelf, nIndex, pnLine)
        if(inputIsMouseDown(MOUSE_LEFT)) then
          if(inputIsKeyDown(KEY_LSHIFT)) then -- Delecte the file
            fileDelete(sNam); pnSelf:Clear()  -- The panel will be recreated
          else pnSelf:RemoveLine(nIndex) end  -- Just remove the line selected
        end -- Process only the left mouse button
      end
      pnListView.OnRowRightClick = function(pnSelf, nIndex, pnLine)
        if(inputIsMouseDown(MOUSE_RIGHT)) then
          if(inputIsKeyDown(KEY_LSHIFT)) then -- Export all lines to the file
            local oDSV = fileOpen(sNam, "wb", "DATA")
            if(not oDSV) then pnFrame:Close()
              asmlib.LogInstance("DSV list missing",gtArgsLogs); return nil end
            local tLine = pnSelf:GetLines()
            for iK, pnCur in pairs(tLine) do
              local sPrf = pnCur:GetColumnText(1)
              local sCom = ((pnCur:GetColumnText(2) == "true") and "" or sOff)
              local sPth = pnCur:GetColumnText(3)
              oDSV:Write(sCom..sPrf..sDel..sPth.."\n")
            end; oDSV:Flush(); oDSV:Close()
          else
            local sPrf = pnLine:GetColumnText(1)
            local sCom = ((pnLine:GetColumnText(2) == "true") and "" or sOff)
            local sPth = pnLine:GetColumnText(3)
            SetClipboardText(sCom..sPrf..sPth)
          end
        end -- Process only the right mouse button
      end -- Populate the tables for every database
      local iD, makTab = 1, asmlib.GetBuilderID(1)
      while(makTab) do
        local pnTable = vguiCreate("DPanel")
        if(not IsValid(pnTable)) then pnFrame:Close()
          asmlib.LogInstance("Category invalid",gtArgsLogs); return nil end
        local defTab = makTab:GetDefinition()
        pnTable:SetParent(pnSheet)
        pnTable:DockMargin(xyDsz.x, xyDsz.y, xyDsz.x, xyDsz.y)
        pnTable:DockPadding(xyDsz.x, xyDsz.y, xyDsz.x, xyDsz.y)
        pnTable:Dock(FILL)
        local tInfo = pnSheet:AddSheet(defTab.Nick, pnTable, asmlib.ToIcon(defTab.Name))
        tInfo.Tab:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb").." "..defTab.Nick)
        local tFile = fileFind(fDSV:format("*", defTab.Nick), "DATA")
        if(asmlib.IsTable(tFile) and tFile[1]) then
          local nF, nW, nH = #tFile, pnFrame:GetSize()
          xySiz.x, xyPos.x, xyPos.y = (nW - 6 * xyDsz.x), xyDsz.x, xyDsz.y
          xySiz.y = (((nH - 6 * xyDsz.y) - ((nF -1) * xyDsz.y) - 52) / nF)
          for iP = 1, nF do local sCur = tFile[iP]
            local pnManage = vguiCreate("DButton")
            if(not IsValid(pnSheet)) then pnFrame:Close()
              asmlib.LogInstance("Button invalid ["..tostring(iP).."]",gtArgsLogs); return nil end
            local nB, nE = sCur:upper():find(sPrU..defTab.Nick);
            if(nB and nE) then
              local sPref = sCur:sub(1, nB - 1)
              local sFile = fDSV:format(sPref, defTab.Nick)
              pnManage:SetParent(pnTable)
              pnManage:SetPos(xyPos.x, xyPos.y)
              pnManage:SetSize(xySiz.x, xySiz.y)
              pnManage:SetFont("Trebuchet24")
              pnManage:SetText(sPref)
              pnManage:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb_lb").." "..sFile)
              pnManage.DoRightClick = function(pnSelf)
                local pnMenu = vguiCreate("DMenu")
                if(not IsValid(pnMenu)) then pnFrame:Close()
                  asmlib.LogInstance("Menu invalid",gtArgsLogs); return nil end
                local iO, tOptions = 1, {
                  function() SetClipboardText(pnSelf:GetText()) end,
                  function() SetClipboardText(sDsv) end,
                  function() SetClipboardText(defTab.Nick) end,
                  function() SetClipboardText(sFile) end,
                  function() SetClipboardText(asmlib.GetDateTime(fileTime(sFile, "DATA"))) end,
                  function() SetClipboardText(tostring(fileSize(sFile, "DATA")).."B") end,
                  function() asmlib.SetAsmConvar(oPly, "*luapad", gsToolNameL) end,
                  function() fileDelete(sFile); asmlib.LogInstance("Deleted <"..sFile..">",gtArgsLogs)
                    if(defTab.Nick == "PIECES") then local sCat = fDSV:format(sPref,"CATEGORY")
                      if(fileExists(sCat,"DATA")) then fileDelete(sCat)
                        asmlib.LogInstance("Deleted <"..sCat..">",gtArgsLogs) end
                    end; pnManage:Remove()
                  end
                }
                while(tOptions[iO]) do local sO = tostring(iO)
                  local sDescr = asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb_"..sO)
                  pnMenu:AddOption(sDescr, tOptions[iO]):SetIcon(asmlib.ToIcon("pn_externdb_"..sO))
                  iO = iO + 1 -- Loop trought the functions list and add to the menu
                end; pnMenu:Open()
              end
            else asmlib.LogInstance("File mising ["..tostring(iP).."]",gtArgsLogs) end
            xyPos.y = xyPos.y + xySiz.y + xyDsz.y
          end
        else
          asmlib.LogInstance("Missing <"..defTab.Nick..">",gtArgsLogs)
        end
        iD = (iD + 1); makTab = asmlib.GetBuilderID(iD)
      end; pnFrame:SetVisible(true); pnFrame:Center(); pnFrame:MakePopup(); collectgarbage()
      conElements:Push(pnFrame); asmlib.LogInstance("Success",gtArgsLogs); return nil
    end) -- Read client configuration

  asmlib.SetAction("RESET_VARIABLES",
    function(oPly,oCom,oArgs) gtArgsLogs[1] = "*RESET_VARIABLES"
      local devmode = asmlib.GetAsmConvar("devmode", "BUL")
      asmlib.LogInstance("{"..tostring(devmode).."@"..tostring(command).."}",gtArgsLogs)
      if(inputIsKeyDown(KEY_LSHIFT)) then
        if(not devmode) then
          asmlib.LogInstance("Developer mode disabled",gtArgsLogs); return nil end
        asmlib.SetAsmConvar(oPly, "*sbox_max"..gsLimitName, 1500)
        for key, val in pairs(asmlib.GetConvarList()) do
          asmlib.SetAsmConvar(oPly, "*"..key, val) end
        asmlib.SetAsmConvar(oPly, "logsmax"  , 0)
        asmlib.SetAsmConvar(oPly, "logfile"  , 0)
        asmlib.SetAsmConvar(oPly, "modedb"   , "LUA")
        asmlib.SetAsmConvar(oPly, "devmode"  , 0)
        asmlib.SetAsmConvar(oPly, "maxtrmarg", 0.02)
        asmlib.SetAsmConvar(oPly, "timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1")
        asmlib.SetAsmConvar(oPly, "maxmass"  , 50000)
        asmlib.SetAsmConvar(oPly, "maxlinear", 250)
        asmlib.SetAsmConvar(oPly, "maxforce" , 100000)
        asmlib.SetAsmConvar(oPly, "maxactrad", 150)
        asmlib.SetAsmConvar(oPly, "maxstcnt" , 200)
        asmlib.SetAsmConvar(oPly, "enwiremod", 1)
        asmlib.SetAsmConvar(oPly, "enctxmall", 0)
        asmlib.SetAsmConvar(oPly, "bnderrmod", "LOG")
        asmlib.SetAsmConvar(oPly, "maxfruse" , 50)
        asmlib.LogInstance("Variables reset complete",gtArgsLogs)
      else
        asmlib.SetAsmConvar(oPly,"nextx"  , 0)
        asmlib.SetAsmConvar(oPly,"nexty"  , 0)
        asmlib.SetAsmConvar(oPly,"nextz"  , 0)
        asmlib.SetAsmConvar(oPly,"nextpic", 0)
        asmlib.SetAsmConvar(oPly,"nextyaw", 0)
        asmlib.SetAsmConvar(oPly,"nextrol", 0)
        if(devmode) then
          asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"),
                               asmlib.GetAsmConvar("logfile","BUL"))
        end
      end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end)

  asmlib.SetAction("OPEN_FRAME",
    function(oPly,oCom,oArgs) gtArgsLogs[1] = "*OPEN_FRAME"
      local frUsed, nCount = asmlib.GetFrequentModels(oArgs[1]); if(not asmlib.IsHere(frUsed)) then
        asmlib.LogInstance("Retrieving most frequent models failed ["..tostring(oArgs[1]).."]",gtArgsLogs); return nil end
      local makTab = asmlib.GetBuilderNick("PIECES"); if(not asmlib.IsHere(makTab)) then
        asmlib.LogInstance("Missing builder for table PIECES",gtArgsLogs); return nil end
      local defTab = makTab:GetDefinition(); if(not defTab) then
        asmlib.LogInstance("Missing definition for table PIECES",gtArgsLogs); return nil end
      local pnFrame = vguiCreate("DFrame"); if(not IsValid(pnFrame)) then
        asmlib.LogInstance("Frame invalid",gtArgsLogs); return nil end
      ------ Screen resolution and configuration -------
      local scrW         = surfaceScreenWidth()
      local scrH         = surfaceScreenHeight()
      local nRatio       = asmlib.GetOpVar("GOLDEN_RATIO")
      local sVersion     = asmlib.GetOpVar("TOOL_VERSION")
      local xyZero       = {x =  0, y = 20} -- The start location of left-top
      local xyDelta      = {x = 10, y = 10} -- Distance between panels
      local xySiz        = {x =  0, y =  0} -- Current panel size
      local xyPos        = {x =  0, y =  0} -- Current panel position
      local xyTmp        = {x =  0, y =  0} -- Temporary coordinate
      ------------ Frame --------------
      xySiz.x = (scrW / nRatio) -- This defines the size of the frame
      xyPos.x, xyPos.y = (scrW / 4), (scrH / 4)
      xySiz.y = mathFloor(xySiz.x / (1 + nRatio))
      pnFrame:SetTitle(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_hd").." "..oPly:Nick().." {"..sVersion.."}")
      pnFrame:SetVisible(true)
      pnFrame:SetDraggable(true)
      pnFrame:SetDeleteOnClose(false)
      pnFrame:SetPos(xyPos.x, xyPos.y)
      pnFrame:SetSize(xySiz.x, xySiz.y)
      pnFrame.OnClose = function(pnSelf)
        local iK = conElements:Find(pnSelf) -- Find panel key index
        if(IsValid(pnSelf)) then pnSelf:Remove() end -- Delete the valid panel
        if(asmlib.IsHere(iK)) then conElements:Pull(iK) end -- Pull the key out
      end
      ------------ Button --------------
      xyTmp.x, xyTmp.y = pnFrame:GetSize()
      xySiz.x = (xyTmp.x / (8.5 * nRatio)) -- Display properly the name
      xySiz.y = (xySiz.x / (1.5 * nRatio)) -- Used by combo-box and text-box
      xyPos.x = xyZero.x + xyDelta.x
      xyPos.y = xyZero.y + xyDelta.y
      local pnButton = vguiCreate("DButton")
      if(not IsValid(pnButton)) then pnFrame:Close()
        asmlib.LogInstance("Button invalid",gtArgsLogs); return nil end
      pnButton:SetParent(pnFrame)
      pnButton:SetPos(xyPos.x, xyPos.y)
      pnButton:SetSize(xySiz.x, xySiz.y)
      pnButton:SetVisible(true)
      pnButton:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_export_lb"))
      pnButton:SetText(asmlib.GetPhrase("tool."..gsToolNameL..".pn_export_lb"))
      pnButton:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_export"))
      pnButton.DoClick = function(pnSelf)
        asmlib.LogInstance("Button.DoClick <"..pnSelf:GetText()..">",gtArgsLogs)
        if(asmlib.GetAsmConvar("exportdb", "BUL")) then
          asmlib.LogInstance("Export DB",gtArgsLogs)
          asmlib.ExportCategory(3)
          asmlib.ExportDSV("PIECES")
          asmlib.ExportDSV("ADDITIONS")
          asmlib.ExportDSV("PHYSPROPERTIES")
          asmlib.SetAsmConvar(oPly, "exportdb", 0)
        end
      end
      ------------- ComboBox ---------------
      xyPos.x, xyPos.y = pnButton:GetPos()
      xyTmp.x, xyTmp.y = pnButton:GetSize()
      xyPos.x = xyPos.x + xyTmp.x + xyDelta.x
      xySiz.x, xySiz.y = (nRatio * xyTmp.x), xyTmp.y
      local pnComboBox = vguiCreate("DComboBox")
      if(not IsValid(pnComboBox)) then pnFrame:Close()
        asmlib.LogInstance("Combo invalid",gtArgsLogs); return nil end
      pnComboBox:SetParent(pnFrame)
      pnComboBox:SetPos(xyPos.x,xyPos.y)
      pnComboBox:SetSize(xySiz.x,xySiz.y)
      pnComboBox:SetVisible(true)
      pnComboBox:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb"))
      pnComboBox:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol"))
      pnComboBox:SetValue(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb"))
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb1"), defTab[1][1])
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb2"), defTab[2][1])
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb3"), defTab[3][1])
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb4"), defTab[4][1])
      pnComboBox.OnSelect = function(pnSelf, nInd, sVal, anyData)
        asmlib.LogInstance("ComboBox.OnSelect ID #"..nInd.."<"..sVal..">"..tostring(anyData),gtArgsLogs)
        pnSelf:SetValue(sVal)
      end
      ------------ ModelPanel --------------
      xyTmp.x, xyTmp.y = pnFrame:GetSize()
      xyPos.x, xyPos.y = pnComboBox:GetPos()
      xySiz.x = (xyTmp.x / (1.9 * nRatio)) -- Display the model properly
      xyPos.x = xyTmp.x - xySiz.x - xyDelta.x
      xySiz.y = xyTmp.y - xyPos.y - xyDelta.y
      --------------------------------------
      local pnModelPanel = vguiCreate("DModelPanel")
      if(not IsValid(pnModelPanel)) then pnFrame:Close()
        asmlib.LogInstance("Model display invalid",gtArgsLogs); return nil end
      pnModelPanel:SetParent(pnFrame)
      pnModelPanel:SetPos(xyPos.x,xyPos.y)
      pnModelPanel:SetSize(xySiz.x,xySiz.y)
      pnModelPanel:SetVisible(true)
      pnModelPanel:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_display_lb"))
      pnModelPanel:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_display"))
      pnModelPanel.LayoutEntity = function(pnSelf, oEnt)
        if(pnSelf.bAnimated) then pnSelf:RunAnimation() end
        local uiBox = asmlib.CacheBoxLayout(oEnt,40); if(not asmlib.IsHere(uiBox)) then
          asmlib.LogInstance("ModelPanel.LayoutEntity Box invalid",gtArgsLogs); return nil end
        local stSpawn = asmlib.GetNormalSpawn(oPly,asmlib.GetOpVar("VEC_ZERO"),uiBox.Ang,oEnt:GetModel(),1)
              stSpawn.SPos:Set(uiBox.Cen)
              stSpawn.SPos:Rotate(stSpawn.SAng)
              stSpawn.SPos:Mul(-1)
              stSpawn.SPos:Add(uiBox.Cen)
        oEnt:SetAngles(stSpawn.SAng)
        oEnt:SetPos(stSpawn.SPos)
      end
      ------------ TextEntry --------------
      xyPos.x, xyPos.y = pnComboBox:GetPos()
      xyTmp.x, xyTmp.y = pnComboBox:GetSize()
      xyPos.x = xyPos.x + xyTmp.x + xyDelta.x
      xySiz.y = xyTmp.y
      -------------------------------------
      xyTmp.x, xyTmp.y = pnModelPanel:GetPos()
      xySiz.x = xyTmp.x - xyPos.x - xyDelta.x
      -------------------------------------
      local pnTextEntry = vguiCreate("DTextEntry")
      if(not IsValid(pnTextEntry)) then pnFrame:Close()
        asmlib.LogInstance("Textbox invalid",gtArgsLogs); return nil end
      pnTextEntry:SetParent(pnFrame)
      pnTextEntry:SetPos(xyPos.x,xyPos.y)
      pnTextEntry:SetSize(xySiz.x,xySiz.y)
      pnTextEntry:SetVisible(true)
      pnTextEntry:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_pattern_lb"))
      pnTextEntry:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_pattern"))
      pnTextEntry.OnEnter = function(pnSelf)
        local sPat = tostring(pnSelf:GetValue() or "")
        local sAbr, sCol = pnComboBox:GetSelected() -- Returns two values
              sAbr, sCol = tostring(sAbr or ""), tostring(sCol or "")
        if(not asmlib.UpdateListView(pnListView,frUsed,nCount,sCol,sPat)) then
          asmlib.LogInstance("TextEntry.OnEnter Failed to update ListView {"
            ..sAbr.."#"..sCol.."#"..sPat.."}",gtArgsLogs); return nil
        end
      end
      ------------ ListView --------------
      xyPos.x, xyPos.y = pnButton:GetPos()
      xyTmp.x, xyTmp.y = pnButton:GetSize()
      xyPos.y = xyPos.y + xyTmp.y + xyDelta.y
      ------------------------------------
      xyTmp.x, xyTmp.y = pnTextEntry:GetPos()
      xySiz.x, xySiz.y = pnTextEntry:GetSize()
      xySiz.x = xyTmp.x + xySiz.x - xyDelta.x
      ------------------------------------
      xyTmp.x, xyTmp.y = pnFrame:GetSize()
      xySiz.y = xyTmp.y - xyPos.y - xyDelta.y
      ------------------------------------
      local wUse = mathFloor(0.120377559 * xySiz.x)
      local wAct = mathFloor(0.047460893 * xySiz.x)
      local wTyp = mathFloor(0.314127559 * xySiz.x)
      local wNam = xySiz.x - wUse - wAct - wTyp
      local pnListView = vguiCreate("DListView")
      if(not IsValid(pnListView)) then pnFrame:Close()
        asmlib.LogInstance("Listview invalid",gtArgsLogs); return nil end
      pnListView:SetParent(pnFrame)
      pnListView:SetVisible(false)
      pnListView:SetSortable(true)
      pnListView:SetMultiSelect(false)
      pnListView:SetPos(xyPos.x,xyPos.y)
      pnListView:SetSize(xySiz.x,xySiz.y)
      pnListView:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb"))
      pnListView:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine"))
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb1")):SetFixedWidth(wUse) -- (1)
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb2")):SetFixedWidth(wAct) -- (2)
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb3")):SetFixedWidth(wTyp) -- (3)
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb4")):SetFixedWidth(wNam) -- (4)
      pnListView:AddColumn(""):SetFixedWidth(0) -- (5) This is actually the hidden model of the piece used.
      pnListView.OnRowSelected = function(pnSelf, nIndex, pnLine)
        local uiMod =  tostring(pnLine:GetColumnText(5)  or asmlib.GetOpVar("MISS_NOMD")) -- Actually the model in the table
        local uiAct = (tonumber(pnLine:GetColumnText(2)) or 0); pnModelPanel:SetModel(uiMod) -- Active points amount
        local uiBox = asmlib.CacheBoxLayout(pnModelPanel:GetEntity(),0,nRatio,nRatio-1); if(not asmlib.IsHere(uiBox)) then
          asmlib.LogInstance("ListView.OnRowSelected Box invalid for <"..uiMod..">",gtArgsLogs); return nil end
        pnModelPanel:SetLookAt(uiBox.Eye); pnModelPanel:SetCamPos(uiBox.Cam)
        local pointid, pnextid = asmlib.GetAsmConvar("pointid","INT"), asmlib.GetAsmConvar("pnextid","INT")
              pointid, pnextid = asmlib.SnapReview(pointid, pnextid, uiAct); SetClipboardText(uiMod)
        asmlib.SetAsmConvar(oPly,"pointid", pointid)
        asmlib.SetAsmConvar(oPly,"pnextid", pnextid)
        asmlib.SetAsmConvar(oPly, "model" , uiMod)
      end -- Copy the line model to the clipboard so it can be pasted with Ctrl+V
      pnListView.OnRowRightClick = function(pnSelf, nIndex, pnLine)
        local nCnt, nX, nY = 0, inputGetCursorPos(); nX, nY = pnSelf:ScreenToLocal(nX, nY)
        while(nX > 0) do nCnt = (nCnt + 1); nX = (nX - pnSelf:ColumnWidth(nCnt)) end
        SetClipboardText(pnLine:GetColumnText(nCnt))
      end
      if(not asmlib.UpdateListView(pnListView,frUsed,nCount)) then
        asmlib.LogInstance("ListView.OnRowSelected Populate the list view failed",gtArgsLogs); return nil end
      pnFrame:SetVisible(true); pnFrame:Center(); pnFrame:MakePopup(); collectgarbage()
      conElements:Push(pnFrame); asmlib.LogInstance("Success",gtArgsLogs); return nil
    end)

  asmlib.SetAction("DRAW_PHYSGUN",
    function() gtArgsLogs[1] = "*DRAW_PHYSGUN"
      if(not asmlib.GetAsmConvar("engunsnap", "BUL")) then
        asmlib.LogInstance("Extension disabled",gtArgsLogs); return nil end
      if(not asmlib.GetAsmConvar("adviser", "BUL")) then
        asmlib.LogInstance("Adviser disabled",gtArgsLogs); return nil end
      if(not inputIsMouseDown(MOUSE_LEFT)) then
        asmlib.LogInstance("Physgun not hold",gtArgsLogs); return nil end
      local oPly, actSwep = asmlib.GetHookInfo(gtArgsLogs, "weapon_physgun")
      if(not oPly) then asmlib.LogInstance("Hook mismatch",gtArgsLogs); return nil end
      local actTr = asmlib.GetCacheTrace(oPly); if(not actTr) then
        asmlib.LogInstance("Trace missing",gtArgsLogs); return nil end
      if(not actTr.Hit) then asmlib.LogInstance("Trace not hit",gtArgsLogs); return nil end
      if(actTr.HitWorld) then asmlib.LogInstance("Trace world",gtArgsLogs); return nil end
      local trEnt = actTr.Entity; if(not (trEnt and trEnt:IsValid())) then
        asmlib.LogInstance("Trace entity invalid",gtArgsLogs); return nil end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel()); if(not trRec) then
        asmlib.LogInstance("Trace not piece",gtArgsLogs); return nil end
      local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
      local actMonitor = asmlib.MakeScreen(0,0,scrW,scrH,conPalette,"GAME")
      if(not actMonitor) then asmlib.LogInstance("Invalid screen",gtArgsLogs); return nil end
      local nMaxOffLin = asmlib.GetAsmConvar("maxlinear","FLT")
      local sizeucs  = mathClamp(asmlib.GetAsmConvar("sizeucs", "FLT"),0,nMaxOffLin)
      local nextx    = mathClamp(asmlib.GetAsmConvar("nextx"  , "FLT"),0,nMaxOffLin)
      local nexty    = mathClamp(asmlib.GetAsmConvar("nexty"  , "FLT"),0,nMaxOffLin)
      local nextz    = mathClamp(asmlib.GetAsmConvar("nextz"  , "FLT"),0,nMaxOffLin)
      local nextpic  = mathClamp(asmlib.GetAsmConvar("nextpic", "FLT"),-gnMaxOffRot,gnMaxOffRot)
      local nextyaw  = mathClamp(asmlib.GetAsmConvar("nextyaw", "FLT"),-gnMaxOffRot,gnMaxOffRot)
      local nextrol  = mathClamp(asmlib.GetAsmConvar("nextrol", "FLT"),-gnMaxOffRot,gnMaxOffRot)
      local igntype  = asmlib.GetAsmConvar("igntype" , "BUL")
      local spnflat  = asmlib.GetAsmConvar("spnflat" , "BUL")
      local activrad = asmlib.GetAsmConvar("activrad", "FLT")
      local atGhosts = asmlib.GetOpVar("ARRAY_GHOST"); asmlib.FadeGhosts(true)
      for trID = 1, trRec.Size, 1 do
        local oTr, oDt = asmlib.GetTraceEntityPoint(trEnt, trID, activrad)
        local xyS, xyE = oDt.start:ToScreen(), oDt.endpos:ToScreen()
        local rdS = asmlib.GetCacheRadius(oPly, oTr.HitPos, 1)
        if(oTr and oTr.Hit) then actMonitor:GetColor()
          local tgE, xyH = oTr.Entity, oTr.HitPos:ToScreen()
          if(tgE and tgE:IsValid()) then
            actMonitor:DrawCircle(xyS, rdS, "y", "SURF")
            actMonitor:DrawLine  (xyS, xyH, "g", "SURF")
            actMonitor:DrawCircle(xyH, rdS, "g")
            actMonitor:DrawLine  (xyH, xyE, "y")
            actSpawn = asmlib.GetEntitySpawn(oPly,tgE,oTr.HitPos,trRec.Slot,trID,activrad,
                         spnflat,igntype, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
            if(actSpawn) then
              if(utilIsValidModel(trRec.Slot)) then -- The model has valid precashe
                local ghostcnt = asmlib.GetAsmConvar("ghostcnt", "FLT")
                if(ghostcnt > 0) then -- The ghosting is enabled
                  if(not (asmlib.HasGhosts() and atGhosts.Size == 1 and trRec.Slot == atGhosts.Slot)) then
                    if(not asmlib.MakeGhosts(1, trRec.Slot)) then
                      asmlib.LogInstance("Ghosting fail",gtArgsLogs); return nil end
                  end local eGho = atGhosts[1]; eGho:SetNoDraw(false)
                  eGho:SetPos(actSpawn.SPos); eGho:SetAngles(actSpawn.SAng)
                end -- When the ghosting is disabled saves memory
              else asmlib.ClearGhosts(nil, false) end
              local xyO = actSpawn.OPos:ToScreen()
              local xyB = actSpawn.BPos:ToScreen()
              local xyS = actSpawn.SPos:ToScreen()
              local xyP = actSpawn.TPnt:ToScreen()
              actMonitor:DrawLine  (xyH, xyP, "g")
              actMonitor:DrawCircle(xyP, rdS / 2, "r")
              actMonitor:DrawCircle(xyB, rdS, "y")
              actMonitor:DrawLine  (xyB, xyP, "r")
              actMonitor:DrawLine  (xyB, xyO, "y")
              -- Origin and spawn information
              actMonitor:DrawLine  (xyO, xyS, "m")
              actMonitor:DrawCircle(xyS, rdS, "c")
              -- Origin and base coordinate systems
              actMonitor:DrawUCS(actSpawn.OPos, actSpawn.OAng, "SURF", {sizeucs, rdS})
              actMonitor:DrawUCS(actSpawn.BPos, actSpawn.BAng)
            else local tgRec = asmlib.CacheQueryPiece(tgE:GetModel())
              if(not asmlib.IsHere(tgRec)) then return nil end
              for tgI = 1, tgRec.Size do
                local tgPOA = asmlib.LocatePOA(tgRec, tgI); if(not asmlib.IsHere(tgPOA)) then
                  asmlib.LogInstance("ID #"..tostring(ID).." not located",gtArgsLogs); return nil end
                actMonitor:DrawPOA(oPly,tgE,tgPOA,activrad,rdS)
              end
            end
          else
            actMonitor:DrawCircle(xyS, rdS, "y", "SURF")
            actMonitor:DrawLine  (xyS, xyH, "y", "SURF")
            actMonitor:DrawCircle(xyH, rdS, "y")
            actMonitor:DrawLine  (xyH, xyE, "r")
          end
        else
          actMonitor:DrawCircle(xyS, rdS, "y", "SURF")
          actMonitor:DrawLine  (xyS, xyE, "r", "SURF")
        end
      end
    end)

end

------ INITIALIZE CONTEXT PROPERTIES ------
local gsOptionsCM = gsToolPrefL.."context_menu"
local gsOptionsCV = gsToolPrefL.."context_values"
local gsOptionsLG = gsOptionsCM:gsub(gsToolPrefL, ""):upper()
local gtOptionsCM = {} -- This stores the context menu configuration
gtOptionsCM.Order, gtOptionsCM.MenuIcon = 1600, asmlib.ToIcon(gsOptionsCM)
gtOptionsCM.MenuLabel = asmlib.GetPhrase("tool."..gsToolNameL..".name")

-- [1]: Translation language key
-- [2]: Flag to transmit the data to the server
-- [3]: Tells what is to be done with the value
-- [4]: Display when the data is available on the client
-- [5]: Network massage or assign the value to a player
local conContextMenu = asmlib.MakeContainer("CONTEXT_MENU")
      conContextMenu:Push(
        {"tool."..gsToolNameL..".model", true,
          function(ePiece, oPly, oTr, sKey)
            local model = ePiece:GetModel()
            asmlib.SetAsmConvar(oPly, "model", model); return true
          end,
          function(ePiece, oPly, oTr, sKey)
            return tostring(ePiece:GetModel())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".bgskids", true,
          function(ePiece, oPly, oTr, sKey)
            local ski = asmlib.GetPropSkin(ePiece)
            local bgr = asmlib.GetPropBodyGroup(ePiece)
            asmlib.SetAsmConvar(oPly, "bgskids", bgr..gsSymDir..ski); return true
          end,
          function(ePiece, oPly, oTr, sKey)
            local ski = asmlib.GetPropSkin(ePiece)
            local bgr = asmlib.GetPropBodyGroup(ePiece)
            return tostring(bgr..gsSymDir..ski)
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".phyname", true,
          function(ePiece, oPly, oTr, sKey)
            local phPiece = ePiece:GetPhysicsObject()
            local physmater = phPiece:GetMaterial()
            asmlib.SetAsmConvar(oPly, "physmater", physmater); return true
          end, nil,
          function(ePiece)
            return tostring(ePiece:GetPhysicsObject():GetMaterial())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".mass", true,
          function(ePiece, oPly, oTr, sKey)
            local phPiece = ePiece:GetPhysicsObject()
            local mass = phPiece:GetMass()
            asmlib.SetAsmConvar(oPly, "mass", mass); return true
          end, nil,
          function(ePiece)
            return tonumber(ePiece:GetPhysicsObject():GetMass())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".ignphysgn", true,
          function(ePiece, oPly, oTr, sKey)
            local bSuc,bPi,bFr,bGr,sPh = asmlib.UnpackPhysicalSettings(ePiece)
            if(bSuc) then bPi = (not bPi) else return bSuc end
            return asmlib.ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
          end, nil,
          function(ePiece)
            return tobool(ePiece.PhysgunDisabled)
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".freeze", true,
          function(ePiece, oPly, oTr, sKey)
            local bSuc,bPi,bFr,bGr,sPh = asmlib.UnpackPhysicalSettings(ePiece)
            if(bSuc) then bFr = (not bFr) else return bSuc end
            return asmlib.ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
          end, nil,
          function(ePiece)
            return tobool(not ePiece:GetPhysicsObject():IsMotionEnabled())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".gravity", true,
          function(ePiece, oPly, oTr, sKey)
            local bSuc,bPi,bFr,bGr,sPh = asmlib.UnpackPhysicalSettings(ePiece)
            if(bSuc) then bGr = (not bGr) else return bSuc end
            return asmlib.ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
          end, nil,
          function(ePiece)
            return tobool(ePiece:GetPhysicsObject():IsGravityEnabled())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".weld", true,
          function(ePiece, oPly, oTr, sKey)
            if(oPly:KeyDown(IN_SPEED)) then
              local tCn, ID = constraintFindConstraints(ePiece, "Weld"), 1
              while(tCn and tCn[ID]) do local eCn = tCn[ID].Constraint
                if(eCn and eCn:IsValid()) then eCn:Remove() end; ID = (ID + 1)
              end; asmlib.Notify(oPly,"Removed: Welds !","CLEANUP"); return true
            else
              local sAnch = oPly:GetInfo(gsToolPrefL.."anchor", gsNoAnchor)
              local tAnch = gsSymRev:Explode(sAnch)
              local nAnch = tonumber(tAnch[1]); if(not asmlib.IsHere(nAnch)) then
                asmlib.Notify(oPly,"Anchor: Mismatch "..sAnch.." !","ERROR") return false end
              local eBase = entsGetByIndex(nAnch); if(not (eBase and eBase:IsValid())) then
                asmlib.Notify(oPly,"Entity: Missing "..tostring(nAnch).." !","ERROR") return false end
              local maxforce = asmlib.GetAsmConvar("maxforce", "FLT")
              local forcelim = mathClamp(oPly:GetInfoNum(gsToolPrefL.."forcelim", 0), 0, maxforce)
              local bSuc, cnW, cnN, cnG = asmlib.ApplyPhysicalAnchor(ePiece,eBase,true,false,false,forcelim)
              if(bSuc and cnW and cnW:IsValid()) then
                local sIde = ePiece:EntIndex()..gsSymDir..eBase:EntIndex()
                asmlib.UndoCrate("TA Weld > "..asmlib.GetReport2(sIde,cnW:GetClass()))
                asmlib.UndoAddEntity(cnW); asmlib.UndoFinish(oPly); return true
              end; return false
            end
          end, nil,
          function(ePiece)
            local tCn = constraintFindConstraints(ePiece, "Weld"); return #tCn
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".nocollide", true,
          function(ePiece, oPly, oTr, sKey)
            if(oPly:KeyDown(IN_SPEED)) then
              local tCn, ID = constraintFindConstraints(ePiece, "NoCollide"), 1
              while(tCn and tCn[ID]) do local eCn = tCn[ID].Constraint
                if(eCn and eCn:IsValid()) then eCn:Remove() end; ID = (ID + 1)
              end; asmlib.Notify(oPly,"Removed: NoCollides !","CLEANUP"); return true
            else -- Get anchor prop
              local sAnch = oPly:GetInfo(gsToolPrefL.."anchor", gsNoAnchor)
              local tAnch = gsSymRev:Explode(sAnch)
              local nAnch = tonumber(tAnch[1]); if(not asmlib.IsHere(nAnch)) then
                asmlib.Notify(oPly,"Anchor: Mismatch "..sAnch.." !","ERROR") return false end
              local eBase = entsGetByIndex(nAnch); if(not (eBase and eBase:IsValid())) then
                asmlib.Notify(oPly,"Entity: Missing "..nAnch.." !","ERROR") return false end
              local maxforce = asmlib.GetAsmConvar("maxforce", "FLT")
              local forcelim = mathClamp(oPly:GetInfoNum(gsToolPrefL.."forcelim", 0), 0, maxforce)
              local bSuc, cnW, cnN, cnG = asmlib.ApplyPhysicalAnchor(ePiece,eBase,false,true,false,forcelim)
              if(bSuc and cnN and cnN:IsValid()) then
                local sIde = ePiece:EntIndex()..gsSymDir..eBase:EntIndex()
                asmlib.UndoCrate("TA NoCollide > "..asmlib.GetReport2(sIde,cnN:GetClass()))
                asmlib.UndoAddEntity(cnN); asmlib.UndoFinish(oPly); return true
              end; return false
            end
          end, nil,
          function(ePiece)
            local tCn = constraintFindConstraints(ePiece, "NoCollide"); return #tCn
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".nocollidew", true,
          function(ePiece, oPly, oTr, sKey)
            if(oPly:KeyDown(IN_SPEED)) then
              local eCn = constraintFind(ePiece, gameGetWorld(), "AdvBallsocket", 0, 0)
              if(eCn and eCn:IsValid()) then eCn:Remove()
                asmlib.Notify(oPly,"Removed: NoCollideWorld !","CLEANUP")
              else asmlib.Notify(oPly,"Missing: NoCollideWorld !","CLEANUP") end
            else
              local maxforce = asmlib.GetAsmConvar("maxforce", "FLT")
              local forcelim = mathClamp(oPly:GetInfoNum(gsToolPrefL.."forcelim", 0), 0, maxforce)
              local bSuc, cnW, cnN, cnG = asmlib.ApplyPhysicalAnchor(ePiece,nil,false,false,true,forcelim)
              if(bSuc and cnG and cnG:IsValid()) then
                asmlib.UndoCrate("TA NoCollideWorld > "..asmlib.GetReport2(ePiece:EntIndex(),cnG:GetClass()))
                asmlib.UndoAddEntity(cnG); asmlib.UndoFinish(oPly); return true
              end; return false
            end
          end, nil,
          function(ePiece)
            local eCn = constraintFind(ePiece, gameGetWorld(), "AdvBallsocket", 0, 0)
            return tobool(eCn and eCn:IsValid())
          end
        })

if(SERVER) then
  local function PopulateEntity(nLen)
    local oEnt = netReadEntity(); gtArgsLogs[1] = "*POPULATE_ENTITY"
    local sNoA = asmlib.GetOpVar("MISS_NOAV") -- Default drawn string
    asmlib.LogInstance("Entity"..asmlib.GetReport2(oEnt:GetClass(),oEnt:EntIndex()), gtArgsLogs)
    for iD = 1, conContextMenu:GetSize() do
      local tLine = conContextMenu:Select(iD) -- Grab the value from the container
      local sKey, wDraw = tLine[1], tLine[5]  -- Extract the key and handler
      if(type(wDraw) == "function") then      -- Check when the value is function
        local bS, vE = pcall(wDraw, oEnt); vE = tostring(vE) -- Always being string
        if(not bS) then oEnt:SetNWString(sKey, sNoA)
          asmlib.LogInstance("Request"..asmlib.GetReport2(sKey,iD).." fail: "..vE, gtArgsLogs); return end
        asmlib.LogInstance("Handler"..asmlib.GetReport2(sKey,iD,vE), gtArgsLogs)
        oEnt:SetNWString(sKey, vE) -- Write networked value to the hover entity
      end
    end
  end
  utilAddNetworkString(gsOptionsCV)
  netReceive(gsOptionsCV, PopulateEntity)
end

if(CLIENT) then
  asmlib.SetAction("UPDATE_CONTEXTVAL", -- Must have the same parameters as the hook
    function() gtArgsLogs[1] = "*UPDATE_CONTEXTVAL"
      if(not asmlib.IsFlag("tg_context_menu")) then return nil end -- Menu not opened
      if(not asmlib.GetAsmConvar("enctxmenu", "BUL")) then return nil end -- Menu not enabled
      local oPly = LocalPlayer(); if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Player invalid "..asmlib.GetReport(oPly)..">", gtArgsLogs); return nil end
      local vEye, vAim, tTrig = EyePos(), oPly:GetAimVector(), asmlib.GetOpVar("HOVER_TRIGGER")
      local oEnt = propertiesGetHovered(vEye, vAim); tTrig[2] = tTrig[1]; tTrig[1] = oEnt
      if(asmlib.IsOther(oEnt) or tTrig[1] == tTrig[2]) then return nil end -- Enity trigger
      if(not asmlib.GetAsmConvar("enctxmall", "BUL")) then -- Enable for all props
        local oRec = asmlib.CacheQueryPiece(oEnt:GetModel())
        if(not asmlib.IsHere(oRec)) then return nil end
      end -- If the menu is not enabled for all props ged-a-ud!
      netStart(gsOptionsCV); netWriteEntity(oEnt); netSendToServer() -- Love message
      asmlib.LogInstance("Entity "..asmlib.GetReport2(oEnt:GetClass(),oEnt:EntIndex()), gtArgsLogs)
    end) -- Read client configuration
end

-- This filters what the context menu is available for
gtOptionsCM.Filter = function(self, ent, ply)
  if(asmlib.IsOther(ent)) then return false end
  if(not (ply and ply:IsValid())) then return false end
  if(not gamemodeCall("CanProperty", ply, gsOptionsCM, ent)) then return false end
  if(not asmlib.GetAsmConvar("enctxmenu", "BUL")) then return false end
  if(not asmlib.GetAsmConvar("enctxmall", "BUL")) then
    local oRec = asmlib.CacheQueryPiece(ent:GetModel())
    if(not asmlib.IsHere(oRec)) then return false end
  end -- If the menu is not enabled for all props check for track and ged-a-ud!
  return true -- The entity is track piece and TA menu is available
end
-- The routine which builds the context menu
gtOptionsCM.MenuOpen = function(self, opt, ent, tr)
  gtOptionsCM.MenuLabel = asmlib.GetPhrase("tool."..gsToolNameL..".name")
  local oPly, pnSub = LocalPlayer(), opt:AddSubMenu(); if(not IsValid(pnSub)) then
    asmlib.LogInstance("Invalid context menu",gsOptionsLG); return end
  local fHash = (gsToolNameL.."%.(.*)$")
  for iD = 1, conContextMenu:GetSize() do
    local tLine = conContextMenu:Select(iD)
    local sKey , fDraw = tLine[1], tLine[4]
    local wDraw, sIcon = tLine[5], sKey:match(fHash)
    local sName = asmlib.GetPhrase(sKey.."_con"):Trim():Trim(":")
    if(asmlib.IsFunction(fDraw)) then
      local bS, vE = pcall(fDraw, ent, oPly, tr, sKey); if(not bS) then
        asmlib.LogInstance("Request "..asmlib.GetReport2(sKey,iD).." fail: "..vE,gsOptionsLG); return end
      sName = sName..": "..tostring(vE)          -- Attach client value ( CLIENT )
    elseif(asmlib.IsFunction(wDraw)) then
      sName = sName..": "..ent:GetNWString(sKey) -- Attach networked value ( SERVER )
    end; local fEval = function() self:Evaluate(ent,iD,tr,sKey) end
    local pnOpt = pnSub:AddOption(sName, fEval); if(not IsValid(pnOpt)) then
      asmlib.LogInstance("Invalid "..asmlib.GetReport2(sKey,iD),gsOptionsLG); return end
    if(not asmlib.IsBlank(sIcon)) then pnOpt:SetIcon(asmlib.ToIcon(sIcon)) end
  end
end
-- Not used. Use the evaluate function instead
gtOptionsCM.Action = function(self, ent, tr) end
-- Use the custom evaluation function with index and key arguments
gtOptionsCM.Evaluate = function(self, ent, idx, key)
  local tLine = conContextMenu:Select(idx); if(not tLine) then
    asmlib.LogInstance("Skip "..asmlib.GetReport(idx),gsOptionsLG); return end
  local sKey, bTrans, fHandle = tLine[1], tLine[2], tLine[3]
  if(bTrans) then -- Transfer to SERVER
    self:MsgStart()
      netWriteEntity(ent)
      netWriteUInt(idx, 8)
    self:MsgEnd()
  else -- Call on the CLIENT
    local oPly = LocalPlayer()
    local oTr  = oPly:GetEyeTrace()
    local bS, vE = pcall(fHandle,ent,oPly,oTr,key); if(not bS) then
      asmlib.LogInstance("Request "..asmlib.GetReport2(sKey,idx).." fail: "..vE,gsOptionsLG); return end
    if(bS and not vE) then asmlib.LogInstance("Failure "..asmlib.GetReport2(sKey,idx),gsOptionsLG); return end
  end
end
-- What to happen on the server with our entity
gtOptionsCM.Receive = function(self, len, ply)
  local ent = netReadEntity()
  local idx = netReadUInt(8)
  local oTr = ply:GetEyeTrace()
  local tLine = conContextMenu:Select(idx); if(not tLine) then
    asmlib.LogInstance("Mismatch "..asmlib.GetReport(idx),gsOptionsLG); return end
  if(not self:Filter(ent, ply)) then return end
  if(not propertiesCanBeTargeted(ent, ply)) then return end
  local sKey, fHandle = tLine[1], tLine[3] -- Menu function handler
  local bS, vE = pcall(fHandle, ent, ply, oTr, sKey); if(not bS) then
    asmlib.LogInstance("Request "..asmlib.GetReport2(sKey,idx).." fail: "..vE,gsOptionsLG); return end
  if(bS and not vE) then asmlib.LogInstance("Failure "..asmlib.GetReport2(sKey,idx),gsOptionsLG); return end
end
-- Register the track assembly setup options in the context menu
propertiesAdd(gsOptionsCM, gtOptionsCM)

------ INITIALIZE DB ------
asmlib.CreateTable("PIECES",{
  Timer = gaTimerSet[1],
  Index = {{1},{4},{1,4}},
  Trigs = {
    Record = function(arLine, vSrc)
      local noMD  = asmlib.GetOpVar("MISS_NOMD")
      local noTY  = asmlib.GetOpVar("MISS_NOTP")
      local noSQL = asmlib.GetOpVar("MISS_NOSQL")
      local trCls = asmlib.GetOpVar("TRACE_CLASS")
      arLine[2] = asmlib.GetTerm(arLine[2], noTY, asmlib.Categorize())
      arLine[3] = asmlib.GetTerm(arLine[3], noMD, asmlib.ModelToName(arLine[1]))
      arLine[8] = asmlib.GetTerm(arLine[8], noSQL, noSQL)
      if(not (asmlib.IsNull(arLine[8]) or trCls[arLine[8]] or asmlib.IsBlank(arLine[8]))) then
        asmlib.LogInstance("Register trace "..asmlib.GetReport2(arLine[8],arLine[1]),vSrc)
        trCls[arLine[8]] = true; -- Register the class provided to the trace hit list
      end; return true
    end
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
          "> to "..defTab[4][1].." for <"..tostring(snPK)..">",vSrc); return false end
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
        tostring(arLine[4]).."> to "..defTab[4][1].." for <"..tostring(snPK)..">",vSrc); return false end
      stData[nAddID] = {} -- LineID has to be set properly
      while(nCnt <= defTab.Size) do sFld = defTab[nCnt][1]
        stData[nAddID][sFld] = makTab:Match(arLine[nCnt],nCnt)
        if(not asmlib.IsHere(stData[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          asmlib.LogInstance("Cannot match <"..tostring(arLine[nCnt]).."> to "..
            defTab[nCnt][1].." for <"..tostring(snPK)..">",vSrc); return false
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
      arLine[1] = asmlib.GetTerm(arLine[1],"TYPE",asmlib.Categorize()); return true
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
