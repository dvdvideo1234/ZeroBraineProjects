------------ LOCALIZNG FUNCTIONS ------------

local pcall                         = pcall
local Angle                         = Angle
local Vector                        = Vector
local IsValid                       = IsValid
local SysTime                       = SysTime
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
local guiOpenURL                    = gui and gui.OpenURL
local guiEnableScreenClicker        = gui and gui.EnableScreenClicker
local entsGetByIndex                = ents and ents.GetByIndex
local mathAbs                       = math and math.abs
local mathCeil                      = math and math.ceil
local mathFloor                     = math and math.floor
local mathClamp                     = math and math.Clamp
local mathRound                     = math and math.Round
local mathMin                       = math and math.min
local mathHuge                      = math and math.huge
local gameGetWorld                  = game and game.GetWorld
local tableConcat                   = table and table.concat
local tableRemove                   = table and table.remove
local tableEmpty                    = table and table.Empty
local tableInsert                   = table and table.insert
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
local hookAdd                       = hook and hook.Add
local hookRemove                    = hook and hook.Remove
local timerSimple                   = timer and timer.Simple
local inputIsKeyDown                = input and input.IsKeyDown
local inputIsMouseDown              = input and input.IsMouseDown
local inputGetCursorPos             = input and input.GetCursorPos
local stringUpper                   = string and string.upper
local stringGetFileName             = string and string.GetFileFromFilename
local surfaceCreateFont             = surface and surface.CreateFont
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
local controlpanelGet               = controlpanel and controlpanel.Get
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier
local spawnmenuAddToolMenuOption    = spawnmenu and spawnmenu.AddToolMenuOption

------------ INCLUDE LIBRARY ------------
if(SERVER) then
  AddCSLuaFile("trackassembly/trackasmlib.lua")
end
include("trackassembly/trackasmlib.lua")

------------ MODULE POINTER ------------

local asmlib = trackasmlib; if(not asmlib) then -- Module present
  ErrorNoHalt("INIT: Track assembly tool module fail"); return end

------------ CONFIGURE ASMLIB ------------

asmlib.InitBase("track","assembly")
asmlib.SetOpVar("TOOL_VERSION","8.676")
asmlib.SetIndexes("V" ,1,2,3)
asmlib.SetIndexes("A" ,1,2,3)
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)

------------ CONFIGURE GLOBAL INIT OPVARS ------------

local gtInitLogs  = asmlib.GetOpVar("LOG_INIT")
local gsNoID      = asmlib.GetOpVar("MISS_NOID") -- No such ID
local gsNoMD      = asmlib.GetOpVar("MISS_NOMD") -- No model
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVISION")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gnRatio     = asmlib.GetOpVar("GOLDEN_RATIO")
local gnMaxRot    = asmlib.GetOpVar("MAX_ROTATION")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")
local gsToolNameU = asmlib.GetOpVar("TOOLNAME_NU")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsToolPrefU = asmlib.GetOpVar("TOOLNAME_PU")
local gsLangForm  = asmlib.GetOpVar("FORM_LANGPATH")
local gsLimitName = asmlib.GetOpVar("CVAR_LIMITNAME")
local gtCallBack  = asmlib.GetOpVar("TABLE_CALLBACK")
local gsNoAnchor  = gsNoID..gsSymRev..gsNoMD
local gtTransFile = fileFind(gsLangForm:format("*.lua"), "LUA")
local gsFullDSV   = asmlib.GetOpVar("DIRPATH_BAS")..asmlib.GetOpVar("DIRPATH_DSV")..
                    asmlib.GetInstPref()..asmlib.GetOpVar("TOOLNAME_PU")

------------ VARIABLE FLAGS ------------

local varLanguage = GetConVar("gmod_language")
-- Client and server have independent value
local gnIndependentUsed = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
-- Server tells the client what value to use
local gnServerControled = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY, FCVAR_REPLICATED)

------------ BORDERS ------------

asmlib.SetBorder("non-neg", 0)
asmlib.SetBorder("sbox_max"..gsLimitName , 0)
asmlib.SetBorder(gsToolPrefL.."crvturnlm", 0, 1)
asmlib.SetBorder(gsToolPrefL.."crvleanlm", 0, 1)
asmlib.SetBorder(gsToolPrefL.."curvefact", 0, 1)
asmlib.SetBorder(gsToolPrefL.."curvsmple", 0)
asmlib.SetBorder(gsToolPrefL.."devmode"  , 0, 1)
asmlib.SetBorder(gsToolPrefL.."enctxmall", 0, 1)
asmlib.SetBorder(gsToolPrefL.."enctxmenu", 0, 1)
asmlib.SetBorder(gsToolPrefL.."endsvlock", 0, 1)
asmlib.SetBorder(gsToolPrefL.."enwiremod", 0, 1)
asmlib.SetBorder(gsToolPrefL.."ghostcnt" , 0, 200)
asmlib.SetBorder(gsToolPrefL.."angsnap"  , 0, gnMaxRot)
asmlib.SetBorder(gsToolPrefL.."incsnpang", 0, gnMaxRot)
asmlib.SetBorder(gsToolPrefL.."incsnplin", 0, 250)
asmlib.SetBorder(gsToolPrefL.."logfile"  , 0, 1)
asmlib.SetBorder(gsToolPrefL.."logsmax"  , 0, 100000)
asmlib.SetBorder(gsToolPrefL.."maxactrad", 1, 200)
asmlib.SetBorder(gsToolPrefL.."maxforce" , 0, 200000)
asmlib.SetBorder(gsToolPrefL.."maxfruse" , 1, 150)
asmlib.SetBorder(gsToolPrefL.."maxlinear", 0)
asmlib.SetBorder(gsToolPrefL.."maxmass"  , 1)
asmlib.SetBorder(gsToolPrefL.."maxmenupr", 0, 10)
asmlib.SetBorder(gsToolPrefL.."maxstatts", 1, 10)
asmlib.SetBorder(gsToolPrefL.."maxstcnt" , 1)
asmlib.SetBorder(gsToolPrefL.."maxtrmarg", 0, 1)
asmlib.SetBorder(gsToolPrefL.."sizeucs"  , 0, 50)
asmlib.SetBorder(gsToolPrefL.."spawnrate", 1, 10)
asmlib.SetBorder(gsToolPrefL.."sgradmenu", 1, 16)
asmlib.SetBorder(gsToolPrefL.."dtmessage", 0, 10)
asmlib.SetBorder(gsToolPrefL.."ghostblnd", 0, 1)
asmlib.SetBorder(gsToolPrefL.."rtradmenu", -gnMaxRot, gnMaxRot)

------------ CONFIGURE LOGGING ------------

asmlib.SetOpVar("LOG_DEBUGEN",false)
asmlib.MakeAsmConvar("logsmax", 0, nil, gnIndependentUsed, "Maximum logging lines being written")
asmlib.MakeAsmConvar("logfile", 0, nil, gnIndependentUsed, "File logging output flag control")
asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"), asmlib.GetAsmConvar("logfile","BUL"))
asmlib.SettingsLogs("SKIP"); asmlib.SettingsLogs("ONLY")

------------ CONFIGURE NON-REPLICATED CVARS ------------ Client's got a mind of its own

asmlib.MakeAsmConvar("modedb"   , "LUA", nil, gnIndependentUsed, "Database storage operating mode LUA or SQL")
asmlib.MakeAsmConvar("devmode"  ,    0 , nil, gnIndependentUsed, "Toggle developer mode on/off server side")
asmlib.MakeAsmConvar("maxtrmarg", 0.02 , nil, gnIndependentUsed, "Maximum time to avoid performing new traces")
asmlib.MakeAsmConvar("maxmenupr",    5 , nil, gnIndependentUsed, "Maximum decimal places utilized in the control panel")
asmlib.MakeAsmConvar("timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1", nil, gnIndependentUsed, "Memory management setting when DB mode is SQL")

------------ CONFIGURE REPLICATED CVARS ------------ Server tells the client what value to use

asmlib.MakeAsmConvar("maxmass"  , 50000 , nil, gnServerControled, "Maximum mass that can be applied on a piece")
asmlib.MakeAsmConvar("maxlinear", 5000  , nil, gnServerControled, "Maximum linear offset of the piece")
asmlib.MakeAsmConvar("maxforce" , 100000, nil, gnServerControled, "Maximum force limit when creating welds")
asmlib.MakeAsmConvar("maxactrad", 200   , nil, gnServerControled, "Maximum active radius to search for a point ID")
asmlib.MakeAsmConvar("maxstcnt" , 200   , nil, gnServerControled, "Maximum spawned pieces in stacking mode")
asmlib.MakeAsmConvar("enwiremod", 1     , nil, gnServerControled, "Toggle the wire extension on/off server side")
asmlib.MakeAsmConvar("enctxmenu", 1     , nil, gnServerControled, "Toggle the context menu on/off in general")
asmlib.MakeAsmConvar("enctxmall", 0     , nil, gnServerControled, "Toggle the context menu on/off for all props")
asmlib.MakeAsmConvar("endsvlock", 0     , nil, gnServerControled, "Toggle the DSV external database file update on/off")
asmlib.MakeAsmConvar("curvefact", 0.5   , nil, gnServerControled, "Parametric constant track curving factor")
asmlib.MakeAsmConvar("curvsmple", 50    , nil, gnServerControled, "Amount of samples between two curve nodes")
asmlib.MakeAsmConvar("spawnrate",  1    , nil, gnServerControled, "Maximum pieces spawned in every think tick")
asmlib.MakeAsmConvar("bnderrmod","LOG"  , nil, gnServerControled, "Unreasonable position error handling mode")
asmlib.MakeAsmConvar("maxfruse" ,  50   , nil, gnServerControled, "Maximum frequent pieces to be listed")
asmlib.MakeAsmConvar("dtmessage",  1    , nil, gnServerControled, "Time interval for server addressed messages")
asmlib.MakeAsmConvar("*sbox_max"..gsLimitName, 1500, nil, gnServerControled, "Maximum number of tracks to be spawned")

------------ CONFIGURE INTERNALS ------------

asmlib.IsFlag("new_close_frame", false) -- The old state for frame shortcut detecting a pulse
asmlib.IsFlag("old_close_frame", false) -- The new state for frame shortcut detecting a pulse
asmlib.IsFlag("tg_context_menu", false) -- Raises whenever the user opens the game context menu
asmlib.IsFlag("en_dsv_datalock", asmlib.GetAsmConvar("endsvlock", "BUL"))
asmlib.SetOpVar("MODE_DATABASE", asmlib.GetAsmConvar("modedb"   , "STR"))
asmlib.SetOpVar("TRACE_MARGIN" , asmlib.GetAsmConvar("maxtrmarg", "FLT"))
asmlib.SetOpVar("MSDELTA_SEND" , asmlib.GetAsmConvar("dtmessage", "FLT"))

------------ GLOBAL VARIABLES ------------

local gsMoDB      = asmlib.GetOpVar("MODE_DATABASE")
local gaTimerSet  = gsSymDir:Explode(asmlib.GetAsmConvar("timermode","STR"))
local conPalette  = asmlib.GetContainer("COLORS_LIST")
      conPalette:Record("a" ,asmlib.GetColor(  0,   0,   0,   0)) -- Invisible
      conPalette:Record("r" ,asmlib.GetColor(255,   0,   0, 255)) -- Red
      conPalette:Record("g" ,asmlib.GetColor(  0, 255,   0, 255)) -- Green
      conPalette:Record("b" ,asmlib.GetColor(  0,   0, 255, 255)) -- Blue
      conPalette:Record("c" ,asmlib.GetColor(  0, 255, 255, 255)) -- Cyan
      conPalette:Record("m" ,asmlib.GetColor(255,   0, 255, 255)) -- Magenta
      conPalette:Record("y" ,asmlib.GetColor(255, 255,   0, 255)) -- Yellow
      conPalette:Record("w" ,asmlib.GetColor(255, 255, 255, 255)) -- White
      conPalette:Record("k" ,asmlib.GetColor(  0,   0,   0, 255)) -- Black
      conPalette:Record("gh",asmlib.GetColor(255, 255, 255, 150)) -- Ghosts base color
      conPalette:Record("tx",asmlib.GetColor( 80,  80,  80, 255)) -- Panel names text color
      conPalette:Record("an",asmlib.GetColor(180, 255, 150, 255)) -- Selected anchor
      conPalette:Record("db",asmlib.GetColor(220, 164,  52, 255)) -- Database mode
      conPalette:Record("ry",asmlib.GetColor(230, 200,  80, 255)) -- Ray tracing
      conPalette:Record("wm",asmlib.GetColor(143, 244,  66, 255)) -- Working mode HUD
      conPalette:Record("bx",asmlib.GetColor(250, 250, 200, 255)) -- Radial menu box
      conPalette:Record("fo",asmlib.GetColor(147,  92, 204, 255)) -- Flip over rails
      conPalette:Record("pf",asmlib.GetColor(150, 255, 150, 240)) -- Progress bar foreground
      conPalette:Record("pb",asmlib.GetColor(150, 150, 255, 190)) -- Progress bar background

local conElements = asmlib.GetContainer("LIST_VGUI")
local conWorkMode = asmlib.GetContainer("WORK_MODE")
      conWorkMode:Push("SNAP" ) -- General spawning and snapping mode
      conWorkMode:Push("CROSS") -- Ray cross intersect interpolation
      conWorkMode:Push("CURVE") -- Catmull–Rom spline interpolation fitting
      conWorkMode:Push("OVER" ) -- Trace normal ray location piece flip-snap
      conWorkMode:Push("TURN" ) -- Produces smoother turns with Bezier curve

------------ CALLBACKS ------------

local conCallBack = asmlib.GetContainer("CALLBAC_FUNC")
      conCallBack:Push({"maxtrmarg", function(sVar, vOld, vNew)
        local nM = (tonumber(vNew) or 0); nM = ((nM > 0) and nM or 0)
        asmlib.SetOpVar("TRACE_MARGIN", nM)
      end})
      conCallBack:Push({"logsmax", function(sVar, vOld, vNew)
        local nM = asmlib.BorderValue((tonumber(vNew) or 0), "non-neg")
        asmlib.SetOpVar("LOG_MAXLOGS", nM)
      end})
      conCallBack:Push({"logfile", function(sVar, vOld, vNew)
        asmlib.IsFlag("en_logging_file", tobool(vNew))
      end})
      conCallBack:Push({"endsvlock", function(sVar, vOld, vNew)
        asmlib.IsFlag("en_dsv_datalock", tobool(vNew))
      end})
      conCallBack:Push({"timermode", function(sVar, vOld, vNew)
        local arTim = gsSymDir:Explode(vNew)
        local mkTab, ID = asmlib.GetBuilderID(1), 1
        while(mkTab) do local sTim = arTim[ID]
          local defTab = mkTab:GetDefinition(); mkTab:TimerSetup(sTim)
          asmlib.LogInstance("Timer apply "..asmlib.GetReport2(defTab.Nick,sTim),gtInitLogs)
          ID = ID + 1; mkTab = asmlib.GetBuilderID(ID) -- Next table on the list
        end; asmlib.LogInstance("Timer update "..asmlib.GetReport(vNew),gtInitLogs)
      end})
      conCallBack:Push({"dtmessage", function(sVar, vOld, vNew)
        if(SERVER) then
          local sK = gsToolPrefL.."dtmessage"
          local nD = (tonumber(vNew) or 0)
                nD = asmlib.BorderValue(nD, sK)
          asmlib.SetOpVar("MSDELTA_SEND", nD)
        end
      end})

for iD = 1, conCallBack:GetSize() do
  local val = conCallBack:Select(iD)
  local nam = asmlib.GetAsmConvar(val[1], "NAM")
  cvarsRemoveChangeCallback(nam, nam.."_init")
  cvarsAddChangeCallback(nam, val[2], nam.."_init")
end

------------ RECORDS ------------

asmlib.SetOpVar("STRUCT_SPAWN",{
  Name = "Spawn data definition",
  Draw = {
    ["RDB"] = function(scr, key, typ, inf, def, spn)
      local rec, fmt = spn[key], asmlib.GetOpVar("FORM_DRAWDBG")
      local fky, nav = asmlib.GetOpVar("FORM_DRWSPKY"), asmlib.GetOpVar("MISS_NOAV")
      local out = (rec and tostring(stringGetFileName(rec.Slot)) or nav)
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

------------ ACTIONS ------------

if(SERVER) then

  for iD = 1, #gtTransFile do
    AddCSLuaFile(gsLangForm:format(gtTransFile[iD]))
  end -- Add client side translation lua files

  utilAddNetworkString(gsLibName.."SendIntersectClear")
  utilAddNetworkString(gsLibName.."SendIntersectRelate")
  utilAddNetworkString(gsLibName.."SendCreateCurveNode")
  utilAddNetworkString(gsLibName.."SendUpdateCurveNode")
  utilAddNetworkString(gsLibName.."SendDeleteCurveNode")
  utilAddNetworkString(gsLibName.."SendDeleteAllCurveNode")

  asmlib.SetAction("DUPE_PHYS_SETTINGS", -- Duplicator wrapper
    function(oPly,oEnt,tData) local sLog = "*DUPE_PHYS_SETTINGS"
      if(not asmlib.ApplyPhysicalSettings(oEnt,tData[1],tData[2],tData[3],tData[4])) then
        asmlib.LogInstance("Failed to apply physical settings on "..tostring(oEnt),sLog); return nil end
      asmlib.LogInstance("Success",sLog); return nil
    end)

  asmlib.SetAction("PLAYER_QUIT",
    function(oPly) local sLog = "*PLAYER_QUIT" -- Clear player cache when disconnects
      if(not asmlib.CacheClear(oPly)) then
        asmlib.LogInstance("Failed swiping stuff "..tostring(oPly),sLog); return nil end
      asmlib.LogInstance("Success",sLog); return nil
    end)

  asmlib.SetAction("PHYSGUN_DROP",
    function(pPly, trEnt) local sLog = "*PHYSGUN_DROP"
      if(not asmlib.IsPlayer(pPly)) then
        asmlib.LogInstance("Player invalid",sLog); return nil end
      if(pPly:GetInfoNum(gsToolPrefL.."engunsnap", 0) == 0) then
        asmlib.LogInstance("Snapping disabled",sLog); return nil end
      if(not (trEnt and trEnt:IsValid())) then
        asmlib.LogInstance("Trace entity invalid",sLog); return nil end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel()); if(not trRec) then
        asmlib.LogInstance("Trace not piece",sLog); return nil end
      local maxlinear  = asmlib.GetAsmConvar("maxlinear","FLT")
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
      local nextx      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextx"   , 0),-maxlinear, maxlinear)
      local nexty      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nexty"   , 0),-maxlinear, maxlinear)
      local nextz      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextz"   , 0),-maxlinear, maxlinear)
      local nextpic    = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextpic" , 0),-gnMaxRot, gnMaxRot)
      local nextyaw    = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextyaw" , 0),-gnMaxRot, gnMaxRot)
      local nextrol    = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextrol" , 0),-gnMaxRot, gnMaxRot)
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
            asmlib.LogInstance("User "..pPly:Nick().." snapped <"..trRec.Slot.."> outside bounds",sLog); return nil end
          trEnt:SetAngles(stSpawn.SAng)
          if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
            asmlib.LogInstance("Failed to apply physical settings",sLog); return nil end
          if(not asmlib.ApplyPhysicalAnchor(trEnt,trTr.Entity,weld,nocollide,nocollidew,forcelim)) then
            asmlib.LogInstance("Failed to apply physical anchor",sLog); return nil end
        end
      end
    end)
end

if(CLIENT) then

  surfaceCreateFont("DebugSpawnTA",{
    font = "Courier New", size = 14,
    weight = 600
  })

  -- Listen for changes to the localify language and reload the tool's menu to update the localizations
  cvarsRemoveChangeCallback(varLanguage:GetName(), gsToolPrefL.."lang")
  cvarsAddChangeCallback(varLanguage:GetName(), function(sNam, vO, vN)
    asmlib.InitLocalify(varLanguage:GetString())
    local sLog, bS, vOut, fUser, fAdmn = "*UPDATE_CONTROL_PANEL("..vO.."/"..vN..")"
    local oTool = asmlib.GetOpVar("STORE_TOOLOBJ"); if(not asmlib.IsHere(oTool)) then
      asmlib.LogInstance("Tool object missing", sLog); return end
    -- Retrieve the control panel from the tool main tab
    local fCont = oTool.BuildCPanel -- Function is the tool populator
    local pCont = controlpanelGet(gsToolNameL); if(not IsValid(pCont)) then
      asmlib.LogInstance("Control invalid", sLog); return end
    -- Retrieve the utilities user preferencies panel
    bS, vOut = asmlib.DoAction("TWEAK_PANEL", "Utilities", "User"); if(not bS) then
      asmlib.LogInstance("User miss: "..vOut, sLog); return end; fUser = vOut
    local pUser = controlpanelGet(gsToolNameL.."_utilities_user"); if(not IsValid(pUser)) then
      asmlib.LogInstance("User invalid", sLog); return end
    -- Retrieve the utilities user preferencies panel
    bS, vOut = asmlib.DoAction("TWEAK_PANEL", "Utilities", "Admin"); if(not bS) then
      asmlib.LogInstance("Admin miss: "..vOut, sLog); return end; fAdmn = vOut
    local pAdmn = controlpanelGet(gsToolNameL.."_utilities_admin"); if(not IsValid(pAdmn)) then
      asmlib.LogInstance("Admin invalid", sLog); return end
    -- Wipe the panel so it is clear of contents sliders buttons and stuff
    pCont:ClearControls(); pUser:ClearControls(); pAdmn:ClearControls()
    -- Panels are cleared and we change the language utilizing localify
    asmlib.InitLocalify(vN) -- Populate the new translated phrases
    -- Start the menu repopulation with the new phrases
    bS, vOut = pcall(fCont, pCont) if(not bS) then
      asmlib.LogInstance("Control fail: "..vOut, sLog); return
    else asmlib.LogInstance("Control: "..asmlib.GetReport(pCont.Name), sLog) end
    bS, vOut = pcall(fUser, pUser) if(not bS) then
      asmlib.LogInstance("User fail: "..vOut, sLog); return
    else asmlib.LogInstance("User: "..asmlib.GetReport(pUser.Name), sLog) end
    bS, vOut = pcall(fAdmn, pAdmn) if(not bS) then
      asmlib.LogInstance("Admin fail: "..vOut, sLog); return
    else asmlib.LogInstance("Admin: "..asmlib.GetReport(pAdmn.Name), sLog) end
  end, gsToolPrefL.."lang")

  -- http://www.famfamfam.com/lab/icons/silk/preview.php
  asmlib.ToIcon(gsToolPrefU.."PIECES"        , "database_connect")
  asmlib.ToIcon(gsToolPrefU.."ADDITIONS"     , "bricks"          )
  asmlib.ToIcon(gsToolPrefU.."PHYSPROPERTIES", "wand"            )
  asmlib.ToIcon(gsToolPrefL.."context_menu"  , "database_gear"   )
  asmlib.ToIcon("subfolder_item"   , "folder"          )
  asmlib.ToIcon("pn_externdb_1"    , "database"        )
  asmlib.ToIcon("pn_externdb_2"    , "folder_database" )
  asmlib.ToIcon("pn_externdb_3"    , "database_table"  )
  asmlib.ToIcon("pn_externdb_4"    , "database_link"   )
  asmlib.ToIcon("pn_externdb_5"    , "time_go"         )
  asmlib.ToIcon("pn_externdb_6"    , "compress"        )
  asmlib.ToIcon("pn_externdb_7"    , "database_edit"   )
  asmlib.ToIcon("pn_externdb_8"    , "database_delete" )
  asmlib.ToIcon("model"            , "brick"           )
  asmlib.ToIcon("mass"             , "basket_put"      )
  asmlib.ToIcon("bgskids"          , "layers"          )
  asmlib.ToIcon("phyname"          , "wand"            )
  asmlib.ToIcon("ignphysgn"        , "lightning_go"    )
  asmlib.ToIcon("freeze"           , "lock"            )
  asmlib.ToIcon("gravity"          , "ruby_put"        )
  asmlib.ToIcon("weld"             , "wrench"          )
  asmlib.ToIcon("nocollide"        , "shape_group"     )
  asmlib.ToIcon("nocollidew"       , "world_go"        )
  asmlib.ToIcon("dsvlist_extdb"    , "database_go"     )
  asmlib.ToIcon("workmode_snap"    , "plugin"          ) -- General spawning and snapping mode
  asmlib.ToIcon("workmode_cross"   , "chart_line"      ) -- Ray cross intersect interpolation
  asmlib.ToIcon("workmode_curve"   , "vector"          ) -- Catmull–Rom curve line segment fitting
  asmlib.ToIcon("workmode_over"    , "shape_move_back" ) -- Trace normal ray location piece flip-spawn
  asmlib.ToIcon("workmode_turn"    , "arrow_turn_right") -- Produces smoother turns with Bezier curve
  asmlib.ToIcon("property_type"    , "package_green"     )
  asmlib.ToIcon("property_name"    , "note"              )
  asmlib.ToIcon("modedb_lua"       , "database_lightning")
  asmlib.ToIcon("modedb_sql"       , "database_link"     )
  asmlib.ToIcon("timermode_cqt"    , "time_go"           )
  asmlib.ToIcon("timermode_obj"    , "clock_go"          )
  asmlib.ToIcon("bnderrmod_off"    , "shape_square"      )
  asmlib.ToIcon("bnderrmod_log"    , "shape_square_edit" )
  asmlib.ToIcon("bnderrmod_hint"   , "shape_square_go"   )
  asmlib.ToIcon("bnderrmod_generic", "shape_square_link" )
  asmlib.ToIcon("bnderrmod_error"  , "shape_square_error")

  -- Workshop matching crap
  asmlib.WorkshopID("SligWolf's Rerailers"        , "132843280")
  asmlib.WorkshopID("SligWolf's Minitrains"       , "149759773")
  asmlib.WorkshopID("SProps"                      , "173482196")
  asmlib.WorkshopID("Magnum's Rails"              , "290130567")
  asmlib.WorkshopID("SligWolf's Railcar"          , "173717507")
  asmlib.WorkshopID("Random Bridges"              , "343061215")
  asmlib.WorkshopID("StevenTechno's Buildings 1.0", "331192490")
  asmlib.WorkshopID("Mr.Train's M-Gauge"          , "517442747")
  asmlib.WorkshopID("Mr.Train's G-Gauge"          , "590574800")
  asmlib.WorkshopID("Bobster's two feet rails"    , "489114511")
  asmlib.WorkshopID("G Scale Track Pack"          , "718239260")
  asmlib.WorkshopID("Ron's Minitrain Props"       , "728833183")
  asmlib.WorkshopID("SligWolf's White Rails"      , "147812851")
  asmlib.WorkshopID("SligWolf's Minihover"        , "147812851")
  asmlib.WorkshopID("Battleship's abandoned rails", "807162936")
  asmlib.WorkshopID("AlexCookie's 2ft track pack" , "740453553")
  asmlib.WorkshopID("CAP Walkway"                 , "180210973")
  asmlib.WorkshopID("Joe's track pack"            , "1658816805")
  asmlib.WorkshopID("StevenTechno's Buildings 2.0", "1888013789")
  asmlib.WorkshopID("Modular Canals"              , "1336622735")
  asmlib.WorkshopID("Trackmania United Props"     , "1955876643")
  asmlib.WorkshopID("Anyone's Horrible Trackpack" , "2194528273")
  asmlib.WorkshopID("Modular Sewer"               , "2340192251")

  asmlib.SetAction("CTXMENU_OPEN" , function() asmlib.IsFlag("tg_context_menu", true ) end)
  asmlib.SetAction("CTXMENU_CLOSE", function() asmlib.IsFlag("tg_context_menu", false) end)

  asmlib.SetAction("CREATE_CURVE_NODE",
    function(nLen) local oPly, sLog = netReadEntity(), "*CREATE_CURVE_NODE"
      local vNode, vNorm, vBase = netReadVector(), netReadVector(), netReadVector()
      local tC = asmlib.GetCacheCurve(oPly) -- Read the curve data location
      tableInsert(tC.Node, vNode); tableInsert(tC.Norm, vNorm); tableInsert(tC.Base, vBase);
      tC.Size = (tC.Size + 1) -- Register the index after writing the data for drawing
    end)

  asmlib.SetAction("UPDATE_CURVE_NODE",
    function(nLen) local oPly, sLog = netReadEntity(), "*UPDATE_CURVE_NODE"
      local vNode, vNorm, vBase = netReadVector(), netReadVector(), netReadVector()
      local iD, tC = netReadUInt(16), asmlib.GetCacheCurve(oPly)
      tC.Node[iD]:Set(vNode); tC.Norm[iD]:Set(vNorm); tC.Base[iD]:Set(vBase)
    end)

  asmlib.SetAction("DELETE_CURVE_NODE",
    function(nLen) local oPly, sLog = netReadEntity(), "*DELETE_CURVE_NODE"
      local tC = asmlib.GetCacheCurve(oPly)
      tC.Size = (tC.Size - 1) -- Register the index before wiping the data for drawing
      tableRemove(tC.Node); tableRemove(tC.Norm); tableRemove(tC.Base)
    end)

  asmlib.SetAction("DELETE_ALL_CURVE_NODE",
    function(nLen) local oPly, sLog = netReadEntity(), "*DELETE_ALL_CURVE_NODE"
      local tC = asmlib.GetCacheCurve(oPly)
      if(tC.Size and tC.Size > 0) then
        tableEmpty(tC.Node); tableEmpty(tC.Norm); tableEmpty(tC.Base)
        tC.Size = 0 -- Register the index before wiping the data for drawing
      end
    end)

  asmlib.SetAction("CLEAR_RELATION",
    function(nLen) local oPly, sLog = netReadEntity(), "*CLEAR_RELATION"
      asmlib.LogInstance("{"..tostring(nLen)..","..tostring(oPly).."}", sLog)
      if(not asmlib.IntersectRayClear(oPly, "relate")) then
        asmlib.LogInstance("Failed clearing ray", sLog); return nil end
      asmlib.LogInstance("Success", sLog); return nil
    end) -- Net receive intersect relation clear client-side

  asmlib.SetAction("CREATE_RELATION",
    function(nLen) local sLog = "*CREATE_RELATION"
      local oEnt, vHit, oPly = netReadEntity(), netReadVector(), netReadEntity()
      asmlib.LogInstance("{"..tostring(nLen)..","..tostring(oPly).."}", sLog)
      if(not asmlib.IntersectRayCreate(oPly, oEnt, vHit, "relate")) then
        asmlib.LogInstance("Failed updating ray", sLog); return nil end
      asmlib.LogInstance("Success", sLog); return nil
    end) -- Net receive intersect relation create client-side

  asmlib.SetAction("BIND_PRESS", -- Must have the same parameters as the hook
    function(oPly,sBind,bPress) local sLog = "*BIND_PRESS"
      local oPly, actSwep, actTool = asmlib.GetHookInfo()
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",sLog); return nil end
      if(((sBind == "invnext") or (sBind == "invprev")) and bPress) then
        -- Switch functionality of the mouse wheel only for TA
        if(not inputIsKeyDown(KEY_LALT)) then
          asmlib.LogInstance("Active key missing",sLog); return nil end
        if(not actTool:GetScrollMouse()) then
          asmlib.LogInstance("(SCROLL) Scrolling disabled",sLog); return nil end
        local nDir = ((sBind == "invnext") and -1) or ((sBind == "invprev") and 1) or 0
        actTool:SwitchPoint(nDir,inputIsKeyDown(KEY_LSHIFT))
        asmlib.LogInstance("("..sBind..") Processed",sLog); return true
      elseif((sBind == "+zoom") and bPress) then -- Work mode radial menu selection
        if(inputIsMouseDown(MOUSE_MIDDLE)) then -- Reserve the mouse middle for radial menu
          if(not actTool:GetRadialMenu()) then -- Zoom is bind on the middle mouse button
            asmlib.LogInstance("("..sBind..") Menu disabled",sLog); return nil end
          asmlib.LogInstance("("..sBind..") Processed",sLog); return true
        end; return nil -- Need to disable the zoom when bind on the mouse middle
      end -- Override only for TA and skip touching anything else
      asmlib.LogInstance("("..sBind..") Skipped",sLog); return nil
    end) -- Read client configuration

  asmlib.SetAction("DRAW_RADMENU", -- Must have the same parameters as the hook
    function() local sLog = "*DRAW_RADMENU"
      local oPly, actSwep, actTool = asmlib.GetHookInfo()
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",sLog) return nil end
      if(not actTool:GetRadialMenu()) then
        asmlib.LogInstance("Menu disabled",sLog); return nil end
      if(inputIsMouseDown(MOUSE_MIDDLE)) then guiEnableScreenClicker(true) else
        guiEnableScreenClicker(false); asmlib.LogInstance("Release",sLog); return nil
      end -- Draw while holding the mouse middle button
      local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
      local actMonitor = asmlib.GetScreen(0,0,scrW,scrH,conPalette,"GAME")
      if(not actMonitor) then asmlib.LogInstance("Screen invalid",sLog); return nil end
      local nMd = asmlib.GetOpVar("MAX_ROTATION")
      local nDr, sM = asmlib.GetOpVar("DEG_RAD"), asmlib.GetOpVar("MISS_NOAV")
      local nBr = (actTool:GetRadialAngle() * nDr)
      local nK, nN = actTool:GetRadialSegm(), conWorkMode:GetSize()
      local nR  = (mathMin(scrW, scrH) / (2 * gnRatio))
      local mXY = asmlib.NewXY(guiMouseX(), guiMouseY())
      local vCn = asmlib.NewXY(mathFloor(scrW/2), mathFloor(scrH/2))
      local nMr, vTx, nD = (nMd * nDr), asmlib.NewXY(), (nR / gnRatio) -- Max angle [2pi]
      local vA, vB = asmlib.NewXY(), asmlib.NewXY()
      local tP = {asmlib.NewXY(), asmlib.NewXY(), asmlib.NewXY(), asmlib.NewXY()}
      local vF, vN = asmlib.NewXY(nR, 0), asmlib.NewXY(mathClamp(nR - nD, 0, nR), 0)
      asmlib.RotateXY(vN, nBr); asmlib.RotateXY(vF, nBr) -- Near and far base rotation
      asmlib.NegY(asmlib.SubXY(vA, mXY, vCn)) -- Origin [0;0] is located at top left
      asmlib.RotateXY(vA, -nBr) -- Correctly read the wiper vector to identify working mode
      local aW = asmlib.GetAngleXY(vA) -- Read wiper angle and normalize the value
            aW = ((aW < 0) and (aW + nMr) or aW) -- Convert [0;+pi;-pi;0] to [0;2pi]
      local iW = mathFloor(((aW / nMr) * nN) + 1) -- Calculate fraction ID for working mode
      local dA = (nMr / (nK * nN)) -- Two times smaller step to hangle centers as well
      asmlib.SetXY(vA, vF); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[4], vA)
      asmlib.SetXY(vA, vN); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[3], vA)
      local nT, nB = mathCeil((nK - 1) / 2) + 1, mathFloor((nK - 1) / 2) + 1
      for iD = 1, nN do asmlib.SetXY(vTx, 0, 0)
        local sW = tostring(conWorkMode:Select(iD) or sM) -- Read selection name
        local sC = ((iW == iD) and "pf" or "pb") -- Change color for selected option
        -- Draw polygon segment using triangles with the same color and array of vertices
        for iK = 1, nK do -- Interpolate the circle with given number of segments
          asmlib.SetXY(tP[1], tP[4]); asmlib.SetXY(tP[2], tP[3])
          asmlib.RotateXY(vN, dA); asmlib.RotateXY(vF, dA) -- Go to the next base line
          asmlib.SetXY(vA, vF); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[4], vA)
          asmlib.SetXY(vB, vN); asmlib.NegY(vB); asmlib.AddXY(vB, vB, vCn); asmlib.SetXY(tP[3], vB)
          actMonitor:DrawPoly(tP, sC, "SURF", {"vgui/white"}) -- Draw textured polygon
          -- Draw working mode name by placing centered text and the polygon midpoint
          if(nT == nB) then -- The index is at the farthest point
            if(nB == iK) then -- Odd. Use closest four vertices are taken
              asmlib.MidXY(vA, tP[1], tP[2]); asmlib.MidXY(vB, tP[3], tP[4])
              asmlib.MidXY(vA, vA, vB); asmlib.AddXY(vTx, vTx, vA)
            end -- When counter is at the top calculate text position
          else -- Even. Use the rod middle point of the two vertexes
            if(nB == iK) then asmlib.MidXY(vTx, vA, vB) end
          end -- Otherwise calculation is not triggered and does nothing
        end -- One segment for woring mode selection is drawn
        actMonitor:SetTextStart(vTx.x, vTx.y):DrawText(sW, "k", "SURF", {"Trebuchet24", true})
      end; asmlib.SetAsmConvar(oPly, "workmode", iW); return true
    end)

  asmlib.SetAction("DRAW_GHOSTS", -- Must have the same parameters as the hook
    function() local sLog = "*DRAW_GHOSTS"
      local oPly, actSwep, actTool = asmlib.GetHookInfo()
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",sLog); return nil end
      local model = actTool:GetModel()
      local ghcnt = actTool:GetGhostsDepth()
      local atGho = asmlib.GetOpVar("ARRAY_GHOST")
      if(utilIsValidModel(model)) then
        if(not (asmlib.HasGhosts() and ghcnt == atGho.Size and atGho.Slot == model)) then
          if(not asmlib.MakeGhosts(ghcnt, model)) then
            asmlib.LogInstance("Ghosting fail",sLog); return nil end
          actTool:ElevateGhost(atGho[1], oPly) -- Elevate the properly created ghost
        end; actTool:UpdateGhost(oPly) -- Update ghosts stack for the local player
      end
    end) -- Read client configuration

  asmlib.SetAction("OPEN_EXTERNDB", -- Must have the same parameters as the hook
    function(oPly,oCom,oArgs) local sLog = "*OPEN_EXTERNDB"
      local scrW = surfaceScreenWidth()
      local scrH = surfaceScreenHeight()
      local sVer = asmlib.GetOpVar("TOOL_VERSION")
      local xyPos, nAut  = asmlib.NewXY(scrW/4,scrH/4), (gnRatio - 1)
      local xyDsz, xyTmp = asmlib.NewXY(5,5), asmlib.NewXY()
      local xySiz = asmlib.NewXY(nAut * scrW, nAut * scrH)
      local pnFrame = vguiCreate("DFrame"); if(not IsValid(pnFrame)) then
        asmlib.LogInstance("Frame invalid",sLog); return nil end
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
        asmlib.LogInstance("Sheet invalid",sLog); return nil end
      pnSheet:SetParent(pnFrame)
      pnSheet:Dock(FILL)
      local sOff = asmlib.GetOpVar("OPSYM_DISABLE")
      local sMis = asmlib.GetOpVar("MISS_NOAV")
      local sLib = asmlib.GetOpVar("NAME_LIBRARY")
      local sBas = asmlib.GetOpVar("DIRPATH_BAS")
      local sSet = asmlib.GetOpVar("DIRPATH_SET")
      local sPrU = asmlib.GetOpVar("TOOLNAME_PU")
      local sRev = asmlib.GetOpVar("OPSYM_REVISION")
      local sDsv = sBas..asmlib.GetOpVar("DIRPATH_DSV")
      local fDSV = sDsv..("%s"..sPrU.."%s.txt")
      local sNam = (sBas..sSet..sLib.."_dsv.txt")
      local pnDSV = vguiCreate("DPanel")
      if(not IsValid(pnDSV)) then pnFrame:Close()
        asmlib.LogInstance("DSV list invalid",sLog); return nil end
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
      local wAct = mathFloor(((gnRatio - 1) / 6) * xySiz.x)
      local wUse = mathFloor(xySiz.x - wAct)
      local pnListView = vguiCreate("DListView")
      if(not IsValid(pnListView)) then pnFrame:Close()
        asmlib.LogInstance("List view invalid",sLog); return nil end
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
        asmlib.LogInstance("DSV list missing",sLog); return nil end
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
          if(inputIsKeyDown(KEY_LSHIFT)) then -- Delete the file
            fileDelete(sNam); pnSelf:Clear()  -- The panel will be recreated
          else pnSelf:RemoveLine(nIndex) end  -- Just remove the line selected
        end -- Process only the left mouse button
      end
      pnListView.OnRowRightClick = function(pnSelf, nIndex, pnLine)
        if(inputIsMouseDown(MOUSE_RIGHT)) then
          if(inputIsKeyDown(KEY_LSHIFT)) then -- Export all lines to the file
            local oDSV = fileOpen(sNam, "wb", "DATA")
            if(not oDSV) then pnFrame:Close()
              asmlib.LogInstance("DSV list missing",sLog..".ListView"); return nil end
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
          asmlib.LogInstance("Category invalid",sLog); return nil end
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
              asmlib.LogInstance("Button invalid ["..tostring(iP).."]",sLog); return nil end
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
                  asmlib.LogInstance("Menu invalid",sLog..".Button"); return nil end
                local iO, tOptions = 1, {
                  function() SetClipboardText(pnSelf:GetText()) end,
                  function() SetClipboardText(sDsv) end,
                  function() SetClipboardText(defTab.Nick) end,
                  function() SetClipboardText(sFile) end,
                  function() SetClipboardText(asmlib.GetDateTime(fileTime(sFile, "DATA"))) end,
                  function() SetClipboardText(tostring(fileSize(sFile, "DATA")).."B") end,
                  function() asmlib.SetAsmConvar(oPly, "*luapad", gsToolNameL) end,
                  function() fileDelete(sFile)
                    asmlib.LogInstance("Deleted "..asmlib.GetReport1(sFile),sLog..".Button")
                    if(defTab.Nick == "PIECES") then local sCat = fDSV:format(sPref,"CATEGORY")
                      if(fileExists(sCat,"DATA")) then fileDelete(sCat)
                        asmlib.LogInstance("Deleted "..asmlib.GetReport1(sCat),sLog..".Button") end
                    end; pnManage:Remove()
                  end
                }
                while(tOptions[iO]) do local sO = tostring(iO)
                  local sDescr = asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb_"..sO)
                  pnMenu:AddOption(sDescr, tOptions[iO]):SetIcon(asmlib.ToIcon("pn_externdb_"..sO))
                  iO = iO + 1 -- Loop trough the functions list and add to the menu
                end; pnMenu:Open()
              end
            else asmlib.LogInstance("File missing ["..tostring(iP).."]",sLog..".Button") end
            xyPos.y = xyPos.y + xySiz.y + xyDsz.y
          end
        else
          asmlib.LogInstance("Missing <"..defTab.Nick..">",sLog)
        end
        iD = (iD + 1); makTab = asmlib.GetBuilderID(iD)
      end; pnFrame:SetVisible(true); pnFrame:Center(); pnFrame:MakePopup()
      conElements:Push(pnFrame); asmlib.LogInstance("Success",sLog); return nil
    end) -- Read client configuration

  asmlib.SetAction("OPEN_FRAME",
    function(oPly,oCom,oArgs) local sLog = "*OPEN_FRAME"
      local frUsed, nCount = asmlib.GetFrequentModels(oArgs[1]); if(not asmlib.IsHere(frUsed)) then
        asmlib.LogInstance("Retrieving most frequent models failed ["..tostring(oArgs[1]).."]",sLog); return nil end
      local makTab = asmlib.GetBuilderNick("PIECES"); if(not asmlib.IsHere(makTab)) then
        asmlib.LogInstance("Missing builder for table PIECES",sLog); return nil end
      local defTab = makTab:GetDefinition(); if(not defTab) then
        asmlib.LogInstance("Missing definition for table PIECES",sLog); return nil end
      local pnFrame = vguiCreate("DFrame"); if(not IsValid(pnFrame)) then
        asmlib.LogInstance("Frame invalid",sLog); return nil end
      ------------ Screen resolution and configuration ------------
      local scrW         = surfaceScreenWidth()
      local scrH         = surfaceScreenHeight()
      local sVersion     = asmlib.GetOpVar("TOOL_VERSION")
      local xyZero       = {x =  0, y = 20} -- The start location of left-top
      local xyDelta      = {x = 10, y = 10} -- Distance between panels
      local xySiz        = {x =  0, y =  0} -- Current panel size
      local xyPos        = {x =  0, y =  0} -- Current panel position
      local xyTmp        = {x =  0, y =  0} -- Temporary coordinate
      ------------ Frame ------------
      xySiz.x = (scrW / gnRatio) -- This defines the size of the frame
      xyPos.x, xyPos.y = (scrW / 4), (scrH / 4)
      xySiz.y = mathFloor(xySiz.x / (1 + gnRatio))
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
      ------------ Button ------------
      xyTmp.x, xyTmp.y = pnFrame:GetSize()
      xySiz.x = (xyTmp.x / (8.5 * gnRatio)) -- Display properly the name
      xySiz.y = (xySiz.x / (1.5 * gnRatio)) -- Used by combo-box and text-box
      xyPos.x = xyZero.x + xyDelta.x
      xyPos.y = xyZero.y + xyDelta.y
      local pnButton = vguiCreate("DButton")
      if(not IsValid(pnButton)) then pnFrame:Close()
        asmlib.LogInstance("Button invalid",sLog); return nil end
      pnButton:SetParent(pnFrame)
      pnButton:SetPos(xyPos.x, xyPos.y)
      pnButton:SetSize(xySiz.x, xySiz.y)
      pnButton:SetVisible(true)
      pnButton:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_export_lb"))
      pnButton:SetText(asmlib.GetPhrase("tool."..gsToolNameL..".pn_export_lb"))
      pnButton:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_export"))
      ------------ ComboBox ------------
      xyPos.x, xyPos.y = pnButton:GetPos()
      xyTmp.x, xyTmp.y = pnButton:GetSize()
      xyPos.x = xyPos.x + xyTmp.x + xyDelta.x
      xySiz.x, xySiz.y = (gnRatio * xyTmp.x), xyTmp.y
      local pnComboBox = vguiCreate("DComboBox")
      if(not IsValid(pnComboBox)) then pnFrame:Close()
        asmlib.LogInstance("Combo invalid",sLog); return nil end
      pnComboBox:SetParent(pnFrame)
      pnComboBox:SetPos(xyPos.x,xyPos.y)
      pnComboBox:SetSize(xySiz.x,xySiz.y)
      pnComboBox:SetVisible(true)
      pnComboBox:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb"))
      pnComboBox:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol"))
      pnComboBox:SetValue(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb"))
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb1"), makTab:GetColumnName(1))
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb2"), makTab:GetColumnName(2))
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb3"), makTab:GetColumnName(3))
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb4"), makTab:GetColumnName(4))
      pnComboBox.OnSelect = function(pnSelf, nInd, sVal, anyData)
        asmlib.LogInstance("Selected "..asmlib.GetReport3(nInd,sVal,anyData),sLog..".ComboBox")
        pnSelf:SetValue(sVal)
      end
      ------------ ModelPanel ------------
      xyTmp.x, xyTmp.y = pnFrame:GetSize()
      xyPos.x, xyPos.y = pnComboBox:GetPos()
      xySiz.x = (xyTmp.x / (1.9 * gnRatio)) -- Display the model properly
      xyPos.x = xyTmp.x - xySiz.x - xyDelta.x
      xySiz.y = xyTmp.y - xyPos.y - xyDelta.y
      ------------------------------------------------
      local pnModelPanel = vguiCreate("DModelPanel")
      if(not IsValid(pnModelPanel)) then pnFrame:Close()
        asmlib.LogInstance("Model display invalid",sLog); return nil end
      pnModelPanel:SetParent(pnFrame)
      pnModelPanel:SetPos(xyPos.x,xyPos.y)
      pnModelPanel:SetSize(xySiz.x,xySiz.y)
      pnModelPanel:SetVisible(true)
      pnModelPanel:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_display_lb"))
      pnModelPanel:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_display"))
      pnModelPanel.LayoutEntity = function(pnSelf, oEnt)
        if(pnSelf.bAnimated) then pnSelf:RunAnimation() end
        local uiBox = asmlib.CacheBoxLayout(oEnt,40); if(not asmlib.IsHere(uiBox)) then
          asmlib.LogInstance("Box invalid",sLog..".ModelPanel"); return nil end
        local vPos, aAng = asmlib.GetOpVar("VEC_ZERO"), uiBox.Ang
        local stSpawn = asmlib.GetNormalSpawn(oPly, vPos, aAng, oEnt:GetModel(), 1)
              stSpawn.SPos:Set(uiBox.Cen)
              stSpawn.SPos:Rotate(stSpawn.SAng)
              stSpawn.SPos:Mul(-1)
              stSpawn.SPos:Add(uiBox.Cen)
        oEnt:SetAngles(stSpawn.SAng)
        oEnt:SetPos(stSpawn.SPos)
      end
      ------------ TextEntry ------------
      xyPos.x, xyPos.y = pnComboBox:GetPos()
      xyTmp.x, xyTmp.y = pnComboBox:GetSize()
      xyPos.x = xyPos.x + xyTmp.x + xyDelta.x
      xySiz.y = xyTmp.y
      ------------------------------------------------
      xyTmp.x, xyTmp.y = pnModelPanel:GetPos()
      xySiz.x = xyTmp.x - xyPos.x - xyDelta.x
      ------------------------------------------------
      local pnTextEntry = vguiCreate("DTextEntry")
      if(not IsValid(pnTextEntry)) then pnFrame:Close()
        asmlib.LogInstance("Textbox invalid",sLog); return nil end
      pnTextEntry:SetParent(pnFrame)
      pnTextEntry:SetPos(xyPos.x,xyPos.y)
      pnTextEntry:SetSize(xySiz.x,xySiz.y)
      pnTextEntry:SetVisible(true)
      pnTextEntry:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_pattern_lb"))
      pnTextEntry:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_pattern"))
      ------------ ListView ------------
      xyPos.x, xyPos.y = pnButton:GetPos()
      xyTmp.x, xyTmp.y = pnButton:GetSize()
      xyPos.y = xyPos.y + xyTmp.y + xyDelta.y
      ------------------------------------------------
      xyTmp.x, xyTmp.y = pnTextEntry:GetPos()
      xySiz.x, xySiz.y = pnTextEntry:GetSize()
      xySiz.x = xyTmp.x + xySiz.x - xyDelta.x
      ------------------------------------------------
      xyTmp.x, xyTmp.y = pnFrame:GetSize()
      xySiz.y = xyTmp.y - xyPos.y - xyDelta.y
      ------------------------------------------------
      local wUse = mathFloor(0.120377559 * xySiz.x)
      local wAct = mathFloor(0.047460893 * xySiz.x)
      local wTyp = mathFloor(0.314127559 * xySiz.x)
      local wNam = xySiz.x - wUse - wAct - wTyp
      local pnListView = vguiCreate("DListView")
      if(not IsValid(pnListView)) then pnFrame:Close()
        asmlib.LogInstance("List view invalid",sLog); return nil end
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
        local uiAct = (tonumber(pnLine:GetColumnText(2)) or 0); pnModelPanel:SetModel(uiMod) -- Active track ends per model create entity
        local uiEnt = pnModelPanel:GetEntity(); if(not (uiEnt and uiEnt:IsValid())) then -- Makes sure the entity is validated first
          asmlib.LogInstance("Model entity invalid "..asmlib.GetReport(uiMod), sLog..".ListView"); return nil end
        uiEnt:SetModel(uiMod); uiEnt:SetModelName(uiMod) -- Apply the model on the model panel even for changed compiled model paths
        local uiBox = asmlib.CacheBoxLayout(pnModelPanel:GetEntity(),0,gnRatio,gnRatio-1); if(not asmlib.IsHere(uiBox)) then
          asmlib.LogInstance("Box invalid for <"..uiMod..">",sLog..".ListView"); return nil end
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
        asmlib.LogInstance("Populate the list view failed",sLog); return nil end
      -- The button dababase export by type uses the current active type in the ListView line
      pnButton.DoClick = function(pnSelf)
        asmlib.LogInstance("Click "..asmlib.GetReport(pnSelf:GetText()), sLog..".Button")
        if(asmlib.GetAsmConvar("exportdb", "BUL")) then
          if(inputIsKeyDown(KEY_LSHIFT)) then local sType
            local iD, pnLine = pnListView:GetSelectedLine()
            if(asmlib.IsHere(iD)) then sType = pnLine:GetColumnText(3)
            else local model = asmlib.GetAsmConvar("model", "STR")
              local oRec = asmlib.CacheQueryPiece(model)
              if(asmlib.IsHere(oRec)) then sType = oRec.Type
              else LogInstance("Not piece <"..model..">") end
            end
            asmlib.ExportTypeAR(sType)
            asmlib.LogInstance("Export type "..asmlib.GetReport(sType), sLog..".Button")
          else
            asmlib.ExportCategory(3)
            asmlib.ExportDSV("PIECES")
            asmlib.ExportDSV("ADDITIONS")
            asmlib.ExportDSV("PHYSPROPERTIES")
            asmlib.LogInstance("Export instance", sLog..".Button")
          end
          asmlib.SetAsmConvar(oPly, "exportdb", 0)
        else
          if(inputIsKeyDown(KEY_LSHIFT)) then
            local fW = asmlib.GetOpVar("FORM_GITWIKI")
            guiOpenURL(fW:format("Additional-features"))
          end
        end
      end
      -- Leave the TextEntry here so it can access and update the local ListView reference
      pnTextEntry.OnEnter = function(pnSelf)
        local sPat = tostring(pnSelf:GetValue() or "")
        local sAbr, sCol = pnComboBox:GetSelected() -- Returns two values
              sAbr, sCol = tostring(sAbr or ""), tostring(sCol or "")
        if(not asmlib.UpdateListView(pnListView,frUsed,nCount,sCol,sPat)) then
          asmlib.LogInstance("Update ListView fail"..asmlib.GetReport3(sAbr,sCol,sPat,sLog..".TextEntry")); return nil
        end
      end
      pnFrame:SetVisible(true); pnFrame:Center(); pnFrame:MakePopup()
      conElements:Push(pnFrame); asmlib.LogInstance("Success",sLog); return nil
    end)

  asmlib.SetAction("DRAW_PHYSGUN",
    function() local sLog = "*DRAW_PHYSGUN"
      if(not asmlib.IsInit()) then return nil end
      if(not asmlib.GetAsmConvar("engunsnap", "BUL")) then
        asmlib.LogInstance("Extension disabled",sLog); return nil end
      if(not asmlib.GetAsmConvar("adviser", "BUL")) then
        asmlib.LogInstance("Adviser disabled",sLog); return nil end
      local oPly, actSwep = asmlib.GetHookInfo("weapon_physgun")
      if(not oPly) then asmlib.LogInstance("Hook mismatch",sLog); return nil end
      local hasghost = asmlib.HasGhosts(); asmlib.FadeGhosts(true)
      if(not inputIsMouseDown(MOUSE_LEFT)) then
        if(hasghost) then timerSimple(0, asmlib.ClearGhosts) end
        asmlib.LogInstance("Physgun not hold",sLog); return nil
      end -- When the player is not holding the piece clear ghosts
      local actTr = asmlib.GetCacheTrace(oPly); if(not actTr) then
        asmlib.LogInstance("Trace missing",sLog); return nil end
      if(not actTr.Hit) then asmlib.LogInstance("Trace not hit",sLog); return nil end
      if(actTr.HitWorld) then asmlib.LogInstance("Trace world",sLog); return nil end
      local trEnt = actTr.Entity; if(not (trEnt and trEnt:IsValid())) then
        asmlib.LogInstance("Trace entity invalid",sLog); return nil end
      if(trEnt:GetNWBool(gsToolPrefL.."physgundisabled")) then
        asmlib.LogInstance("Trace entity physgun disabled",sLog); return nil end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel()); if(not trRec) then
        asmlib.LogInstance("Trace not piece",sLog); return nil end
      local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
      local actMonitor = asmlib.GetScreen(0,0,scrW,scrH,conPalette,"GAME")
      if(not actMonitor) then asmlib.LogInstance("Invalid screen",sLog); return nil end
      local atGhosts  = asmlib.GetOpVar("ARRAY_GHOST")
      local ghostcnt  = asmlib.GetAsmConvar("ghostcnt", "FLT")
      local igntype   = asmlib.GetAsmConvar("igntype" , "BUL")
      local spnflat   = asmlib.GetAsmConvar("spnflat" , "BUL")
      local activrad  = asmlib.GetAsmConvar("activrad", "FLT")
      local maxlinear = asmlib.GetAsmConvar("maxlinear","FLT")
      local sizeucs   = mathClamp(asmlib.GetAsmConvar("sizeucs", "FLT"),0,maxlinear)
      local nextx     = mathClamp(asmlib.GetAsmConvar("nextx"  , "FLT"),0,maxlinear)
      local nexty     = mathClamp(asmlib.GetAsmConvar("nexty"  , "FLT"),0,maxlinear)
      local nextz     = mathClamp(asmlib.GetAsmConvar("nextz"  , "FLT"),0,maxlinear)
      local nextpic   = mathClamp(asmlib.GetAsmConvar("nextpic", "FLT"),-gnMaxRot,gnMaxRot)
      local nextyaw   = mathClamp(asmlib.GetAsmConvar("nextyaw", "FLT"),-gnMaxRot,gnMaxRot)
      local nextrol   = mathClamp(asmlib.GetAsmConvar("nextrol", "FLT"),-gnMaxRot,gnMaxRot)
      for trID = 1, trRec.Size, 1 do
        local oTr, oDt = asmlib.GetTraceEntityPoint(trEnt, trID, activrad)
        if(oTr) then
          local xyS, xyE = oDt.start:ToScreen(), oDt.endpos:ToScreen()
          local rdS = asmlib.GetCacheRadius(oPly, oTr.HitPos, 1)
          if(oTr.Hit) then
            local tgE, xyH = oTr.Entity, oTr.HitPos:ToScreen()
            if(tgE and tgE:IsValid()) then
              actMonitor:DrawCircle(xyS, asmlib.GetViewRadius(oPly, oDt.start), "y", "SURF")
              actMonitor:DrawLine  (xyS, xyH, "g", "SURF")
              actMonitor:DrawCircle(xyH, asmlib.GetViewRadius(oPly, oTr.HitPos), "g")
              actMonitor:DrawLine  (xyH, xyE, "y")
              actSpawn = asmlib.GetEntitySpawn(oPly,tgE,oTr.HitPos,trRec.Slot,trID,activrad,
                           spnflat,igntype, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
              if(actSpawn) then -- When spawn data is availabe draw adviser
                if(utilIsValidModel(trRec.Slot)) then -- The model has valid pre-cache
                  if(ghostcnt > 0) then -- The ghosting is enabled
                    if(not (hasghost and atGhosts.Size == 1 and trRec.Slot == atGhosts.Slot)) then
                      if(not asmlib.MakeGhosts(1, trRec.Slot)) then
                        asmlib.LogInstance("Ghosting fail",sLog); return nil end
                    end local eGho = atGhosts[1]; eGho:SetNoDraw(false)
                    eGho:SetPos(actSpawn.SPos); eGho:SetAngles(actSpawn.SAng)
                  end -- When the ghosting is disabled saves memory
                  local xyO = actSpawn.OPos:ToScreen()
                  local xyB = actSpawn.BPos:ToScreen()
                  local xyS = actSpawn.SPos:ToScreen()
                  local xyP = actSpawn.TPnt:ToScreen()
                  actMonitor:DrawLine  (xyH, xyP, "g")
                  actMonitor:DrawCircle(xyP, asmlib.GetViewRadius(oPly, actSpawn.TPnt) / 2, "r")
                  actMonitor:DrawCircle(xyB, asmlib.GetViewRadius(oPly, actSpawn.BPos), "y")
                  actMonitor:DrawLine  (xyB, xyP, "r")
                  actMonitor:DrawLine  (xyB, xyO, "y")
                  -- Origin and spawn information
                  actMonitor:DrawLine  (xyO, xyS, "m")
                  actMonitor:DrawCircle(xyS, asmlib.GetViewRadius(oPly, actSpawn.SPos), "c")
                  -- Origin and base coordinate systems
                  actMonitor:DrawUCS(oPly, actSpawn.OPos, actSpawn.OAng, "SURF", {sizeucs, rdS})
                  actMonitor:DrawUCS(oPly, actSpawn.BPos, actSpawn.BAng)
                end
              else
                local tgRec = asmlib.CacheQueryPiece(tgE:GetModel())
                if(not asmlib.IsHere(tgRec)) then return nil end
                for tgI = 1, tgRec.Size do
                  local tgPOA = asmlib.LocatePOA(tgRec, tgI); if(not asmlib.IsHere(tgPOA)) then
                    asmlib.LogInstance("ID #"..tostring(ID).." not located",sLog); return nil end
                  actMonitor:DrawPOA(oPly, tgE, tgPOA, tgI, activrad)
                end
              end
            else
              actMonitor:DrawCircle(xyS, asmlib.GetViewRadius(oPly, oDt.start), "y", "SURF")
              actMonitor:DrawLine  (xyS, xyH, "y", "SURF")
              actMonitor:DrawCircle(xyH, asmlib.GetViewRadius(oPly, oTr.HitPos), "y")
              actMonitor:DrawLine  (xyH, xyE, "r")
            end
          else
            actMonitor:DrawCircle(xyS, asmlib.GetViewRadius(oPly, oDt.start), "y", "SURF")
            actMonitor:DrawLine  (xyS, xyE, "r", "SURF")
          end
        else
          local nRad = asmlib.GetCacheRadius(oPly, actTr.HitPos)
          for ID = 1, trRec.Size do
            local stPOA = asmlib.LocatePOA(trRec, ID); if(not stPOA) then
              asmlib.LogInstance("Cannot locate #"..tostring(ID), sLog); return end
            actMonitor:DrawPOA(oPly, trEnt, stPOA, ID, 0, false)
          end
        end
      end
    end)

    asmlib.SetAction("TWEAK_PANEL", -- Updates the function if present. Returns it when missing
      function(tDat, ...) local tArg = {...} -- Third argument controls the behavior
        local fFoo, sLog = tArg[3], "*TWEAK_PANEL"
        local sDir, sSub = tostring(tArg[1]):lower(), tostring(tArg[2]):lower()
        local bS, lDir = pcall(tDat.Foo, sDir); if(not bS) then
          asmlib.LogInstance("Fail folder "..asmlib.GetReport2(sDir, lDir), sLog); return end
        local bS, lSub = pcall(tDat.Foo, sSub); if(not bS) then
          asmlib.LogInstance("Fail subfolder "..asmlib.GetReport2(sSub, lSub), sLog); return end
        local sKey = tDat.Key:format(sDir, sSub)
        if(asmlib.IsHere(fFoo)) then
          if(not asmlib.IsFunction(fFoo)) then
            asmlib.LogInstance("Miss function "..asmlib.GetReport3(sDir, sSub, fFoo), sLog); return end
          if(not asmlib.IsHere(tDat.Bar[sDir])) then tDat.Bar[sDir] = {} end; tDat.Bar[sDir][sSub] = fFoo
          asmlib.LogInstance("Store "..asmlib.GetReport3(sDir, sSub, fFoo), sLog)
          hookRemove(tDat.Hoo, sKey); hookAdd(tDat.Hoo, sKey, function()
            spawnmenuAddToolMenuOption(lDir, lSub, sKey, asmlib.GetPhrase(tDat.Nam), "", "", fFoo) end)
        else
          if(not asmlib.IsHere(tDat.Bar[sDir])) then
            asmlib.LogInstance("Miss folder "..asmlib.GetReport1(sDir), sLog); return end
          fFoo = tDat.Bar[sDir][sSub]; if(not asmlib.IsHere(fFoo)) then
            asmlib.LogInstance("Miss subfolder "..asmlib.GetReport2(sDir, sSub), sLog); return end
          if(not asmlib.IsFunction(fFoo)) then
            asmlib.LogInstance("Miss function "..asmlib.GetReport3(sDir, sSub, fFoo), sLog); return end
          asmlib.LogInstance("Cache "..asmlib.GetReport3(sDir, sSub, fFoo), sLog); return fFoo
        end
      end,
      {
        Bar = {},
        Hoo = "PopulateToolMenu",
        Key = gsToolPrefL.."%s_%s",
        Nam = "tool."..gsToolNameL..".name",
        Foo = function(s) return s:gsub("^%l", stringUpper) end
      })
end

------------ INITIALIZE CONTEXT PROPERTIES ------------

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
local conContextMenu = asmlib.GetContainer("CONTEXT_MENU")
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
  -- [1] : End time to send the client request
  -- [2] : End time to draw the user notification
  local function PopulateEntity(nLen, oPly)
    local dTim = asmlib.GetOpVar("MSDELTA_SEND")
    local tHov = asmlib.GetOpVar("HOVER_TRIGGER")
    local pTim, cTim, nDel = tHov[oPly], SysTime(), 15
    if(not pTim) then pTim = {cTim, (nDel + cTim)}; tHov[oPly] = pTim end
    if(dTim == 0 or (dTim > 0 and cTim > (pTim[1] + dTim))) then
      if(cTim > pTim[2]) then pTim[2] = (cTim + nDel) end
      pTim[1] = cTim -- Raise the flag to notify the flooding client
      local oEnt, sLog = netReadEntity(), "*POPULATE_ENTITY"
      local sNoA = asmlib.GetOpVar("MISS_NOAV") -- Default drawn string
      local sTyp, nIdx = oEnt:GetClass(),oEnt:EntIndex()
      asmlib.LogInstance("Entity"..asmlib.GetReport2(sTyp, nIdx), sLog)
      for iD = 1, conContextMenu:GetSize() do
        local tLine = conContextMenu:Select(iD) -- Grab the value from the container
        local sKey, wDraw = tLine[1], tLine[5]  -- Extract the key and handler
        if(type(wDraw) == "function") then      -- Check when the value is function
          local bS, vE = pcall(wDraw, oEnt); vE = tostring(vE) -- Always being string
          if(not bS) then oEnt:SetNWString(sKey, sNoA)
            asmlib.LogInstance("Handler"..asmlib.GetReport2(sKey,iD).." fail: "..vE, sLog)
          else
            asmlib.LogInstance("Handler"..asmlib.GetReport3(sKey,iD,vE), sLog)
            oEnt:SetNWString(sKey, vE) -- Write networked value to the hover entity
          end
        end
      end
    else
      if(cTim > pTim[2]) then
        asmlib.Notify(oPly,"Do not rush the context menu!","UNDO")
        pTim[2] = (cTim + nDel) -- For given amont of seconds
      end
    end
  end
  utilAddNetworkString(gsOptionsCV)
  netReceive(gsOptionsCV, PopulateEntity)
end

if(CLIENT) then
  asmlib.SetAction("UPDATE_CONTEXTVAL", -- Must have the same parameters as the hook
    function() local sLog = "*UPDATE_CONTEXTVAL"
      if(not asmlib.IsInit()) then return nil end
      if(not asmlib.IsFlag("tg_context_menu")) then return nil end -- Menu not opened
      if(not asmlib.GetAsmConvar("enctxmenu", "BUL")) then return nil end -- Menu not enabled
      local oPly = LocalPlayer(); if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Player invalid "..asmlib.GetReport(oPly)..">", sLog); return nil end
      local vEye, vAim, tTrig = EyePos(), oPly:GetAimVector(), asmlib.GetOpVar("HOVER_TRIGGER")
      local oEnt = propertiesGetHovered(vEye, vAim); tTrig[2] = tTrig[1]; tTrig[1] = oEnt
      if(asmlib.IsOther(oEnt) or tTrig[1] == tTrig[2]) then return nil end -- Entity trigger
      if(not asmlib.GetAsmConvar("enctxmall", "BUL")) then -- Enable for all props
        local oRec = asmlib.CacheQueryPiece(oEnt:GetModel())
        if(not asmlib.IsHere(oRec)) then return nil end
      end -- If the menu is not enabled for all props ged-a-ud!
      netStart(gsOptionsCV); netWriteEntity(oEnt); netSendToServer() -- Love message
      asmlib.LogInstance("Entity "..asmlib.GetReport2(oEnt:GetClass(),oEnt:EntIndex()), sLog)
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

------------ INITIALIZE DB------------

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
        asmlib.LogInstance("Cannot match "..asmlib.GetReport3(4,arLine[4],snPK),vSrc); return false end
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
          local sP, sO, sA = asmlib.ExportPOA(stPnt, "")
          local sC = (tData.Unit and tostring(tData.Unit or "") or "")
          oFile:Write(sData..sDelim..makTab:Match(iInd,4,true,"\"")..sDelim..
            "\""..sP.."\""..sDelim.."\""..sO.."\""..sDelim.."\""..sA.."\""..sDelim.."\""..sC.."\"\n")
        end
      end; return true
    end,
    ExportAR = function(aRow) aRow[2], aRow[4] = "myType", "gsSymOff" end
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
      local nCnt, iID = 2, makTab:Match(arLine[4],4); if(not asmlib.IsHere(iID)) then
        asmlib.LogInstance("Cannot match "..asmlib.GetReport3(4,arLine[4],snPK),vSrc); return false end
      stData[iID] = {} -- LineID has to be set properly
      while(nCnt <= defTab.Size) do sCol = makTab:GetColumnName(nCnt)
        stData[iID][sCol] = makTab:Match(arLine[nCnt],nCnt)
        if(not asmlib.IsHere(stData[iID][sCol])) then -- Check data conversion output
          asmlib.LogInstance("Cannot match "..asmlib.GetReport3(nCnt,arLine[nCnt],snPK),vSrc); return false
        end; nCnt = (nCnt + 1)
      end; stData.Size = iID; return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSrc)
      local defTab = makTab:GetDefinition()
      for mod, rec in pairs(tCache) do
        local sData = defTab.Name..sDelim..mod
        for iIdx = 1, #rec do local tData = rec[iIdx]; oFile:Write(sData)
          for iID = 2, defTab.Size do local vData = tData[makTab:GetColumnName(iID)]
            local vM = makTab:Match(vData,iID,true,"\""); if(not asmlib.IsHere(vM)) then
              asmlib.LogInstance("Cannot match "..asmlib.GetReport3()); return false
            end; oFile:Write(sDelim..tostring(vM or ""))
          end; oFile:Write("\n") -- Data is already inserted, there will be no crash
        end
      end; return true
    end,
    ExportAR = function(aRow) aRow[4] = "gsSymOff" end
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
    Record = function(arLine, vSrc)
      local noTY = asmlib.GetOpVar("MISS_NOTP")
      arLine[1] = asmlib.GetTerm(arLine[1],noTY,asmlib.Categorize()); return true
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
      local iNameID = makTab:Match(arLine[2],2); if(not asmlib.IsHere(iNameID)) then
        asmlib.LogInstance("Cannot match "..asmlib.GetReport3(2,arLine[2],snPK),vSrc); return false end
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
    end,
    ExportAR = function(aRow) aRow[1], aRow[2] = "myType", "gsSymOff" end
  },
  Query = {
    Record = {"%s","%d","%s"},
    ExportDSV = {1,2}
  },
  [1] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [2] = {"LINEID", "INTEGER", "FLR",  nil },
  [3] = {"NAME"  , "TEXT"   ,  nil ,  nil }
},true,true)
