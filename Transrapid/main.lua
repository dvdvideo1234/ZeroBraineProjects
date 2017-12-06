require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")
require("ZeroBraineProjects/dvdlualib/umaglevlib")

local umgl = umaglevlib

local print                 = print
local pairs                 = pairs
local tostring              = tostring
local tonumber              = tonumber
local Vector                = Vector
local Angle                 = Angle
local Color                 = Color
local CurTime               = CurTime
local setmetatable          = setmetatable
local getmetatable          = getmetatable
local collectgarbage        = collectgarbage
local LocalPlayer           = LocalPlayer
local bitBor                = bit and bit.bor
local entsCreate            = ents and ents.Create
local tableInsert           = table and table.insert
local mathAbs               = math and math.abs
local mathClamp             = math and math.Clamp
local undoCreate            = undo and undo.Create
local undoFinish            = undo and undo.Finish
local undoAddEntity         = undo and undo.AddEntity
local undoSetPlayer         = undo and undo.SetPlayer
local undoSetCustomUndoText = undo and undo.SetCustomUndoText
local file = {}
 file.Append                = fileAppend
 file.Exists                = fileExists
 file.Open                  = fileOpen
 file.CreateDir             = fileCreateDir
local tableGetMax = table and table.getn
local stringGsub            = string and string.gsub
local stringFind            = string and string.find
local stringExplode         = string and string.Explode
local cleanupRegister       = cleanup and cleanup.Register
local languageAdd           = language and language.Add
local duplicatorRegisterEntityClass = duplicator and duplicator.RegisterEntityClass
local libOpVars = umgl.GetLibraryData()

umgl.InitConstants() -- Initialize direct constant values

if(not file.Exists(umgl.GetOpVar("NAME_TOOL"),"DATA")) then file.CreateDir(umgl.GetOpVar("NAME_TOOL")) end

-- Create variable for enabling or disabling the log control
--local bulFlgVar  = bit.bor(FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
local varLogEnab = CreateConVar(umgl.GetOpVar("NAME_TOOL").."_logenab", "1", bulFlgVar, "Controls logging for the maglev library")
local varLogFile = CreateConVar(umgl.GetOpVar("NAME_TOOL").."_logfile", "0", bulFlgVar, "Controls file output for the maglev library")

umgl.InitDependancies(varLogEnab, varLogFile)  -- Initialize the dependent values
umgl.InitDataMapping()  -- Setup the mapping data to be able to import and export general settings
umgl.InitColumnNames()  -- Columns that are enabled for processing
umgl.InitDescription()  -- Initialize description

libOpVars["CLASS_TARGETS"   ] = {
  ["prop_physics"] = true,
  ["prop_dynamic"] = true,
  ["prop_static"]  = true,
  ["prop_ragdoll"] = true
}


tfPro = {
        Icon = "icon16/lorry_go.png",
        Type = "forcer",
        List = "Forcers",
        Offs = {Pos = xyPos, Siz = xySiz, Dsz = xyDsz},
        Cvar = varForcers }
tfPro[1] = { true, "aaa" , 50  , "Identification", "Generic"    , {""}}
tfPro[2] = {"Org", "Origin"   ,  0  , "Orientation"   , "VectorColor", {Vector(0,0,0)}}
tfPro[3] = {"Dir", "Direction",  0  , "Orientation"   , "VectorColor", {Vector(0,0,0)}}


print(umgl.TranslateProperty(tfPro))

--[==[
umgl.InitTargetsHit()

logTable(libOpVars["CLASS_TARGETS"   ], "TARG")


if(false) then
  local obVar = [[
  @{forcer:UR}{Org:0, 60,0}{Dir:0,0,1}
  @{forcer:UL}{Org:0,-60,0}{Dir:0,0,1}
  @{forcer:LR}{Org:0,  0,0}{Dir:0,1,0}
  ]]
  local syInis = umgl.GetOpVar("OPSYM_INITSTRING")
  local tVal, tIni, tSeq = stringExplode(syInis,obVar:Trim("%s"):Trim(syInis)), {}, {}
    for ID = 1, #tVal do
      if(not umgl.TransformSettings(tVal[ID], tIni, tSeq)) then
        logStatus("SetupDataSheet: pnLV.OnRowSelected: Unable to transform <"..tVal[ID]..">") end
    end
  logTable(tIni,"tIni"); logTable(tSeq,"tSeq")
  rep = umgl.GetKeyReportID(tIni["forcer"])
  logTable(rep,"rep")
end

if(false) then
  local m = umgl.GetOpVar("MAPPING_GENERAL")
  local d = umgl.GetOpVar("MAPPING_MAGDATA")
  local e = {[umgl.GetOpVar("HASH_ENTITY")]={}}; b = e[umgl.GetOpVar("HASH_ENTITY")]
  e.IsValid = function(a) return true end
  e.GetClass = function(a) return umgl.GetOpVar("FILE_ENTITY") end
  b.Name = "aaa"
  b.Prop = "models"
  b.FwLoc = Vector(1,2,3)
  b.UpLoc = Vector(4,5,6)
  b.CnLoc = Vector()
  b.Mass = 70
  b.Tick = 0.5
  b.KeyOn = 14
  b.KeyF = 10
  b.KeyR = 55
  b.NumFor = 5000
  b.NumTog = true
  b.Target = ""
  b.Control ={}
  b.Sensors = {}
  b.Forcers = {}
  local t = umgl.GetGeneralTable(e)
  local p = "#base_comp"
  local u = umgl.InitializeUnitSource(p,b.Target,false)
  b.Sensors = u["sensor"]
  b.Forcers = u["forcer"]
  b.Control = u["control"]
  local g = u["general"]
  b.Control["BB"] = {
      ["Tar"]   = {"AAA","BBB","3"},
      ["Tun"]   = {"1,2,3","1,2,3","1,2,3"},
      ["Ref"]   = {0, "RefGap"}, --RefGap
      ["Prs"]   = "A+B",
      ["Cmb"]   = true,
      ["Neg"]   = true,
      ["Dev"]   = function() end,
      ["ID"]    = 4 
    }

  umgl.SetGeneralTable(b,g)
  
  umgl.ValidateTable("DataMGL", b, d)
  umgl.ExportUnitSource(e,"base_comp_")
  
 logTable(m,"mAP")
 logTable(g,"GE")
 logTable(b.Control, "FRC")
 logTable(b.Sensors, "SEN")
 logTable(d, "D")
end

]==]--