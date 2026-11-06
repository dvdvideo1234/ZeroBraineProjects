-- Luapad
-- An in-game scripting environment
-- by DarKSunrise aka Assassini
-- Ported to GMod 13 by SparkZ
luapad = {}
luapad.debugmode = true
luapad.forcedownload = true
luapad.ignoreconsoleopen = true
local GLOB_CONFIG = {
  DELIMS = "|", -- General symbol used for separator
  PANLSZ = 2 / 3, -- The ratio panel will use according to the screen size
  DAYINS = 86400, -- The amount of second present in one day
  MAXMSL = 60000, -- As the maximum write string limit is 65532
  FMQUOT = "\"%s\"", -- Format something to put it in double quotes
  PATNLN = "[\r\n]+", -- Pattern for reading configuration files
  THMDEF = {"luapad/theme/", "default"}, -- Default theme configuration
  VALDFS = {"[%/\\:%*%?\"<>|]", "^([^%.]+)"}, -- File system name validation
  RESNAM = {CON = true, PRN = true, AUX = true, NUL = true}, -- Disabled folder names
  PATENM = "[A-Z_]+", -- General pattern matching a enumeration key
  ADDONN = "Luapad", -- Generic addon name used to distinguish messages
  FOLDER = "luapad/", -- Default application folder in the data file system
  LOWADN = "luapad", -- Addon name lower case for hashes, messages and convars
  ICOFMT = "icon16/%s.png", -- Icon path format string
  FMNAME = "untitled%d.txt", -- Untitled new file format string
  MSGCAL = "%s > %s:", -- Used for status messages send across the realms
  FFDRPT = "[%s%s]", -- File format identifier for user messages
  STORKY = "gmod_luapad",    -- Dedicated tab panel key to store stream info
  PRESND = "ambient/water/drip%d.wav", -- Sound format played on button press
  DATFMT = "%Y-%m-%d %H:%M:%S", -- Date and time general format
  SRCHFM = "Found routine [%s] in %s", -- Debug search messages
  CFLAGS = bit.bor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY),
  RFLAGS = bit.bor(FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
}
-- They can still do cs lua if you don't have 'sv_allowcslua 0'!!!
local VAR_STM = CreateConVar(GLOB_CONFIG.LOWADN.."_statmsgtm",  1, GLOB_CONFIG.RFLAGS, "Status messages time visible fraction delta", 0, 100)
local VAR_ARN = CreateConVar(GLOB_CONFIG.LOWADN.."_autorenew", 14, GLOB_CONFIG.RFLAGS, "File grace period for auto renew in days", 0, 1000)
local VAR_ADM = CreateConVar(GLOB_CONFIG.LOWADN.."_adminonly",  1, GLOB_CONFIG.RFLAGS, "Makes the luapad addon admin usable only", 0, 1)
local VAR_MXF = CreateConVar(GLOB_CONFIG.LOWADN.."_maxunamed", 10, GLOB_CONFIG.RFLAGS, "Maximum number of new files in the folder", 0, 100)
local VAR_MXR = CreateConVar(GLOB_CONFIG.LOWADN.."_maxrecurs", 20, GLOB_CONFIG.RFLAGS, "Recurse depth when opening a file system", 0, 100)
local VAR_EDT = CreateConVar(GLOB_CONFIG.LOWADN.."_endataorg",  1, GLOB_CONFIG.RFLAGS, "File operation in the whole data folder", 0, 1)
local VAR_THM = CreateConVar(GLOB_CONFIG.LOWADN.."_themename", "default", GLOB_CONFIG.CFLAGS, "Syntax highlighting theme being used")
----------------------------

luapad.GLOB_CONFIG = GLOB_CONFIG
GLOB_CONFIG.FOLDER = "C:/Programs/ZeroBraineIDE/ZeroBraineProjects/Garrysmod/Luapad/"..GLOB_CONFIG.FOLDER

local COLOR_STATUS = {
  ["#TEMCO#"] = Color(  0,   0,   0,   0),
  ["STAT_OK"] = Color(72 , 205,  72, 255),
  ["STAT_WR"] = Color(205, 140,  72, 255),
  ["STAT_ER"] = Color(205,  72,  72, 255),
  ["COMS_OK"] = Color(92 , 205,  92, 255),
  ["COMS_WR"] = Color(205, 140,  92, 255),
  ["COMS_ER"] = Color(205,  92,  92, 255),
  ["COMS_SV"] = Color(136, 221, 255, 255),
  ["COMS_CL"] = Color(255, 221, 102, 255)
}
local ACCEPTED_STEAMS = {
  [GLOB_CONFIG.LOWADN..".Upload"] = true,
  [GLOB_CONFIG.LOWADN..".UploadClient"] = true
}
-- https://heyter.github.io/js-famfamfam-search/
-- Extension configurations
local ENABLE_EXTENS = {
  ["txt"]       = {Icon = "page_white_text"        },
  ["lua"]       = {Icon = "page_white_code"        },
  ["c"]         = {Icon = "page_white_c"           },
  ["h"]         = {Icon = "page_white_h"           },
  ["cpp"]       = {Icon = "page_white_cplusplus"   },
  ["csproj" ]   = {Icon = "page_white_visualstudio"},
  ["vcxproj"]   = {Icon = "page_white_visualstudio"},
  ["vbproj" ]   = {Icon = "page_white_visualstudio"},
  ["fsproj" ]   = {Icon = "page_white_visualstudio"},
  ["pyproj" ]   = {Icon = "page_white_visualstudio"},
  ["dbproj" ]   = {Icon = "page_white_visualstudio"},
  ["wixproj"]   = {Icon = "page_white_visualstudio"},
  ["cs"]        = {Icon = "page_white_csharp"      },
  ["rb"]        = {Icon = "page_white_ruby"        },
  ["ru"]        = {Icon = "page_white_ruby"        },
  ["sh"]        = {Icon = "page_white_tux"         },
  ["md"]        = {Icon = "page_white_put"         },
  ["sql"]       = {Icon = "page_white_database"    },
  ["csv"]       = {Icon = "page_white_excel"       },
  ["tsv"]       = {Icon = "page_white_excel"       },
  ["json"]      = {Icon = "page_white_code_red"    },
  ["yaml"]      = {Icon = "page_white_wrench"      },
  ["xml"]       = {Icon = "page_white_excel"       },
  ["php"]       = {Icon = "page_white_php"         },
  ["html"]      = {Icon = "page_white_world"       },
  ["svg"]       = {Icon = "page_white_vector"      },
  ["coffee"]    = {Icon = "page_white_cup"         },
  ["litcoffee"] = {Icon = "page_white_cup"         }
}
-- Browsed folder configurations
local ENABLE_FOLDER = {
  ["data"     ] = {ID = 1, Icon = "table_save"},
  ["lua"      ] = {ID = 2, Icon = "page_code" },
  ["addons"   ] = {ID = 3, Icon = "package"   },
  ["download" ] = {ID = 4, Icon = "transmit"  },
  ["gamemodes"] = {ID = 5, Icon = "joystick"  }
}
local RESTRICTED_FILES = {
  "data/"..GLOB_CONFIG.FOLDER.."welcome.txt",
  "data/"..GLOB_CONFIG.FOLDER.."saved_tabs.txt",
  "data/"..GLOB_CONFIG.FOLDER.."sv_syntax_globals.txt",
  "data/"..GLOB_CONFIG.FOLDER.."cl_syntax_globals.txt",
  "addons/luapad/data/"..GLOB_CONFIG.FOLDER.."welcome.txt",
  "addons/luapad/data/"..GLOB_CONFIG.FOLDER.."saved_tabs.txt",
  "addons/luapad/data/"..GLOB_CONFIG.FOLDER.."sv_syntax_globals.txt",
  "addons/luapad/data/"..GLOB_CONFIG.FOLDER.."cl_syntax_globals.txt"
}
local FMSYNTAX_HILIGHT = {
  X = {
    ["package"                   ] = true, ["wire_expression2_funcs"  ] = true,
    ["ArcCW|AttachmentTable"     ] = true, ["ArcCW|BulletProfileDict" ] = true,
    ["ArcCW|ClientMenus"         ] = true, ["CPUGateActions"          ] = true,
    ["CPUGatesSorted"            ] = true, ["E2Lib"                   ] = true,
    ["G_BPClassLoaders"          ] = true, ["G_BPMetaRegistry"        ] = true,
    ["GateActions"               ] = true, ["MediaPlayer"             ] = true,
    ["duplicator|EntityModifiers"] = true, ["duplicator|EntityClasses"] = true,
    ["properties|List"           ] = true, ["derma|SkinList"          ] = true,
    ["SligWolf_Addons"           ] = true, ["StreamRadioLib"          ] = true,
    ["WireGatesSorted"           ] = true, ["bpdermanode"             ] = true,
    ["bplayout"                  ] = true, ["bplist_meta"             ] = true,
    ["bplistdiff_meta"           ] = true, ["bplocalization"          ] = true,
    ["bpmodule_meta"             ] = true, ["bpmodule"                ] = true,
    ["bpnewrender2d_meta"        ] = true, ["bpnewrender2d"           ] = true,
    ["bpmoduleeditor_meta"       ] = true, ["bpmoduleeditor"          ] = true,
    ["bpnode_meta"               ] = true, ["bpnode"                  ] = true,
    ["bpobjectlinker_meta"       ] = true, ["bpobjectlinker"          ] = true,
    ["bppin_meta"                ] = true, ["bppin"                   ] = true,
    ["coastertabmanager|List"    ] = true, ["matproxy|ProxyList"      ] = true,
    ["trackmanager"              ] = true, ["tanktracktool"           ] = true,
    ["jcon|binds"                ] = true, ["net|Receivers"           ] = true,
    ["jcon|configCache"          ] = true, ["jcon|reg"                ] = true,
    ["jcon|jconcali"             ] = true, ["jcon|jconpanel"          ] = true
  },
  N = GLOB_CONFIG.LOWADN.. "._sG", -- Name
  I = "[\"%s\"]",   -- Index
  V = " = \"%s\"",  -- Value
  H = " = %s or {}" -- Header
}
local PATPATH_CONVERT = {
  {"[\\/]+", "/"}, {"%.%./", ""},
  {"^[/]+" , "" }, {"[/]+$", ""},
  Divr = "/", Sors = {"^data/", "", 1},
  Base = {"^"..GLOB_CONFIG.FOLDER, "", 1},
}
local FMSYNTAX_METATYP = {
  ["string"            ] = {ID = TYPE_STRING          },
  ["table"             ] = {ID = TYPE_TABLE           },
  ["thread"            ] = {ID = TYPE_THREAD          },
  ["Entity"            ] = {ID = TYPE_ENTITY          },
  ["Player"            ] = {ID = TYPE_ENTITY          },
  ["Weapon"            ] = {ID = TYPE_ENTITY          },
  ["NPC"               ] = {ID = TYPE_ENTITY          },
  ["Vehicle"           ] = {ID = TYPE_ENTITY          },
  ["CSEnt"             ] = {ID = TYPE_ENTITY          },
  ["NextBot"           ] = {ID = TYPE_ENTITY          },
  ["Vector"            ] = {ID = TYPE_VECTOR          },
  ["Angle"             ] = {ID = TYPE_ANGLE           },
  ["PhysObj"           ] = {ID = TYPE_PHYSOBJ         },
  ["ISave"             ] = {ID = TYPE_SAVE            },
  ["IRestore"          ] = {ID = TYPE_RESTORE         },
  ["CTakeDamageInfo"   ] = {ID = TYPE_DAMAGEINFO      },
  ["CEffectData"       ] = {ID = TYPE_EFFECTDATA      },
  ["CMoveData"         ] = {ID = TYPE_MOVEDATA        },
  ["CRecipientFilter"  ] = {ID = TYPE_RECIPIENTFILTER },
  ["CUserCmd"          ] = {ID = TYPE_USERCMD         },
  ["IMaterial"         ] = {ID = TYPE_MATERIAL        },
  ["Panel"             ] = {ID = TYPE_PANEL           },
  ["CLuaParticle"      ] = {ID = TYPE_PARTICLE        },
  ["CLuaEmitter"       ] = {ID = TYPE_PARTICLEEMITTER },
  ["ITexture"          ] = {ID = TYPE_TEXTURE         },
  ["ConVar"            ] = {ID = TYPE_CONVAR          },
  ["IMesh"             ] = {ID = TYPE_IMESH           },
  ["VMatrix"           ] = {ID = TYPE_MATRIX          },
  ["CSoundPatch"       ] = {ID = TYPE_SOUND           },
  ["pixelvis_handle_t" ] = {ID = TYPE_PIXELVISHANDLE  },
  ["DynamicLight"      ] = {ID = TYPE_DLIGHT          },
  ["IVideoWriter"      ] = {ID = TYPE_VIDEO           },
  ["File"              ] = {ID = TYPE_FILE            },
  ["CLuaLocomotion"    ] = {ID = TYPE_LOCOMOTION      },
  ["PathFollower"      ] = {ID = TYPE_PATH            },
  ["CNavArea"          ] = {ID = TYPE_NAVAREA         },
  ["IGModAudioChannel" ] = {ID = TYPE_SOUNDHANDLE     },
  ["CNavLadder"        ] = {ID = TYPE_NAVLADDER       },
  ["CNewParticleEffect"] = {ID = TYPE_PARTICLESYSTEM  },
  ["ProjectedTexture"  ] = {ID = TYPE_PROJECTEDTEXTURE},
  ["PhysCollide"       ] = {ID = TYPE_PHYSCOLLIDE     },
  ["SurfaceInfo"       ] = {ID = TYPE_SURFACEINFO     },
  ["Color"             ] = {ID = TYPE_COLOR           }
}
--[[
 * Checks whenever the parameter is present
]]
local function isHere(vA)
  return (vA ~= nil and vA ~= "")
end

--[[
 * Checks if the path has disabled folder names
]]
function luapad.IsPath(sP)
  local sP = tostring(sP or "")
  if(not isHere(sP)) then return false end
  local tP = PATPATH_CONVERT
  local tD = GLOB_CONFIG.RESNAM
  local sF = GLOB_CONFIG.VALDFS[1]
  for iP = 1, #tP do
    sP = string.gsub(sP, unpack(tP[iP]))
  end
  local tN = tP.Divr:Explode(sP, false)
  for iN = 1, #tN do
    local sN = tN[iN]:upper()
    if(tD[sN]) then return false end
    if(sN:find(sF)) then return false end
  end
  return true, sP
end

--[[
 * Calculates an inverted color
]]
function luapad.GetInvertColor(vC, vO)
  if(not IsColor(vC)) then return nil end
  local nR, nG, nB, nA = vC:Unpack()
  nR, nG, nB = 255 - nR, 255 - nG, 255 - nB
  if(IsColor(vO)) then
    vO:SetUnpacked(nR, nG, nB, nA)
    return vO
  else
    return Color(nR, nG, nB, nA)
  end
end

--[[
 * The path provided is always relative to the game folder
]]
local function canOperateIn(sPath)
  local tP = PATPATH_CONVERT
  local bB, sB, oB = luapad.GetPath(sPath)
  if(bB) then -- In the data folder
    if(VAR_EDT:GetBool()) then return true end
    local nS, nE = sB:find(tP.Base[1])
    if(nS and nE and nS == 1) then return true end
  end; return false
end

local function canUserAccess(pUser)
  if not IsValid(pUser) then
    return false
  elseif VAR_ADM:GetBool() then
    local bA = (pUser:IsAdmin() or pUser:IsSuperAdmin())
    if not bA then
      pUser:ChatPrint("Sorry "..pUser:Nick()..", only admins can use "..GLOB_CONFIG.ADDONN..".")
    end
    return bA
  else
    return true
  end
end

local function canUserAcceptStream(ply, index)
  if (ply:IsAdmin() or ply:IsSuperAdmin()) and ACCEPTED_STEAMS[index] then
    return true
  end
  if (not ply:IsAdmin()) and ACCEPTED_STEAMS[index] then
    return false
  end
  return false
end

local function canWriteString(sCon)
  return (string.len(tostring(sCon or "")) <= GLOB_CONFIG.MAXMSL)
end

--[[
 Returns true if
  1. Automatic renew is enabled
  2. File is missing from the system
  3. File has an invalid timestamp
  4. File is older than the interval
 Returns false otherwise
 * sN > File full path in the mounted FS
 * sP > The internal mount FS name
]]
function isAutoRenewDue(sN, sP)
  local nD = VAR_ARN:GetFloat()
  if(nD == 0) then return false end
  local bE = file.Exists(sN, sP)
  if(not bE) then return true end
  local nT = file.Time(sN, sP)
  if(nT == 0) then return true end
  local nC = nD * GLOB_CONFIG.DAYINS
  return (os.time() - nT) > nC
end

local function getString(...)
  local tA, nA = table.Pack(...)
  for iA = 1, nA do tA[iA] = tostring(tA[iA]) end
  return unpack(tA)
end

local function runScriptHandler(sCon, sID, aSta)
  if(SERVER or not canUserAccess(LocalPlayer())) then return end
  local oR = CompileString(sCon, sID, false)
  if(isfunction(oR)) then -- Compiled successfully
    local bS, sE = pcall(oR)
    if bS then -- The code executes successfully
      aSta("Execute %s successfully!", "COMS_CL", sID)
    else -- The code gives an error at runtime
      aSta("Runtime error: %s", "COMS_ER", sE)
    end
  else -- Error during compilation
    aSta("Compilation error: %s", "COMS_ER", oR)
  end
end

--[[
 * Global shared function to show status in the console
]]
function luapad.SetConsole(sFmt, sKey, ...)
  if(not sKey) then return end
  local cDrw = COLOR_STATUS[sKey]
  if(not cDrw) then return end
  local cTmc = COLOR_STATUS["#TEMCO#"]
  -- Moce color data to status color
  cTmc.r, cTmc.g = cDrw.r, cDrw.g
  cTmc.b, cTmc.a = cDrw.b, cDrw.a
  MsgC(cTmc, sFmt:format(getString(...)).."\n")
end

function luapad.genSyntaxGlobals()
  -- Generate a syntax highlighting configuration file based on the instance
  local sP = SERVER and "sv_" or (CLIENT and "cl_" or "na_")
  local sG = GLOB_CONFIG.FOLDER..sP.."syntax_globals.txt"
  -- Check whenever the file has to be renewed and generate it again
  local bE, bA = file.Exists(sG, "DATA"), isAutoRenewDue(sG, "DATA")
  if(bE and not bA) then return end -- Exists and not auto renewed
  -- Replace the file on the instance
  local fS = file.Open(sG, "wb", "DATA")
  if(not fS) then -- The file open attempt has failed
    luapad.SetConsole("Failed opening globals: %s", "STAT_WR", sG)
    return -- Exit the routine end report the status
  end
  -- Allocate placeholders for registry elements
  local tMeta, tEnum, tPass = {}, {}, {}
  local tX = FMSYNTAX_HILIGHT.X -- Terminate recurs early
  local sN, sV = FMSYNTAX_HILIGHT.N, FMSYNTAX_HILIGHT.V
  local sI, sH = FMSYNTAX_HILIGHT.I, FMSYNTAX_HILIGHT.H
  local function extractStringKeys(tS, sB)
    if(not istable(tS)) then return {} end
    local tK = table.GetKeys(tS)
    local sA = GLOB_CONFIG.ADDONN
    for aK, aV in pairs(tK) do
      if(not isstring(aV)) then tK[aK] = nil
        if(luapad.debugmode and sB) then
          luapad.SetConsole("%s > Syntax: Base %s key {%s} is {%s}!", "STAT_WR", sA, sB, aV, type(aV))
        end -- In case the debug mode is enabled you can see the dropped keys from processing
      end -- Make sure to get rid of every entry that is not a string
    end -- Process all the strings and pack them up in client/server
    return table.ClearKeys(tK, false)
  end
   -- Global registry includes itself
  local function exportSyntax(sB, tS, iD, sK)
    local iD, nU = math.max((tonumber(iD) or 0), 0), 0
    if(iD > 5) then return end -- Recursion depth
    if(tPass[tS]) then return end -- Already registered
    local sD, sT = GLOB_CONFIG.DELIMS, GLOB_CONFIG.VALDFS[1]
    local sP, sK = GLOB_CONFIG.PATENM, tostring(sK or "")
    local sU, rU = sB:gsub("^.-%[\"", ""):gsub("\"%]$", "")
    local tK, sC = extractStringKeys(tS, sB), ("\"][\"")
    local tU, bH, bS = sC:Explode(sU), true, false; nU = (#tU + 1)
    table.sort(tK, function(u, v) return u < v end)

    for iE = 1, #tK do -- Loop alphabetically
      local vK = tK[iE]
      local vE = tS[vK]
      local vO = (iD == 0) and vK or (sK..sD..vK)
      if(isfunction(vE)) then
        if(bH) then bH = false
          fS:Write(sB)
          fS:Write(sH:format(sB))
          fS:Write("\n")
        end
        bS = true
        fS:Write(sB)
        fS:Write(sI:format(vK))
        fS:Write(sV:format("f"))
        fS:Write("\n")
      elseif(string.upper(vK) == vK and vK:match(sP)) then
        if(bH) then bH = false
          fS:Write(sB)
          fS:Write(sH:format(sB))
          fS:Write("\n")
        end
        if(rU == 0) then table.insert(tEnum, vK) else
          tU[nU] = vK; bS = true -- Register local enums
          table.insert(tEnum, table.concat(tU, sC))
        end -- Nothing is replaced no keys registered
      elseif(istable(vE)) then tPass[tS] = true
        if(not table.IsEmpty(vE) and not tX[vO] and not vK:match(sT)) then
          if(bH) then bH = false
            fS:Write(sB)
            fS:Write(sH:format(sB))
            fS:Write("\n")
          end
          local bF = exportSyntax(sB..sI:format(vK), vE, iD + 1, vO)
        end
      end
    end
    return bS
  end
  fS:Write("-- This is an automatically generated cache file on the server-side\n")
  fS:Write("-- The content includes global functions, meta-tables, and enumerations\n")
  fS:Write("-- Don't touch it, or you'll probably mess up your syntax highlighting\n")
  fS:Write("-- The timestamp of this generated file is ["..os.date(GLOB_CONFIG.DATFMT).."]\n")
  fS:Write("\n-- Global functions and libraries\n\n")
  local tK = extractStringKeys(_G) -- Global registry includes itself
  table.sort(tK, function(u, v) return u < v end); exportSyntax(sN, _G)
  local nE = #tEnum
  if(nE > 0) then
    fS:Write("\n-- Enumerations\n\n")
    table.sort(tEnum, function(u, v) return u < v end)

    for iE = 1, nE do -- Loop alphabetically
      local sK = tEnum[iE]
      fS:Write(sN)
      fS:Write(sI:format(sK))
      fS:Write(sV:format("e"))
      fS:Write("\n")
    end
  end
  fS:Write("\n-- Meta-tables\n\n")
  -- https://wiki.facepunch.com/gmod/Enums/TYPE
  local sS = "-- Source: [%s][%s]\n"
  local tK = table.GetKeys(FMSYNTAX_METATYP)
  table.sort(tK, function(u, v) return u < v end)

  for iM = 1, #tK do -- Loop alphabetically
    local sC = tK[iM]
    local vM = FMSYNTAX_METATYP[sC]
    if (vM.ID) then -- Type exists in TypeID
      local mM = FindMetaTable(sC)
      if(mM and istable(mM)) then
        local tK, bH = table.GetKeys(mM), true
        for iK = 1, #tK do
          local n = tK[iK]
          local e = mM[n]
          if (isfunction(e) and not tMeta[n]) then
            if(bH) then bH = false
              fS:Write(sS:format(tostring(vM.ID), sC))
            end
            fS:Write(sN)
            fS:Write(sI:format(n))
            fS:Write(sV:format("m"))
            fS:Write("\n"); tMeta[n] = true
          end
        end; if(not bH) then fS:Write("\n") end
      end
    end
  end
  local sQ = GLOB_CONFIG.FMQUOT
  local sA = sQ:format(GLOB_CONFIG.ADDONN)
  local sP = sQ:format(GLOB_CONFIG.FFDRPT:format("data/"..sG, ""))
  local sC = sQ:format("COMS_"..(SERVER and "SV" or "CL"))
  local sF = sQ:format("%s > Syntax imported: %s")
  local sT = "luapad.SetConsole(%s, %s, %s, %s)\n"
  fS:Write("-- Write a console message for the imported syntax\n") 
  fS:Write(sT:format(sF, sC, sA, sP))
  
  fS:Flush(); fS:Close()
  luapad.SetConsole("Syntax globals generated: %s", "STAT_OK", sG)
end

luapad.genSyntaxGlobals() -- Generate server-side globals
if (SERVER) then
  util.AddNetworkString(GLOB_CONFIG.LOWADN..".Upload")
  util.AddNetworkString(GLOB_CONFIG.LOWADN..".UploadClient")
  util.AddNetworkString(GLOB_CONFIG.LOWADN..".BroadcastUsers")
  util.AddNetworkString(GLOB_CONFIG.LOWADN..".StatusCallback")
  if (luapad.forcedownload) then
    AddCSLuaFile("autorun/luapad.lua")
    AddCSLuaFile("autorun/luapad_editor.lua")
  end
  -- If the server has configuration files send them to the clients
  if(file.Exists(GLOB_CONFIG.FOLDER.."sv_syntax_globals.txt", "DATA")) then
    resource.AddSingleFile("data/"..GLOB_CONFIG.FOLDER.."sv_syntax_globals.txt")
  end
  -- The sever owners can write their own custom welcome files
  if(file.Exists(GLOB_CONFIG.FOLDER.."welcome.txt", "DATA")) then
    resource.AddSingleFile("data/"..GLOB_CONFIG.FOLDER.."welcome.txt")
  end
  -- The sever owners can write their own custom about files
  if(file.Exists(GLOB_CONFIG.FOLDER.."about.txt", "DATA")) then
    resource.AddSingleFile("data/"..GLOB_CONFIG.FOLDER.."about.txt")
  end
  net.Receive(GLOB_CONFIG.LOWADN..".Upload",
    function(len, ply)
      if(not canUserAccess(ply)) then return end
      local sS, sI = net.ReadString(), net.ReadString()
      local bC, sM, cM = net.ReadBool(), nil, nil
      if(sS and (ply:IsAdmin() or ply:IsSuperAdmin())) then
        local oR = CompileString(sS, sI, false)
        if(isfunction(oR)) then -- Compiled successfully
          local bS, sE = pcall(oR)
          if bS then -- The code executes successfully
            sM, cM = string.format("Execute %s successfully!", getString(sI)), "COMS_SV"
          else -- The code gives an error at runtime
            sM, cM = string.format("Runtime error: %s", getString(sE)), "COMS_ER"
          end
        else -- Error during compilation
          sM, cM = string.format("Compilation error: %s", getString(oR)), "COMS_ER"
        end
      else -- The user has no rights
        sM, cM = string.format("Execute %s forbidden! (check your admin rights)", getString(sI)), "COMS_WR"
      end
      if(bC) then
        luapad.SetConsole(sM, cM)
      else
        net.Start(GLOB_CONFIG.LOWADN..".StatusCallback")
        net.WriteString(sM)
        net.WriteString(cM)
        net.Send(ply)
      end
    end)

  net.Receive(GLOB_CONFIG.LOWADN..".UploadClient",
    function(len, ply)
      if(not canUserAccess(ply)) then return end
      local sP, cM, sM = GLOB_CONFIG.LOWADN, nil, nil
      local sS, sI = net.ReadString(), net.ReadString()
      if(sS and (ply:IsAdmin() or ply:IsSuperAdmin())) then
        net.Start(sP..".BroadcastUsers")
        net.WriteString(sS)
        net.WriteString(sI)
        net.Broadcast()
        cM = "COMS_OK" -- Sent the status back to the client with the opened panel
        sM = string.format("Broadcast %s successful! (check client console for errors)", getString(sI))
      else
        cM = "COMS_WR" -- Sent the status back to the client with the opened panel
        sM = string.format("Broadcast %s forbidden! (check your admin rights)", getString(sI))
      end
      net.Start(sP..".StatusCallback")
      net.WriteString(sM)
      net.WriteString(cM)
      net.Send(ply)
    end)

  return
end

if (CLIENT) then
  net.Receive(GLOB_CONFIG.LOWADN..".BroadcastUsers",
    function(len)
      runScriptHandler(net.ReadString(), net.ReadString(), luapad.SetConsole)
    end)

  net.Receive(GLOB_CONFIG.LOWADN..".StatusCallback",
    function() -- Output in the client panel
      local sM = net.ReadString()
      local cM = net.ReadString()
      luapad.SetStatus(sM, cM)
    end)

end

if (file.Exists(GLOB_CONFIG.FOLDER.."cl_syntax_globals.txt", "DATA")) then
  RunString(file.Read(GLOB_CONFIG.FOLDER.."cl_syntax_globals.txt", "DATA"))
  if (file.Exists(GLOB_CONFIG.FOLDER.."sv_syntax_globals.txt", "DATA")) then
    RunString(file.Read(GLOB_CONFIG.FOLDER.."sv_syntax_globals.txt", "DATA"))
  end -- In case the server file is added and transferred merge the syntax keys
else -- Load the hard-coded syntax highlighter relative to the lua folder
  include(GLOB_CONFIG.FOLDER.."syntax_globals.lua")
end

--[[
 * Populates the status bar with the popper message
 * The message alpha is fading until it disappears
 * sFmt > Message format. All substitutions are strings
 * sKey > Color key from the status table
 * ...  > The values that match the format string
 * Returns: The Created label panel
]]
function luapad.SetStatus(sFmt, sKey, ...)
  if(SERVER) then return end
  if(not sKey) then return end
  local cDrw = COLOR_STATUS[sKey]
  if(not cDrw) then return end
  local cTmc = COLOR_STATUS["#TEMCO#"]
  local pB = luapad.Statusbar
  if(not IsValid(pB)) then return end
  local nF = (1 / VAR_STM:GetFloat())
  local sI = GLOB_CONFIG.LOWADN..".Statusbar.Fade"
  -- Moce color data to status color
  cTmc.r, cTmc.g = cDrw.r, cDrw.g
  cTmc.b, cTmc.a = cDrw.b, cDrw.a
  timer.Remove(sI); pB:Clear()
  local pLab = vgui.Create("DLabel", pB)
  pLab:SetText(sFmt:format(getString(...)))
  pLab:SetTextColor(cTmc) -- Reference assignment
  pLab:SizeToContents()
  timer.Create(sI, 0.01, 0,
    function()
      if(not IsValid(pLab)) then return end
      local cBar = pLab:GetTextColor()
      cBar.a = math.Clamp(cBar.a - nF, 0, 255)
      pLab:SetTextColor(cBar)
      if (cBar.a == 0) then timer.Remove(sI)
        if(IsValid(pLab)) then pLab:Remove() end
      end
    end)

  pB:Add(pLab)
  -- https://wiki.facepunch.com/gmod/HL2_Sound_List
  surface.PlaySound(GLOB_CONFIG.PRESND:format(math.random(1, 4)))
  return pLab
end

function luapad.About()
  if(SERVER) then return end
  local sD = GLOB_CONFIG.FOLDER
  if (not file.Exists(sD.."about.txt", "DATA")) then
    return
  end
  luapad.AddTab("about.txt", file.Read(sD.."about.txt", "DATA"), "data/"..sD)
end

-- https://heyter.github.io/js-famfamfam-search/
function luapad.ToIcon(sIco)
  return GLOB_CONFIG.ICOFMT:format(tostring(sIco))
end

--[[
 * Shows a standard confirmation dialog window
 * sMsg  > The massage being send to the user
 * sTxt  > Enable text entry and fill it with this value
 * fnSuc > Function to run then the left button is clicked
 * fnDsc > Function to run then the right button is clicked
 * sSuc  > Label to use for the left button
 * sDsc  > Label to use for the right button
]]
function luapad.ShowConfirmDialog(sMsg, sTxt, fnSuc, fnDsc, sSuc, sDsc)
  if(SERVER) then return end
  local pFrame = vgui.Create("DFrame")
  if(not IsValid(pFrame)) then return end
  pFrame:SetTitle(GLOB_CONFIG.ADDONN)
  pFrame:SetDraggable(false)
  pFrame:ShowCloseButton(false)
  pFrame:SetBackgroundBlur(true)
  pFrame:SetDrawOnTop(true)
  local pSors = vgui.Create("DPanel", pFrame)
  if(not IsValid(pSors)) then return end
  pSors:SetPaintBackground(false)
  local pText
  local pMesg = vgui.Create("DLabel", pSors)
  if(not IsValid(pMesg)) then return end
  pMesg:SetText(sMsg or "<Message text here>")
  pMesg:SizeToContents()
  pMesg:SetContentAlignment(5)
  pMesg:SetTextColor(color_white)
  if(isHere(sTxt)) then
    pText = vgui.Create("DTextEntry", pSors)
    if(not IsValid(pText)) then return end
    pText:SetText(tostring(sTxt or ""))
    pText.OnEnter = function()
      pFrame:Close()
      local bS, sE = pcall(fnSuc, pText:GetValue()); if(not bS) then
        luapad.SetStatus("Enter [%s] error: %s", "STAT_ER", pText:GetValue(), sE) end
    end
  end
  local pBase = vgui.Create("DPanel", pFrame)
  if(not IsValid(pBase)) then return end
  pBase:SetTall(30)
  pBase:SetPaintBackground(false)
  local pA = vgui.Create("DButton", pBase)
  if(not IsValid(pA)) then return end
  pA:SetText( sSuc or "#dialog.ok" )
  pA:SizeToContents()
  pA:SetTall(20)
  pA:SetWide(pA:GetWide() + 20)
  pA:SetPos(5, 5)
  pA.DoClick = function()
    pFrame:Close()
    if(pText) then
      local bS, sE = pcall(fnSuc, pText:GetValue()); if(not bS) then
        luapad.SetStatus("Accept [%s] error: %s", "STAT_ER", pText:GetValue(), sE) end
    else
      local bS, sE = pcall(fnSuc); if(not bS) then
        luapad.SetStatus("Accept error: %s", "STAT_ER", sE) end
    end
  end
  local pC = vgui.Create("DButton", pBase)
  if(not IsValid(pC)) then return end
  pC:SetText(sDsc or "#dialog.cancel")
  pC:SizeToContents()
  pC:SetTall(20)
  pC:SetWide(pA:GetWide() + 20)
  pC:SetPos(5, 5)
  pC.DoClick = function()
    pFrame:Close()
    if (fnDsc) then
      if(pText) then
        local bS, sE = pcall(fnDsc, pText:GetValue()); if(not bS) then
          luapad.SetStatus("Cancel [%s] error: %s", "STAT_ER", pText:GetValue(), sE) end
      else
        local bS, sE = pcall(fnDsc); if(not bS) then
          luapad.SetStatus("Cancel error: %s", "STAT_ER", sE) end
      end
    end
  end
  pC:MoveRightOf(pA, 5)
  pBase:SetWide(pA:GetWide() + 5 + pC:GetWide() + 10)
  local nW, nH = pMesg:GetSize()
  nW = math.max( nW, 400 )
  pFrame:SetSize(nW + 50, nH + 25 + 75 + 10)
  pFrame:Center()
  pSors:StretchToParent(5, 25, 5, 45)
  pMesg:StretchToParent(5, 5, 5, 35)
  if(pText) then
    pText:StretchToParent(5, nil, 5, nil)
    pText:AlignBottom(5)
    pText:RequestFocus()
    pText:SelectAllText(true)
  end
  pBase:CenterHorizontal()
  pBase:AlignBottom(8)
  pFrame:MakePopup()
  pFrame:DoModal()
  return pFrame
end

--[[
 * Normalizes a path to the gmod file system
 * sOrg > The path to be checked and converted
 * fP   > Flag if the `sP` is relative to the data folder
 * sP   > Converted path for accessing the data folder
 * oP   > Original converted path relative to the game folder
]]
function luapad.GetPath(sOrg)
  local fP, sP, oP
  local tP = PATPATH_CONVERT
  local sD = ("data/" .. GLOB_CONFIG.FOLDER)
  local sB = tostring(sOrg or sD)
        sB = ((sB == "") and sD or sB)
  -- Copy of the path origin and convert it
  for iP = 1, #tP do
    sB = string.gsub(sB, unpack(tP[iP]))
  end
  -- Check if we are in the data/ folder and remove
  fP, sP, oP = false, sB, sB
  -- The path is relative to the data folder
  if(string.find(sB, tP.Sors[1]) == 1) then
    fP, sP = true, string.gsub(sB, unpack(tP.Sors))
  end
  -- Return the normalized path and flag
  return fP, sP.."/", oP.."/"
end

function luapad.CheckGlobal(func, last)
  if (luapad._sG[func] ~= nil) then
    local sN = FMSYNTAX_HILIGHT.N
    if (luapad.debugmode) then
      print(GLOB_CONFIG.SRCHFM:format(func, sN))
    end
    return luapad._sG[func]
  end
  if(last and istable(last)) then
    local tL, sN = last.Src, last.Nam
    if(tL and istable(tL) and tL[func]) then
      if (luapad.debugmode) then
        print(GLOB_CONFIG.SRCHFM:format(func, tostring(sN or "_LAST_")))
      end
      return tL[func]
    end
  end
  if (_G[func] ~= nil) then
    if (luapad.debugmode) then
      print(GLOB_CONFIG.SRCHFM:format(func, "_G"))
    end
    return _G[func]
  end
  return false
end

function luapad.Clear()
  if(SERVER) then return end
  if(IsValid(luapad.Frame)) then
    luapad.Frame:Remove()
  end
end

function luapad.EqualizeThemeTab(vTre)
  if(SERVER) then return end
  local bSe = input.IsKeyDown(KEY_LSHIFT)
  local bSr = input.IsKeyDown(KEY_RSHIFT)
  if(not (bSe or bSr)) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT, pT = pS:GetTabIndex(vTre)
  if(not iT) then return end
  if(not IsValid(pT)) then return end
  local tI = pS:GetItems()
  local pA = pT:GetTextArea()
  local tK = pA:GetThemeKeys()
  for iD = 1, #tI do
    if(iD ~= iT) then -- Our tab is updated
      local tP = tI[iD] -- Index the tab
      local cT = tP.Tab -- Refer the panel
      if(IsValid(cT)) then -- Apply theme
        local cA = cT:GetTextArea()
        cA:SetThemeArea(pA)
      end
    end
  end
end

function luapad.SaveTabs()
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local tO, tW = {"", "", "", ""}, {}
  local tI = pS:GetItems()
  local aT = pS:GetActiveTab()
  for iD = 1, #tI do
    local tP = tI[iD]
    local pT = tP.Tab
    if(IsValid(pT)) then
      local tS = pT:GetStreamInfo()
      tO[1] = tS.Name         -- File name
      tO[2] = tS.Path         -- Path in game FS
      tO[3] = (tS.Term or "") -- Custom tab name
      tO[4] = tS.Icon         -- Custom tab icon
      tO[5] = (tS.Teme or "") -- Custom tab palette
      if(pT == aT) then tO[1] = "*" .. tO[1] end
      table.insert(tW, table.concat(tO, GLOB_CONFIG.DELIMS))
    end
  end
  file.Write(GLOB_CONFIG.FOLDER.."saved_tabs.txt", table.concat(tW, "\n"))
end

function luapad.LoadTabs()
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  pS:Clear() -- The * symbol is invalid for a file name
  -- Read the saved tabs file and load the related files
  local sF = file.Read(GLOB_CONFIG.FOLDER.."saved_tabs.txt", "DATA")
  if(not sF) then return end -- File not found then bail out
  local tW, aT = GLOB_CONFIG.PATNLN:Explode(sF, true), nil
  for iD = 1, #tW do -- Basically we have one tab on one line
    local tO = GLOB_CONFIG.DELIMS:Explode(tW[iD]) -- Empty lines are excluded
    local bA = (string.sub(tO[1], 1, 1) == "*") -- File name starts with * when active
    if(bA) then tO[1] = string.sub(tO[1], 2, -1) end
    local bB, sB, oB, pT = luapad.GetPath(tO[2])
    if(tO[1] ~= "" and tO[2] ~= "") then -- No name to identify the file
      if(bB) then -- Load a tab relative to the data folder
        pT = luapad.AddTab(tO[1], file.Read(sB..tO[1], "DATA"), oB, tO[3], tO[4], tO[5])
      else -- Load a tab relative to the game folder
        pT = luapad.AddTab(tO[1], file.Read(oB..tO[1], "GAME"), oB, tO[3], tO[4], tO[5])
      end -- Store the last tab found as active tab reference
      aT = ((bA and IsValid(pT)) and pT or aT)
    end
  end
  -- If a tab is marked as active set the last one marked
  if(aT and IsValid(aT)) then pS:SetActiveTab(aT) end
end

function luapad.Toggle()
  if(SERVER or not canUserAccess(LocalPlayer())) then return end
  if (IsValid(luapad.Frame) and not luapad.debugmode) then
    luapad.Frame:SetVisible(not luapad.Frame:IsVisible())
    return
  end
  -- Build it, if it doesn't exist
  local nW, nH = ScrW(), ScrH()
  luapad.Frame = vgui.Create("DFrame")
  local mB = GLOB_CONFIG.PANLSZ
  local mR = (1 - mB) / 2
  local sW, sH = mB * nW, mB * nH
  local pW, pH = mR * nW, mR * nH
  luapad.Frame:SetSize(sW, sH)
  luapad.Frame:SetPos(pW, pH)
  luapad.Frame:SetTitle(GLOB_CONFIG.ADDONN)
  luapad.Frame:SetVisible(true)
  luapad.Frame:ShowCloseButton(true)
  luapad.Frame:SetIcon(luapad.ToIcon("application_osx_terminal"))
  if(luapad.debugmode) then
    luapad.Frame:SetDeleteOnClose(true)
  else
    luapad.Frame:SetDeleteOnClose(false)
    function luapad.Frame:OnClose()
      self:SetVisible(true)
      luapad.Toggle()
      luapad.SaveTabs()
    end -- Thanks Microosoft -SparkZ
  end
  luapad.Frame:MakePopup()
  luapad.Toolbar = vgui.Create("DIconLayout", luapad.Frame)
  luapad.Toolbar:SetPos(5, 30)
  luapad.Toolbar:SetSize(luapad.Frame:GetWide() - 6, 25)
  luapad.Toolbar:GetSpaceX(5)
  luapad.Toolbar:SetSpaceY(5)
  luapad.Toolbar:SetLayoutDir(LEFT)
  luapad.Toolbar:DockPadding(2,2,2,2)
  luapad.Toolbar:Dock(TOP)
  luapad.Toolbar:SetStretchWidth(true)
  luapad.Toolbar:SetStretchHeight(false)
  local nX, nY = luapad.Toolbar:GetPos()
  local nW, nH = luapad.Toolbar:GetSize()
  local oW, oH = luapad.Frame:GetSize()
  luapad.PropertySheet = vgui.Create("DPropertySheet", luapad.Frame)
  luapad.PropertySheet:SetPos(5, nY + nH + 15)
  luapad.PropertySheet:SetSize(oW - 6, oH - 80)
  luapad.PropertySheet:SetPadding(2)
  luapad.PropertySheet:SetFadeTime(0)
  luapad.PropertySheet:DockPadding(2,2,2,2)
  luapad.PropertySheet:Dock(TOP)
  function luapad.PropertySheet:OnActiveTabChanged(pO, pN)
    local sN = GLOB_CONFIG.ADDONN
    if(IsValid(pN)) then
      local tS = pN:GetStreamInfo()
      local sA = GLOB_CONFIG.FFDRPT:format(tS.Path, tS.Name)
      luapad.Frame:SetTitle(sN .. " - " .. sA)
    elseif(IsValid(pO)) then
      local tS = pO:GetStreamInfo()
      local sA = GLOB_CONFIG.FFDRPT:format(tS.Path, tS.Name)
      luapad.Frame:SetTitle(sN .. " - " .. sA)
    else
      local pA = self:GetTabSwitch()
      if(not IsValid(pA)) then return end
      local tS = pA:GetStreamInfo()
      local sA = GLOB_CONFIG.FFDRPT:format(tS.Path, tS.Name)
      luapad.Frame:SetTitle(sN .. " - " .. sA)
    end
  end
  function luapad.PropertySheet:GetTabIndex(vTre, iOrg, bNop)
    if(IsValid(vTre)) then -- Valid panel
      local tI = self:GetItems()
      local iS = math.max((tonumber(iOrg) or 1), 1)
      local iE = #tI; if(iE == 0) then return nil end
      for iT = iS, iE do -- Try to match reference
        local tP = tI[iT] -- Try to index the item
        local vT = tP.Tab -- Try to index the tab
        local bT = IsValid(vT) -- Validate tab entry
        if(bT and vT == vTre) then return iT, vT end
      end; return nil -- Tab is not found in items
    elseif(isnumber(vTre)) then -- Tab index
      local iT = math.floor(vTre)
      if(iT <= 0) then return nil end
      local tI = self:GetItems() -- Read items
      local tP = tI[iT] -- Try to index the item
      if(not tP) then return nil end
      local vT = tP.Tab -- Try to index the tab
      if(not IsValid(vT)) then return nil end
      return iT, vT -- Return tab and index
    elseif(isstring(vTre)) then -- Tab index
      if(vTre == "") then return end -- Empty string
      local tI = self:GetItems() -- Loop the tab items
      local iS = math.max((tonumber(iOrg) or 1), 1)
      local iE = #tI; if(iE == 0) then return nil end
      for iT = iS, iE do -- Try to match some info string
        local tP = tI[iT] -- Try to index the item
        local vT = tP.Tab -- Try to index the tab
        if(IsValid(vT)) then -- Only check valid tabs
          local tS = vT:GetStreamInfo() -- Read stream info
          local sO = tS.Path .. tS.Name -- Generate file origin
          local sN, sT = tS.Name, tS.Term -- Extract term and name
          if(sT and sT:find(vTre, 1, bNop)) then return iT, vT end
          if(sO and sO:find(vTre, 1, bNop)) then return iT, vT end
          if(sN and sN:find(vTre, 1, bNop)) then return iT, vT end
        end -- This tab did not match the provided string
      end; return nil -- Tab is not found in items
    else return nil end
  end
  function luapad.PropertySheet:GetTabSwitch(vTre, ...)
    if(isHere(vTre)) then -- There is an argument
      local iT, pT = self:GetTabIndex(vTre, ...)
      if(not iT) then return nil end
      return pT -- The argument is validated
    else
      local pT = self:GetActiveTab()
      if(not IsValid(pT)) then return nil end
      return pT -- No argument use active
    end
  end
  local oW, oH = luapad.Frame:GetSize()
  luapad.Statusbar = vgui.Create("DIconLayout", luapad.Frame)
  luapad.Statusbar:SetPos(3, oH - 22)
  luapad.Statusbar:SetSize(oW - 6, 22)
  luapad.Statusbar:GetSpaceX(1)
  luapad.Statusbar:SetSpaceY(1)
  luapad.Statusbar:SetLayoutDir(LEFT)
  luapad.Statusbar:SetStretchWidth(true)
  luapad.Statusbar:SetStretchHeight(false)
  luapad.Statusbar.PerformLayout = luapad.Toolbar.PerformLayout
  luapad.Statusbar:DockMargin(5,5,5,5)
  luapad.Statusbar:DockPadding(2,2,2,2)
  luapad.Statusbar:Dock(TOP)
  luapad.Statusbar:InvalidateLayout(true)
  luapad.AddToolbarItem("New (CTRL + N) / Active tab origin", "page_add"   , luapad.NewTab    , luapad.NewTabActive)
  luapad.AddToolbarItem("Open (CTRL + O) / Open file menu"  , "folder_page", luapad.OpenTab   , luapad.OpenBrowseMenu)
  luapad.AddToolbarItem("Save (CTRL + S) / Save all tabs"   , "disk"       , luapad.SaveScript, luapad.SaveAll)
  luapad.AddToolbarItem("Save As (CTRL + ALT + S)"          , "page_save"  , luapad.SaveAsScript)
  luapad.AddToolbarSpacer()
  luapad.AddToolbarItem("Execute / Execute menu", "script_lightning", luapad.RunScriptClient , luapad.OpenExecuteMenu)
  luapad.AddToolbarItem("Refresh / Refresh menu", "page_refresh"    , luapad.RefreshTabActive, luapad.OpenRefreshMenu)
  luapad.AddToolbarItem("Close / Close menu"    , "page_delete"     , luapad.CloseTabActive  , luapad.OpenCloseMenu)
  luapad.AddToolbarSpacer()
  luapad.AddToolbarItem("Change font / Font menu", "style", luapad.SetFontEntry, luapad.OpenFontMenu)
  luapad.AddToolbarItem("Apply theme / Theme menu", "images", luapad.SetThemeEntry, luapad.OpenThemeMenu)
  luapad.AddToolbarItem("Load tabs / Save tabs"   , "briefcase" , luapad.LoadTabs, luapad.SaveTabs)
  if (file.Exists(GLOB_CONFIG.FOLDER.."saved_tabs.txt", "DATA")) then
    luapad.LoadTabs()
  elseif (file.Exists(GLOB_CONFIG.FOLDER.."welcome.txt", "DATA")) then
    luapad.AddTab("welcome.txt", file.Read(GLOB_CONFIG.FOLDER.."welcome.txt", "DATA"), "data/"..GLOB_CONFIG.FOLDER)
  else
    luapad.NewTab()
  end
  luapad.PropertySheet:InvalidateLayout(true)
  luapad.Toolbar:InvalidateLayout(true)
end

--[[
 * This can add a custom item to the toolbar that adds custom behavior
 * vTip      > Tooltip used for help text
 * sIco      > Image icon to be displayed with
 * act(LRMD) > Action functions done by the user mouse
]]
function luapad.AddToolbarItem(vTip, sIco, actL, actR, actM, actD)
  if(SERVER) then return end
  local pB = luapad.Toolbar
  if(not IsValid(pB)) then return end
  local pBut, nS = pB:Add("DImageButton"), 22
  if(not IsValid(pBut)) then return end
  -- Configure image and help text
  pBut:SetImage(luapad.ToIcon(sIco or "lightning"))
  if(isHere(vTip)) then pBut:SetTooltip(tostring(vTip)) end
  pBut:SetSize(nS, nS) -- Make the button a square image that runs functions
  -- Do not pass the button reference here unless the button must be changed
  if(actL) then
    function pBut:DoClick()
      local bS, sE = pcall(actL); if(not bS) then
        luapad.SetStatus("LeftClick [%s] error: %s", "STAT_ER", pBut:GetTooltip(), sE) end
    end
  end
  if(actR) then
    function pBut:DoRightClick()
      local bS, sE = pcall(actR); if(not bS) then
        luapad.SetStatus("RightClick [%s] error: %s", "STAT_ER", pBut:GetTooltip(), sE) end
    end
  end
  if(actM) then
    function pBut:DoMiddleClick()
      local bS, sE = pcall(actM); if(not bS) then
        luapad.SetStatus("MiddleClick [%s] error: %s", "STAT_ER", pBut:GetTooltip(), sE) end
    end
  end
  if(actD) then
    function pBut:DoDoubleClick()
      local bS, sE = pcall(actD); if(not bS) then
        luapad.SetStatus("DoubleClick [%s] error: %s", "STAT_ER", pBut:GetTooltip(), sE) end
    end
  end
  return pBut
end

function luapad.AddToolbarSpacer()
  if(SERVER) then return end
  local pLab = luapad.Toolbar:Add("DLabel")
  if(not IsValid(pLab)) then return end
  pLab:SetText(" "..GLOB_CONFIG.DELIMS.." ")
  pLab:SizeToContents()
  return pLab
end

--[[
 * Closes a tab via term, name or full path
 * Closes only one tab if matched
]]
function luapad.CloseTabName(name, nopat)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  -- Check the property sheet tab
  local tI = pS:GetItems()
  local nI = #tI
  if(nI == 0) then -- Is there anything to close
    return -- There is nothing to close currently
  else -- At least one tab is available check its info
    local sT = tostring(name or "")
    local iT, pT = pS:GetTabIndex(sT, 1, nopat)
    if(not iT) then return end -- No such tab do nothing
    if(nI > 1) then pS:CloseTab(pT, true) else pS:Clear() end
    pS:InvalidateLayout()
  end
end

--[[
 * Closes the tab by view panel reference
 * vTre > The tab reference that must be closed
]]
function luapad.CloseTabView(vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT, pT = pS:GetTabIndex(vTre)
  if(not iT) then return end
  -- Avoid triggering active tab close
  local aT = pS:GetActiveTab()
  if(aT == pT) then
    luapad.CloseTabActive()
    return
  end
  local tI = pS:GetItems()
  if(#tI == 1) then
    pS:Clear()
  else
    pS:CloseTab(pT, true)
  end
  pS:InvalidateLayout()
end

--[[
 * Closes all tabs to the left
 * No tabs are found the index is empty
 * vTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.CloseTabLeft(vTre, bInc)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(vTre)
  if(not iT) then return end
  if(not bInc) then iT = iT - 1 end
  local tI = pS:GetItems()
  if(iT <= 0) then return end
  -- Calculated closed tabs count
  local cT, nT = tI[1].Tab, iT
  -- Close all to the left including last
  if(iT == #tI) then pS:Clear(); return end
  pS:SetActiveTab(tI[iT + 1].Tab)
  -- Clear all inactive tabs
  while(tI[1] and IsValid(cT)) do
    -- Remove a tab and register it
    pS:CloseTab(cT, true); nT = nT - 1
    if(nT <= 0) then break end
    cT = tI[1].Tab
  end
end

--[[
 * Closes all tabs to the right
 * No tabs are found the index is empty
 * vTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.CloseTabRight(vTre, bInc)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(vTre)
  if(not iT) then return end
  if(not bInc) then iT = iT + 1 end
  local tI = pS:GetItems()
  if(iT > #tI) then return end
  -- Calculated closed tabs count
  local nT = (#tI - iT + 1)
  -- Close all to the right including 1-st
  if(iT == 1) then pS:Clear(); return end
  pS:SetActiveTab(tI[iT - 1].Tab)
  -- Clear all inactive tabs
  local cT = tI[iT].Tab
  while(tI[iT] and IsValid(cT) and nT > 0) do
    -- Remove a tab and register it
    pS:CloseTab(cT, true); nT = nT - 1
    if(nT <= 0) then break end
    cT = tI[iT].Tab
  end
end

--[[
 * Closes the active tab
]]
function luapad.CloseTabActive()
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local tI = pS:GetItems()
  local nT = #tI
  if(nT == 0) then
    return
  elseif(nT == 1) then
    pS:Clear()
  else
    local aT = pS:GetActiveTab()
    local iT = pS:GetTabIndex(aT)
    if(not IsValid(aT)) then return end
    if(not iT) then return end
    if(iT == 1) then
      pS:SetActiveTab(tI[2].Tab)
    else -- Avoid triggering active tab close
      pS:SetActiveTab(tI[iT - 1].Tab)
    end
    pS:CloseTab(aT, true)
    pS:InvalidateLayout()
  end
end

--[[
 * Closes Other tabs
 * vTre > The tab that must remain open
]]
function luapad.CloseTabOther(vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(vTre)
  if(not iT) then return end
  luapad.CloseTabLeft(vTre)
  luapad.CloseTabRight(vTre)
end

--[[
 * Closes all the tabs
]]
function luapad.CloseTabAll()
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  pS:Clear()
end

--[[
 * Adjusts the font size for the tabs
]]
local function luapadAttachFontMenu(pMenu, vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  if(not IsValid(pMenu)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  local pC = pT:GetTextArea()
  local iF, tF = pC:GetFontSize()
  pMenu:AddOption("Default", function()
    pC:SetFontName(iF)
  end):SetImage(luapad.ToIcon("shape_square_key"))
  -- Add font size options
  local pIn, pOp = pMenu:AddSubMenu("Sizes")
  if(not IsValid(pIn)) then return end
  pOp:SetIcon(luapad.ToIcon("text_uppercase"))
  for iS = 1, #tF do -- List all available sizes
    local sI = (iS ~= iF) and "shape_square" or "shape_square_go"
    pIn:AddOption(tostring(sS), -- Current size will have an arrow
      function() pC:SetFontName(iS) end):SetImage(luapad.ToIcon(sI))
  end
end

--[[
 * Attaches a theme files list to a menu
]]
local function luapadAttachThemeMenu(pMenu, vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  if(not IsValid(pMenu)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  local tT = GLOB_CONFIG.THMDEF
  pMenu:AddOption("Export", function()
    luapad.ShowConfirmDialog(
      "You are about to save a theme under ["..tT[1].."], please enter the desired name.",
      tT[2],
      function(sName)
        -- Configure parameters
        local tV = GLOB_CONFIG.VALDFS
        local sN = string.GetFileFromFilename(sName)
        -- Perform parameter check
        if(not isHere(sN)) then
          luapad.SetStatus("File name is missing! (provide a non-zero string)", "STAT_ER", sN)
          return
        end
        if(sN:match(tV[1])) then
          luapad.SetStatus("File name [%s] contains invalid characters!", "STAT_ER", sN)
          return
        end
        if(not luapad.IsPath(sN)) then
          luapad.SetStatus("File name [%s] is a reserved entry device!", "STAT_ER", sN)
          return
        end
        -- Everything is valid so write the theme
        luapad.SaveThemeFile(pT, sN)
      end, nil, "Save", "Cancel"
    )
  end):SetImage(luapad.ToIcon("picture_save"))
  -- Attach default theme control options
  local pIn, pOp = pMenu:AddSubMenu("Default")
  if(not IsValid(pIn)) then return end
  pOp:SetIcon(luapad.ToIcon("report_picture"))
  pIn:AddOption("Light",
    function() local sT = "XX"
      pT:GetTextArea():SetThemeDefault(false, false)
      luapad.EqualizeThemeTab(pT)
      pT:GetStreamInfo().Teme = sT
      RunConsoleCommand(VAR_THM:GetName(), sT)
    end):SetImage(luapad.ToIcon("picture"))
  pIn:AddOption("Dark",
    function() local sT = "VX"
      pT:GetTextArea():SetThemeDefault(true, false)
      luapad.EqualizeThemeTab(pT)
      pT:GetStreamInfo().Teme = sT
      RunConsoleCommand(VAR_THM:GetName(), sT)
    end):SetImage(luapad.ToIcon("picture"))
  pIn:AddOption("Light bold",
    function() local sT = "XV"
      pT:GetTextArea():SetThemeDefault(false, true)
      luapad.EqualizeThemeTab(pT)
      pT:GetStreamInfo().Teme = sT
      RunConsoleCommand(VAR_THM:GetName(), sT)
    end):SetImage(luapad.ToIcon("photo"))
  pIn:AddOption("Dark bold",
    function() local sT = "VV"
      pT:GetTextArea():SetThemeDefault(true, true)
      luapad.EqualizeThemeTab(pT)
      pT:GetStreamInfo().Teme = sT
      RunConsoleCommand(VAR_THM:GetName(), sT)
    end):SetImage(luapad.ToIcon("photo"))
  -- Update the theme via a skin
  local pIn, pOp = pMenu:AddSubMenu("Skin")
  if(not IsValid(pIn)) then return end
  pOp:SetIcon(luapad.ToIcon("picture_key"))
  local tS = derma.GetSkinTable()
  for sS, vS in pairs(tS) do
    pIn:AddOption(tostring(sS),
      function() local sT = "#"..sS
        luapad.SetThemeSkin(pT, vS, sS)
        luapad.EqualizeThemeTab(pT)
        pT:GetStreamInfo().Teme = sT
        RunConsoleCommand(VAR_THM:GetName(), sT)
      end):SetImage(luapad.ToIcon("palette"))
  end
  -- Update the theme via a file luapad/theme/*.txt
  local tF = file.Find(GLOB_CONFIG.THMDEF[1].."*.txt", "DATA")
  if(not tF) then return end -- No files were added
  if(#tF == 0) then return end -- An empty file table
  local pIn, pOp = pMenu:AddSubMenu("File")
  pOp:SetIcon(luapad.ToIcon("picture_go"))
  if(not IsValid(pIn)) then return end
  for iF = 1, #tF do -- Loop and add al files to the menu
    local vF = tF[iF]:gsub("%..*$", "")
    if(isHere(vF)) then
      pIn:AddOption(vF,
        function() local sT = "@"..vF
          luapad.SetThemeFile(pT, vF)
          luapad.EqualizeThemeTab(pT)
          pT:GetStreamInfo().Teme = sT
          RunConsoleCommand(VAR_THM:GetName(), sT)
        end):SetImage(luapad.ToIcon("palette"))
    end
  end
end

--[[
 * Attaches a copy menu to context
 * Nothing will change the active tab
 * vTre > The tab index to copy
]]
local function luapadAttachCopyMenu(pMenu, vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  if(not IsValid(pMenu)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  pMenu:AddOption("Name", function()
    SetClipboardText(pT:GetStreamInfo().Name)
  end):SetImage(luapad.ToIcon("page_green"))
  pMenu:AddOption("Label", function()
    local tS = pT:GetStreamInfo()
    SetClipboardText(tS.Term or tS.Name)
  end):SetImage(luapad.ToIcon("tag_green"))
  pMenu:AddOption("Path", function()
    SetClipboardText(pT:GetStreamInfo().Path)
  end):SetImage(luapad.ToIcon("folder"))
  pMenu:AddOption("Full", function()
    local tS = pT:GetStreamInfo()
    SetClipboardText(tS.Path .. tS.Name)
  end):SetImage(luapad.ToIcon("folder_page"))
  pMenu:AddOption("Theme", function()
    SetClipboardText(pT:GetStreamInfo().Teme)
  end):SetImage(luapad.ToIcon("palette"))
  pMenu:AddOption("Index", function()
    local pS = pT:GetPropertySheet()
    local iT = pS:GetTabIndex(pT)
    SetClipboardText(tostring(iT or "N/A"))
  end):SetImage(luapad.ToIcon("key"))
end

--[[
 * Attaches a file menu to context
 * Nothing will change the active tab
 * vTre > The tab index to manipulate
]]
local function luapadAttachFileMenu(pMenu, vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  if(not IsValid(pMenu)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  pMenu:AddOption("New" , function()
    local tS = pT:GetStreamInfo()
    luapad.NewTab(nil, tS.Path)
  end):SetImage(luapad.ToIcon("page_add"))
  pMenu:AddOption("Open", function()
    local tS = pT:GetStreamInfo()
    luapad.OpenTab(tS.Path)
  end):SetImage(luapad.ToIcon("folder_page"))
  pMenu:AddOption("Save", function()
    luapad.SaveScript(pT)
  end):SetImage(luapad.ToIcon("disk"))
  pMenu:AddOption("Save As", function()
    luapad.SaveAsScript(pT)
  end):SetImage(luapad.ToIcon("page_save"))
  pMenu:AddOption("Delete", function()
    luapad.DeleteScript(pT)
  end):SetImage(luapad.ToIcon("page_delete"))
end

--[[
 * Attaches a refresh menu to context
 * Nothing will change the active tab
 * vTre > The tab index to refresh
]]
local function luapadAttachRefreshMenu(pMenu, vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  if(not IsValid(pMenu)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  pMenu:AddOption("Active", function()
    luapad.RefreshTabActive()
  end):SetImage(luapad.ToIcon("arrow_refresh"))
  pMenu:AddOption("Right", function()
    luapad.RefreshTabRight(pT)
  end):SetImage(luapad.ToIcon("arrow_right"))
  pMenu:AddOption("Left", function()
    luapad.RefreshTabLeft(pT)
  end):SetImage(luapad.ToIcon("arrow_left"))
  pMenu:AddOption("Right (+)", function()
    luapad.RefreshTabRight(pT, true)
  end):SetImage(luapad.ToIcon("arrow_turn_right"))
  pMenu:AddOption("Left (+)", function()
    luapad.RefreshTabLeft(pT, true)
  end):SetImage(luapad.ToIcon("arrow_turn_left"))
  pMenu:AddOption("Others", function()
    luapad.RefreshTabOther(pT)
  end):SetImage(luapad.ToIcon("arrow_out"))
  pMenu:AddOption("All", function()
    luapad.RefreshTabAll()
  end):SetImage(luapad.ToIcon("arrow_in"))
end

--[[
 * Attaches run script menu to context
 * Nothing will change the active tab
 * vTre > The tab index to run
]]
local function luapadAttachExecuteMenu(pMenu, vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  if(not IsValid(pMenu)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  pMenu:AddOption("Client", function()
    luapad.RunScriptClient(pT)
  end):SetImage(luapad.ToIcon("user_go"))
  pMenu:AddOption("Server", function()
    luapad.RunScriptServer(pT)
  end):SetImage(luapad.ToIcon("server_go"))
  pMenu:AddOption("Shared", function()
    luapad.RunScriptClient(pT)
    luapad.RunScriptServer(pT, true)
  end):SetImage(luapad.ToIcon("computer_go"))
  pMenu:AddOption("Broadcast", function()
    luapad.RunScriptBroadcast(pT)
  end):SetImage(luapad.ToIcon("feed_go"))
end

--[[
 * Attaches a close menu to context
 * vTre > The tab index to close
]]
local function luapadAttachCloseMenu(pMenu, vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  if(not IsValid(pMenu)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  pMenu:AddOption("This", function()
    luapad.CloseTabView(pT)
  end):SetImage(luapad.ToIcon("arrow_down"))
  pMenu:AddOption("Active", function()
    luapad.CloseTabActive()
  end):SetImage(luapad.ToIcon("arrow_refresh"))
  pMenu:AddOption("Right", function()
    luapad.CloseTabRight(pT)
  end):SetImage(luapad.ToIcon("arrow_right"))
  pMenu:AddOption("Left", function()
    luapad.CloseTabLeft(pT)
  end):SetImage(luapad.ToIcon("arrow_left"))
  pMenu:AddOption("Right (+)", function()
    luapad.CloseTabRight(pT, true)
  end):SetImage(luapad.ToIcon("arrow_turn_right"))
  pMenu:AddOption("Left (+)", function()
    luapad.CloseTabLeft(pT, true)
  end):SetImage(luapad.ToIcon("arrow_turn_left"))
  pMenu:AddOption("Others", function()
    luapad.CloseTabOther(pT)
  end):SetImage(luapad.ToIcon("arrow_out"))
  pMenu:AddOption("All", function()
    luapad.CloseTabAll()
  end):SetImage(luapad.ToIcon("arrow_in"))
end

--[[
 * Refreshes all the tabs on name
]]
function luapad.RefreshTabName(name, nopat)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  -- Check the property sheet tab
  local tI = pS:GetItems()
  local nI, nU = #tI, 0
  -- Is there anything to refresh
  if(nI == 0) then return end
  -- At least one tab is available check its info
  local sT = tostring(name or "")
  local iT, pT = pS:GetTabIndex(sT, 1, nopat)
  if(not iT) then return end -- No such tab do nothing
  while(iT and IsValid(pT)) do
    local tS = pT:GetStreamInfo()
    local sD, sN = tS.Path, tS.Name
    local bB, sB, oB = luapad.GetPath(sD)
    -- Check whenever the origin is the data folder
    if(bB) then -- Others are read only and skipped
      local sF = (sB .. sN)
      local sCon = file.Read(sF, "DATA")
      if(sCon) then
        nU = nU + 1; pT:SetContents(sCon)
      else
        luapad.SetStatus("File [%s%s] refresh failed! Processed [%s] of [%s] tabs!", "STAT_ER", oB, sN, nU, nI)
        return
      end -- Only the data file system can be refreshed
    end -- There is no point to refresh other file systems
    iT, pT = pS:GetTabIndex(sT, iT + 1, nopat)
  end
  -- In case the loop is executed
  if(nU <= 0) then -- All tabs are not from the data folder
    luapad.SetStatus("No tabs have been refreshed! (check the origin access rights)", "STAT_WR")
  else -- Not every tab may be from the data folder
    luapad.SetStatus("Refreshed successfully [%s] of [%s] tabs!", "STAT_OK", nU, nI)
  end
end

--[[
 * Refreshes a tab by a given index
 * vTre > The tab index to refresh
]]
function luapad.RefreshTabView(vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT, pT = pS:GetTabIndex(vTre)
  if(not iT) then return end
  -- Avoid triggering active tab close
  local aT = pS:GetActiveTab()
  if(aT == pT) then
    luapad.RefreshTabActive()
    return
  end
  local tS = pT:GetStreamInfo()
  local sD, sN = tS.Path, tS.Name
  local bB, sB, oB = luapad.GetPath(sD)
  if(bB) then
    local sF = (sB .. sN)
    local sCon = file.Read(sF, "DATA")
    if(sCon) then pT:SetContents(sCon)
      luapad.SetStatus("File [%s%s] refreshed!", "STAT_OK", oB, sN)
    else
      luapad.SetStatus("File [%s%s] not found!", "STAT_ER", oB, sN)
    end
  else
    luapad.SetStatus("File [%s%s] refresh not supported!", "STAT_WR", oB, sN)
  end
end

--[[
 * Refreshes all tabs to the left
 * No tabs are found the index is empty
 * vTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.RefreshTabLeft(vTre, bInc)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(vTre)
  if(not iT) then return end
  local tI = pS:GetItems()
  local nI, nU = #tI, 0
  if(nI <= 0) then return end
  local iE = (bInc and iT or (iT - 1))
  for iR = 1, iE do
    local cT = tI[iR].Tab
    if(IsValid(cT)) then
      local tS = cT:GetStreamInfo()
      local sD, sN = tS.Path , tS.Name
      local bB, sB, oB = luapad.GetPath(sD)
      if(bB) then
        local sF = (sB .. sN)
        local sCon = file.Read(sF, "DATA")
        if(sCon) then
          nU = nU + 1; cT:SetContents(sCon)
        else
          luapad.SetStatus("File [%s%s] refresh failed! Processed [%s] of [%s] tabs!", "STAT_ER", oB, sN, nU, nI)
          return
        end
      end
    end
  end
  -- In case the loop is executed
  if(nU <= 0) then -- All tabs are not from the data folder
    luapad.SetStatus("No tabs have been refreshed! (check the origin access rights)", "STAT_WR")
  else -- Not every tab may be from the data folder
    luapad.SetStatus("Refreshed successfully [%s] of [%s] tabs!", "STAT_OK", nU, nI)
  end
end

--[[
 * Refreshes all tabs to the right
 * No tabs are found the index is empty
 * vTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.RefreshTabRight(vTre, bInc)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(vTre)
  if(not iT) then return end
  local tI = pS:GetItems()
  local nI, nU = #tI, 0
  if(nI <= 0) then return end
  local iS = (bInc and iT or (iT + 1))
  for iR = iS, nI do
    local cT = tI[iR].Tab
    if(IsValid(cT)) then
      local tS = cT:GetStreamInfo()
      local sD, sN = tS.Path , tS.Name
      local bB, sB, oB = luapad.GetPath(sD)
      if(bB) then
        local sF = (sB .. sN)
        local sCon = file.Read(sF, "DATA")
        if(sCon) then
          nU = nU + 1; cT:SetContents(sCon)
        else
          luapad.SetStatus("File [%s%s] refresh failed! Processed [%s] of [%s] tabs!", "STAT_ER", oB, sN, nU, nI)
          return
        end
      end
    end
  end
  -- In case the loop is executed
  if(nU <= 0) then -- All tabs are not from the data folder
    luapad.SetStatus("No tabs have been refreshed! (check the origin access rights)", "STAT_WR")
  else -- Not every tab may be from the data folder
    luapad.SetStatus("Refreshed successfully [%s] of [%s] tabs!", "STAT_OK", nU, nI)
  end
end

--[[
 * Refreshes the active tab
]]
function luapad.RefreshTabActive()
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local aT = pS:GetActiveTab()
  if(not IsValid(aT)) then return end
  local tS = aT:GetStreamInfo()
  if(not tS) then return end
  local sD, sN = tS.Path, tS.Name
  local bB, sB, oB = luapad.GetPath(sD)
  if(bB) then
    local sF, sT = (sB .. sN), (aT:GetContents() or "")
    local sCon = file.Read(sF, "DATA")
    if(sCon) then aT:SetContents(sCon)
      luapad.SetStatus("File [%s%s] refreshed!", "STAT_OK", oB, sN)
    else
      luapad.SetStatus("File [%s%s] not found!", "STAT_ER", oB, sN)
    end
  else
    luapad.SetStatus("File [%s%s] refresh not supported!", "STAT_WR", oB, sN)
  end
end

--[[
 * Refreshes all tabs to the right
 * No tabs are found the index is empty
 * vTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.RefreshTabOther(vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(vTre)
  if(not iT) then return end
  local tI = pS:GetItems()
  local nI, nU = #tI, 0
  if(nI <= 0) then return end
  for iR = 1, nI do
    local cT = tI[iR].Tab
    if(iR ~= iT and IsValid(cT)) then
      local tS = cT:GetStreamInfo()
      local sD, sN = tS.Path , tS.Name
      local bB, sB, oB = luapad.GetPath(sD)
      if(bB) then
        local sF = (sB .. sN)
        local sCon = file.Read(sF, "DATA")
        if(sCon) then
          nU = nU + 1; cT:SetContents(sCon)
        else
          luapad.SetStatus("File [%s%s] refresh failed! Processed [%s] of [%s] tabs!", "STAT_ER", oB, sN, nU, nI)
          return
        end
      end
    end
  end
  -- In case the loop is executed
  if(nU <= 0) then -- All tabs are not from the data folder
    luapad.SetStatus("No tabs have been refreshed! (check the origin access rights)", "STAT_WR")
  else -- Not every tab may be from the data folder
    luapad.SetStatus("Refreshed successfully [%s] of [%s] tabs!", "STAT_OK", nU, nI)
  end
end

function luapad.RefreshTabAll()
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local tI = pS:GetItems()
  local nI, nU = #tI, 0
  if(nI <= 0) then return end
  for iR = 1, nI do
    local cT = tI[iR].Tab
    if(IsValid(cT)) then
      local tS = cT:GetStreamInfo()
      local sD, sN = tS.Path, tS.Name
      local bB, sB, oB = luapad.GetPath(sD)
      if(bB) then
        local sF = (sB .. sN)
        local sCon = file.Read(sF, "DATA")
        if(sCon) then
          nU = nU + 1; cT:SetContents(sCon)
        else
          luapad.SetStatus("File [%s%s] refresh failed! Processed [%s] of [%s] tabs!", "STAT_ER", oB, sN, nU, nI)
          return
        end
      end
    end
  end
  -- In case the loop is executed
  if(nU <= 0) then -- All tabs are not from the data folder
    luapad.SetStatus("No tabs have been refreshed! (check the origin access rights)", "STAT_WR")
  else -- Not every tab may be from the data folder
    luapad.SetStatus("Refreshed successfully [%s] of [%s] tabs!", "STAT_OK", nU, nI)
  end
end

--[[
 * Adds a tab to the property sheet files
 * name > The file name used used for streaming
 * cont > Text panel contents manipulated
 * path > The file path. Relative to the game folder
 * term > Tab custom title instead of the file name
 * icon > The icon being displayed on the tab node
 * them > The theme being used for this specific tab
]]
function luapad.AddTab(name, cont, path, term, icon, teme)
  if(SERVER) then return end
  local sPth = tostring(path or "")
  local sNam = tostring(name or "")
  local sCon = tostring(cont or "")
  local sIco = tostring(icon or "page_white")
  local sTag = (isHere(term) and tostring(term) or nil)
  local sTem = (isHere(teme) and tostring(teme) or VAR_THM:GetString())
  local pSheet = luapad.PropertySheet
  if(not IsValid(pSheet)) then return end
  local pPan = vgui.Create("DPanel", pSheet)
  if(not IsValid(pPan)) then return end
  local nW, nH = pSheet:GetSize()
  pPan:SetSize(nW, nH - 22)
  pPan:Dock(FILL)
  local nW, nH = pPan:GetSize()
  local pText = vgui.Create("LuapadEditor", pPan)
  if(not IsValid(pText)) then return end
  pText:SetSize(nW, nH)
  pText:SetText(sCon)
  pText:Dock(FILL)
  pText:RequestFocus()
  pText:SizeToContents()
  local tInfo = pSheet:AddSheet(tostring(sTag or sNam), pPan, luapad.ToIcon(sIco), false, false)
  local pTab  = tInfo.Tab; pTab[GLOB_CONFIG.STORKY] = {}
  local tSor  = pTab[GLOB_CONFIG.STORKY]
  tSor.Name = sNam -- The actual file name associated with the tab
  tSor.Path = sPth -- File path always relative to the game folder
  tSor.Term = sTag -- Tab term in case provided is displayed instead of name
  tSor.Icon = sIco -- Custom tab icon usually defined by the file extension
  tSor.Teme = sTem -- The theme being used for the tab text area
  pTab:SetTooltip(sPth .. sNam)
  local sI = sTem:sub(1, 1)
  if(sI == "#") then
    local sT = string.sub(sTem, 2, -1)
    local tS = derma.GetNamedSkin(sT)
    if(istable(tS)) then
      luapad.SetThemeSkin(pTab, tS, sT)
    else
      pText:SetThemeDefault()
      luapad.SetStatus("Theme from skin [%s] is unavailable! (apply default theme)", "STAT_WR", sT)
    end
  elseif(sI == "@") then
    local sT = string.sub(sTem, 2, -1)
    luapad.SetThemeFile(pTab, sT)
  else
    local tI = GLOB_CONFIG.DELIMS:Explode(sTem)
    tI[1], tI[2], tI[3] = getString(tI[1], tI[2], tI[3])
    pText:SetThemeDefault(tobool(tI[2]), tobool(tI[3]))
    sTem = table.concat(tI, GLOB_CONFIG.DELIMS)
  end
  --[[
   * Retrieves the storage info from the tab
  ]]
  function pTab:GetStreamInfo()
    return self[GLOB_CONFIG.STORKY]
  end
  --[[
   * Retrieves the editor text area panel
  ]]
  function pTab:GetTextArea()
    return self:GetPanel():GetChildren()[1]
  end
  --[[
   * Retrieves the text from this tab
  ]]
  function pTab:GetContents()
    local pText = self:GetTextArea()
    if(not IsValid(pText)) then return "" end
    return pText:GetText()
  end
  --[[
   * Retrieves the text from this tab
  ]]
  function pTab:SetContents(sCon)
    local pText = self:GetTextArea()
    if(not IsValid(pText)) then return end
    local sCon = tostring(sCon or "")
    pText:SetText(sCon)
    pText:RequestFocus()
    pText:SizeToContents()
  end
  --[[
   * Makes this tab the active one
  ]]
  function pTab:DoClick()
    self:GetPropertySheet():SetActiveTab(self)
  end
  --[[
   * Close the tab middle-clicked
  ]]
  function pTab:DoMiddleClick()
    local pS = self:GetPropertySheet()
    local tI = pS:GetItems()
    if(#tI == 1) then pS:Clear() else
      pS:CloseTab(self, true)
    end
  end
  --[[
   * Open a new tab
  ]]
  function pTab:DoDoubleClick()
    local tS = self:GetStreamInfo()
    local bB, sB, oB = luapad.GetPath(tS.Path)
    if(bB) then
      luapad.NewTab(nil, oB)
    else
      luapad.NewTab()
    end
  end
  --[[
   * Show some tab options
  ]]
  function pTab:DoRightClick()
    local pMenu = DermaMenu()
    if(not IsValid(pMenu)) then return end
    pMenu:SetPos(gui.MousePos())
    -- Copy tab internals
    local pIn, pOp = pMenu:AddSubMenu("Copy")
    pOp:SetIcon(luapad.ToIcon("table_multiple"))
    luapadAttachCopyMenu(pIn, self)
    -- File operations
    local pIn, pOp = pMenu:AddSubMenu("File")
    pOp:SetIcon(luapad.ToIcon("table_lightning"))
    luapadAttachFileMenu(pIn, self)
    -- Change tab theme
    local pIn, pOp = pMenu:AddSubMenu("Theme")
    pOp:SetIcon(luapad.ToIcon("folder_palette"))
    luapadAttachThemeMenu(pIn, self)
    -- Refresh a tab
    local pIn, pOp = pMenu:AddSubMenu("Refresh")
    pOp:SetIcon(luapad.ToIcon("table_refresh"))
    luapadAttachRefreshMenu(pIn, self)
    -- Execute a script
    local pIn, pOp = pMenu:AddSubMenu("Execute")
    pOp:SetIcon(luapad.ToIcon("table_go"))
    luapadAttachExecuteMenu(pIn, self)
    -- Close tabs
    local pIn, pOp = pMenu:AddSubMenu("Close")
    pOp:SetIcon(luapad.ToIcon("table_delete"))
    luapadAttachCloseMenu(pIn, self)
    -- Open menu
    pMenu:Open()
  end
  pSheet:SetActiveTab(pTab)
  pSheet:InvalidateLayout()
  return pTab
end

function luapad.OpenExecuteMenu()
  local pMenu = DermaMenu()
  if(not IsValid(pMenu)) then return end
  pMenu:SetPos(gui.MousePos())
  luapadAttachExecuteMenu(pMenu)
  pMenu:Open()
end

function luapad.OpenRefreshMenu()
  local pMenu = DermaMenu()
  if(not IsValid(pMenu)) then return end
  pMenu:SetPos(gui.MousePos())
  luapadAttachRefreshMenu(pMenu)
  pMenu:Open()
end

function luapad.OpenCloseMenu()
  local pMenu = DermaMenu()
  if(not IsValid(pMenu)) then return end
  pMenu:SetPos(gui.MousePos())
  luapadAttachCloseMenu(pMenu)
  pMenu:Open()
end

function luapad.SetFontEntry(vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  pT:GetTextArea():SetFontName()
end

function luapad.OpenFontMenu(vTre)
  local pMenu = DermaMenu()
  if(not IsValid(pMenu)) then return end
  pMenu:SetPos(gui.MousePos())
  luapadAttachFontMenu(pMenu, vTre)
  pMenu:Open()
end

--[[
 * Apply a theme on a tab via the console variable
]]
function luapad.SetThemeEntry(vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  local sV = VAR_THM:GetString()
  local sI = sV:sub(1,1)
  if(sI == "#") then
    local sT = string.sub(sV, 2, -1)
    local tD = derma.GetNamedSkin(sT)
    if(not istable(tD)) then return end
    luapad.SetThemeSkin(sT, tD, sT)
    pT:GetStreamInfo().Teme = sV
  elseif(sI == "@") then
    local sT = string.sub(sV, 2, -1)
    luapad.SetThemeFile(pT, sT)
    pT:GetStreamInfo().Teme = sV
  else
    local bD = (sV:sub(1, 1) == "V")
    local bB = (sV:sub(2, 2) == "V")
    pT:GetTextArea():SetThemeDefault(bD, bB)
    pT:GetStreamInfo().Teme = sV
  end
  luapad.EqualizeThemeTab(pT)
end

--[[
 * Opens the theme selection context menu
]]
function luapad.OpenThemeMenu(vTre)
  local pMenu = DermaMenu()
  if(not IsValid(pMenu)) then return end
  pMenu:SetPos(gui.MousePos())
  luapadAttachThemeMenu(pMenu, vTre)
  pMenu:Open()
end

--[[
 * Saves the current tab theme to a file
]]
function luapad.SaveThemeFile(vTre, sN)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  local tD = GLOB_CONFIG.THMDEF
  local tV = GLOB_CONFIG.VALDFS
  local sN, bN = tostring(sN or tD[2]), true
  if(not isHere(sN)) then
    luapad.SetStatus("File name is missing! (provide a non-zero string)", "STAT_ER", sN)
    return
  end
  if(not luapad.IsPath(sN)) then
    luapad.SetStatus("File name [%s] is a reserved entry device!", "STAT_ER", sN)
    return
  end
  if(sN:match(tV[1])) then
    luapad.SetStatus("File name [%s] contains invalid characters!", "STAT_ER", sN)
    return
  end
  local oB, sB, sF = "data/"..tD[1], tD[1], sN..".txt"
  if (table.HasValue(RESTRICTED_FILES, oB..sF)) then
    luapad.SetStatus("File [%s%s] save failed! (file is restricted)", "STAT_ER", oB, sF)
    return
  end
  -- If the theme directory is missing, create it
  if(not file.IsDir(sB, "DATA")) then file.CreateDir(tD[1]) end
  -- If the file already exists prompt to replace while validating user input
  if(file.Exists(sB..sF, "DATA")) then bN = false -- Name is not yet validate
    luapad.ShowConfirmDialog(
      "The theme already exists. Keep the same name to replace it or choose a different name.",
      sN, -- Fill the textbox with the current name
      function(sName)
        local sN = string.StripExtension(sName)
        if(not isHere(sN)) then
          luapad.SetStatus("File name is missing! (provide a non-zero string)", "STAT_ER")
          return
        end
        if(not luapad.IsPath(sN)) then
          luapad.SetStatus("File name [%s] is a reserved entry device!", "STAT_ER", sN)
          return
        end
        if(sN:match(tV[1])) then
          luapad.SetStatus("File name [%s] contains invalid characters!", "STAT_ER", sN)
          return
        end
        local sF = sN..".txt" -- New file name in the local scope
        if (table.HasValue(RESTRICTED_FILES, oB..sF)) then
          luapad.SetStatus("File [%s%s] save failed! (file is restricted)", "STAT_ER", oB, sF)
          return
        end
        bN = true -- The name has been validated
      end, nil, "Save", "Cancel"
    )
  end
  if(not bN) then return end
  -- Open the file so the theme can be extracted
  local fO = file.Open(sB..sF, "wb", "DATA")
  if(not fO) then -- The file open attempt has failed
    luapad.SetStatus("File [%s%s] open failed (check file status)!", "STAT_WR", oB, sF)
    return -- Exit the routine end report the status
  end
  local pA = pT:GetTextArea()
  if(not IsValid(pA)) then
    fO:Flush(); fO:Close()
    return -- Close the file and exit
  end
  local tK, tO = pA:GetThemeKeys(), {}
  local tH = pA:GetTable().Highlight
  local sD = GLOB_CONFIG.DELIMS
  for iK = 1, #tK do -- Highlight keys
    local sK = tK[iK] -- Process a key
    if(tH[sK]) then tO[1] = sK -- Exists
      local vC, bB = tH[sK][1], tH[sK][2]
      tO[2], tO[3], tO[4], tO[5] = vC:Unpack()
      tO[6] = (bB and "V" or "X") -- Bold
      fO:Write(table.concat(tO, sD)); fO:Write("\n")
    end
  end; fO:Flush(); fO:Close()
end

--[[
 * Apply a theme on a tab via a theme file
]]
function luapad.SetThemeFile(vTre, sN)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  local tD = GLOB_CONFIG.THMDEF
  local tV = GLOB_CONFIG.VALDFS
  local sN = tostring(sN or tD[2])
  if(not isHere(sN)) then
    luapad.SetStatus("File name is missing! (provide a non-zero string)", "STAT_ER", sN)
    return
  end
  if(sN:match(tV[1])) then
    luapad.SetStatus("File name [%s] contains invalid characters!", "STAT_ER", sN)
    return
  end
  local oB, sB, sF = "data/"..tD[1], tD[1], sN..".txt"
  if(not file.IsDir(sB, "DATA")) then file.CreateDir(tD[1]) end
  -- Open the file so the theme can be extracted
  local sF = file.Read(sB..sF, "rb", "DATA")
  if(not sF) then
    luapad.SetStatus("File [%s%s] highlight missing! (apply default theme)", "STAT_WR", oB, sF)
    return -- Exit the routine end report the status
  end
  local pA = pT:GetTextArea()
  if(not IsValid(pA)) then return end
  local tW = GLOB_CONFIG.PATNLN:Explode(sF, true)
  local tH = pA:GetTable().Highlight
  local sD = GLOB_CONFIG.DELIMS
  for iD = 1, #tW do -- Every line contains token and color
    local tT = sD:Explode(tW[iD]) -- Empty lines
    local sT = tT[1]:Trim() -- Color token to search for
    if(tH[sT]) then
      local nR = getColor(tT[2]:Trim(), 0)
      local nG = getColor(tT[3]:Trim(), 0)
      local nB = getColor(tT[4]:Trim(), 0)
      local nA = getColor(tT[5]:Trim(), 255)
      tH[sT][1] = Color(nR, nG, nB, nA)
      tH[sT][2] = (tT[6]:Trim():sub(1, 1) == "V")
    end
  end; pA:RefreshView()
end

--[[
 * Apply a theme on a tab via a derma skin
]]
function luapad.SetThemeSkin(vTre, tS, sS)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  local pA = pT:GetTextArea()
  if(not IsValid(pA)) then return end
  local tS = (tS or derma.GetDefaultSkin())
  if(not istable(tS)) then return end
  local tH = pA:GetTable().Highlight
  local sD = GLOB_CONFIG.DELIMS
  local tK = pA:GetThemeKeys()
  local tM = COLOR_HIGHLIGHT["#"]
  for iK = 1, #tK do
    local sK = tK[iK]
    local vM = tM[sK]
    if(vM and isstring(vM[1])) then
      local sP, bB = vM[1], tobool(tH[sK][2])
      local bO = (vM[2] ~= nil) and tobool(vM[2]) or bB
      local vP, tP = tS, sD:Explode(sP)
      for iP = 1, #tP do vP = vP[tP[iP]]
        if(not vP) then
          luapad.SetStatus("Theme skin [%s] path [%s] is missing!", "STAT_WR", sS, sP)
          return -- Somewhere along the way a color cannot be obtained
        end
      end
      if(not IsColor(vP)) then
        luapad.SetStatus("Theme skin [%s] path [%s] is invalid!", "STAT_WR", sS, sP)
        return -- Somewhere along the way a color cannot be obtained
      end
      tH[sK][1], tH[sK][2] = vP, bO
    end -- Update the string expression
  end; pA:RefreshView()
end

function luapad.IsOpen(name, path)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return false end
  local tI = pS:GetItems()
  local nI = #tI
  if(nI <= 0) then return false end
  local sPth = tostring(path or "")
  local sNam = tostring(name or "")
  if(sPth ~= "") then
    sNam = sPth .. sNam
  end
  for iD = 1, nI do
    local tP = tI[iD]
    local tS = tP.Tab:GetStreamInfo()
    local sF = tS.Path .. tS.Name
    local sN, sT = tS.Name, tS.Term
    if(sPth ~= "") then
      if(sF == sNam) then return true end
    else
      if(sN == sNam) then return true end
      if(sT == sNam) then return true end
    end
  end; return false
end

--[[
 * Adds a new tab to the property sheet files
 * New tabs must always be opened in the data folder
 * cont > Text panel contents manipulated
 * path > The file path relative to the game folder
]]
function luapad.NewTab(cont, path)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local bB, sB, oB = luapad.GetPath(path)
  if(bB) then
    local nF = VAR_MXF:GetInt()
    local sF = GLOB_CONFIG.FMNAME
    local sO = sB .. sF
    local tI, iF = pS:GetItems(), nil
    local sCon = tostring(cont or "")
    file.CreateDir(sB)
    for iD = 1, nF do
      local sT, sN = sO:format(iD), sF:format(iD)
      if (not file.Exists(sT, "DATA") and not luapad.IsOpen(sN)) then
        iF = iD
        break
      end
    end
    if(iF) then -- Index is present open the file
      luapad.AddTab(sF:format(iF), sCon, oB)
      luapad.SetStatus("Open the next name available!", "STAT_OK")
    else -- Rise a status bar message
      luapad.SetStatus("There are more than [%s] files in [%s] origin! (clean the folder)", "STAT_ER", nF, oB)
    end
  else
    luapad.SetStatus("Creating a file here [%s] is not allowed!", "STAT_WR", oB)
  end
end

--[[
 * Adds a new tab relative to the active tab path
]]
function luapad.NewTabActive()
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local aT = pS:GetActiveTab()
  if(not IsValid(aT)) then return end
  local tS = aT:GetStreamInfo()
  if(not (tS and tS.Path)) then return end
  luapad.NewTab(nil, tS.Path)
end

--[[
 * Every request is relative to the main game folder
 * Paths starting with `data/` use the `data` folder
 * This is done so that the file can be reloaded properly
 * Otherwise it will just read the game file system where
 * the content is refreshed during the game startup
]]
function luapad.OpenTree()
  if(SERVER) then return end
  local pSheet = luapad.PropertySheet
  if(not IsValid(pSheet)) then return end
  if (luapad.BrowserTree) then
    local pB = luapad.BrowserTree
    if(IsValid(pB)) then pB:Remove() end
    luapad.BrowserTree = nil
  end
  local nX, nY = pSheet:GetPos()
  local nW, nH = pSheet:GetSize()
  luapad.BrowserTree = vgui.Create("DTree", luapad.Frame)
  luapad.BrowserTree:SetPadding(5)
  luapad.BrowserTree:SetPos(nX + (nW - nW / 4), nY + 22)
  luapad.BrowserTree:SetSize(nW / 4, nH - 23)
  local nW, nH = luapad.BrowserTree:GetSize()
  local pClose = vgui.Create("DButton", luapad.BrowserTree)
  pClose:SetPos(nW - 65, 4)
  pClose:SetSize(45, 22)
  pClose:SetText(">")
  pClose:SetTooltip("Close")
  function pClose:DoClick()
    luapad.BrowserTree:Remove()
  end
  function luapad.BrowserTree:PopulateNode(pNode, sPath, tConf, iStag)
    local iStag = math.floor(tonumber(iStag) or 0)
    if(iStag <= 0) then return end
    -- Recursion guard has passed. Generate stage
    local tF, tD = file.Find(sPath .. "*", "GAME", "nameasc")
    if(not (tF or tD)) then return end
    -- Folders
    if(tD) then
      for iD = 1, #tD do
        local sD = tD[iD]
        local pC = pNode:AddNode(sD, luapad.ToIcon("folder"))
              pC.DirPath = sPath .. sD .. "/"
              pC:SetTooltip(pC.DirPath)
        -- Click a folder
        function pC:DoClick()
          local bEx = pC:GetExpanded()
          local bSe = input.IsKeyDown(KEY_LSHIFT)
          local bSr = input.IsKeyDown(KEY_RSHIFT)
          if(bSe or bSr) then
            pC:ExpandRecurse(not bEx)
          else
            pC:SetExpanded(not bEx)
          end
        end
        function pC:DoMiddleClick()
          local bEx = pC:GetExpanded()
          pC:ExpandRecurse(not bEx)
        end
        function pC:DoRightClick()
          SetClipboardText(pC.DirPath)
        end
        -- Expand the folder when clicked wherever
        pC.Expander.DoClick       = pC.DoClick
        pC.Expander.DoMiddleClick = pC.DoMiddleClick
        pC.Expander.DoRightClick  = pC.DoRightClick
        -- Use this as base and attach the rest
        self:PopulateNode(pC, pC.DirPath, tConf, iStag - 1)
      end
    end
    -- Files
    if(tF) then
      for iF = 1, #tF do
        local sF = tF[iF]
        local sE = string.GetExtensionFromFilename(sF)
        local tE = ENABLE_EXTENS[sE] -- Extension
        if(tE) then
          local sI = luapad.ToIcon(tE.Icon or "page")
          local pC = pNode:AddNode(sF, sI)
          pC.DirPath, pC.IsFile = sPath, true
          pC:SetTooltip(sF)
          -- Click a file
          function pC:DoClick()
            if(not self.IsFile) then return end
            local sD, sF = self.DirPath, self:GetText()
            if(luapad.IsOpen(sF, sD)) then return end
            local sE = string.GetExtensionFromFilename(sF)
            local tE = (sE and ENABLE_EXTENS[sE] or nil)
            local sI = (tE and tE.Icon or nil)
            local bB, sB = luapad.GetPath(sD)
            if(bB) then -- The contents in the data folder are refreshed on write
              luapad.AddTab(sF, file.Read(sB .. sF, "DATA"), sD, nil, sI)
            else -- Every other folder could not be refreshed but read
              luapad.AddTab(sF, file.Read(sD .. sF, "GAME"), sD, nil, sI)
            end
          end
          function pC:DoRightClick()
            local sD, sF = self.DirPath, self:GetText()
            SetClipboardText(sD .. sF)
          end
          pC.DoDoubleClick = pC.DoClick
        end
      end
    end
  end
  function luapad.BrowserTree:PopulateTree(sName, sIco)
    local sName = string.Trim(sName, "/")
    local pRoot = self:AddNode(sName)
    if (not IsValid(pRoot)) then return end
    -- Check of the leading folder is enabled
    local sSors = string.match(sName, "^([^/\\]+)", 1)
    local tConf = ENABLE_FOLDER[sSors]
    if(not tConf) then return end
    pRoot.Icon:SetImage(luapad.ToIcon((sIco or tConf.Icon) or "computer"))
    self:PopulateNode(pRoot, sName .. "/", tConf, VAR_MXR:GetInt())
  end
  return luapad.BrowserTree
end

function luapad.OpenTab(path)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pB = luapad.OpenTree()
  if(not IsValid(pB)) then return end
  local tI = pS:GetItems()
  if(path ~= nil) then
    local bB, sB, oB = luapad.GetPath(path)
    pB:PopulateTree(oB)
    luapad.SetStatus("Origin is %s. Using [%s] as base folder.", "STAT_OK", "provided", oB)
  elseif(#tI == 0) then -- No active tab is present and path is empty
    pB:PopulateTree("data")
    luapad.SetStatus("Origin is %s. Using [%s] as base folder.", "STAT_OK", "default", "/data")
  else -- If editor is not empty there will always be an active tab
    local aT = pS:GetActiveTab()
    if(not IsValid(aT)) then return end
    local tS = aT:GetStreamInfo()
    pB:PopulateTree(tS.Path)
    luapad.SetStatus("Origin is %s. Using [%s] as base folder.", "STAT_OK", "active tab", tS.Path)
  end
end

function luapad.OpenBrowseMenu()
  if(SERVER) then return end
  local tK = table.GetKeys(ENABLE_FOLDER)
  table.sort(tK, function(u, v)
    local ru = ENABLE_FOLDER[u]
    local rv = ENABLE_FOLDER[v]
    return (ru.ID < rv.ID)
  end)

  local pMenu = DermaMenu()
  if(not IsValid(pMenu)) then return end
  pMenu:SetPos(gui.MousePos())
  local uI = "computer"
  for iD = 1, #tK do
    local sD = tK[iD]
    local sU = sD:gsub("^%l", string.upper)
    local sI = (ENABLE_FOLDER[sD].Icon or uI)
    pMenu:AddOption(sU, function()
      local pB = luapad.OpenTree()
      if(not IsValid(pB)) then return end
      pB:PopulateTree(sD)
    end):SetImage(luapad.ToIcon(sI))
  end; pMenu:Open()
end

function luapad.SaveScript(vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  local tS = pT:GetStreamInfo()
  local sD, sN = tS.Path, tS.Name
  -- Configure parameters
  local tV = GLOB_CONFIG.VALDFS
  local bB, sB, oB = luapad.GetPath(sD)
  if(bB) then
    if(not canOperateIn(oB)) then
      luapad.SetStatus("File [%s%s] save failed! (origin is restricted)", "STAT_ER", oB, sN)
      return
    end
    if(not isHere(sN)) then
      luapad.SetStatus("File name is missing! (provide a non-zero string)", "STAT_ER", sN)
      return
    end
    if(not luapad.IsPath(oB..sN)) then
      luapad.SetStatus("File name [%s] is a reserved entry device!", "STAT_ER", sN)
      return
    end
    if(sN:match(tV[1])) then
      luapad.SetStatus("File name [%s] contains invalid characters!", "STAT_ER", sN)
      return
    end
    if (table.HasValue(RESTRICTED_FILES, oB .. sN)) then
      luapad.SetStatus("File [%s%s] save failed! (file is restricted)", "STAT_ER", oB, sN)
      return
    end
    -- Read contents and path
    local sF, sC = (sB .. sN), (pT:GetContents() or "")
    -- Check is the file exists
    if (not file.Exists(sF, "DATA")) then
      luapad.SaveAsScript()
    else
      file.Write(sF, sC)
      -- Update path and name
      tS.Path, tS.Name = oB, sN
      pT:SetText(sN)
      pT:SetTooltip(oB..sN)
      pS:SetActiveTab(pT)
      -- Check status
      if file.Exists(sF, "DATA") then
        luapad.SetStatus("File [%s%s] successfully saved!", "STAT_OK", oB, sN)
      else
        luapad.SetStatus("File [%s%s] save failed! (check your filename)", "STAT_ER", oB, sN)
      end
    end
  else
    luapad.SetStatus("File [%s%s] cannot be overwritten!", "STAT_WR", oB, sN)
  end
end

function luapad.SaveAsScript(vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  local tS = pT:GetStreamInfo()
  luapad.ShowConfirmDialog(
    "You are about to save a file, please enter the desired filename.",
    tS.Path .. tS.Name,
    -- The dialog function which handles the input
    function(sName)
      -- Configure parameters
      local tV = GLOB_CONFIG.VALDFS
      local sD = string.GetPathFromFilename(sName)
      local sN = string.GetFileFromFilename(sName)
      local bB, sB, oB = luapad.GetPath(sD)
      -- In case the folder is relative to data can trigger a save
      if(bB) then
        -- Perform parameter check
        if(not canOperateIn(oB)) then
          luapad.SetStatus("File [%s%s] save failed! (origin is restricted)", "STAT_ER", oB, sN)
          return
        end
        if(not isHere(sN)) then
          luapad.SetStatus("File name is missing! (provide a non-zero string)", "STAT_ER", sN)
          return
        end
        if(not luapad.IsPath(oB..sN)) then
          luapad.SetStatus("File name [%s] is a reserved entry device!", "STAT_ER", sN)
          return
        end
        if(sN:match(tV[1])) then
          luapad.SetStatus("File name [%s] contains invalid characters!", "STAT_ER", sN)
          return
        end
        if (table.HasValue(RESTRICTED_FILES, oB .. sN)) then
          luapad.SetStatus("File [%s%s] save failed! (file is restricted)", "STAT_ER", oB, sN)
          return
        end
        -- Produce a folder relative to the data folder
        local sF, sC = (sB .. sN), (pT:GetContents() or "")
        -- Write the actual contents
        file.CreateDir(sB)
        file.Write(sF, sC)
        -- Check if the file exists
        if file.Exists(sF, "DATA") then
          luapad.SetStatus("File [%s%s] successfully saved!", "STAT_OK", oB, sN)
          tS.Path, tS.Name = oB, sN -- Update path and name
          pT:SetText(sN)
          pT:SetTooltip(oB..sN)
          pS:SetActiveTab(pT)
        else
          luapad.SetStatus("File [%s%s] save failed! (check your filename)", "STAT_ER", oB, sN)
        end
      else
        luapad.SetStatus("File [%s%s] cannot be overwritten!", "STAT_WR", oB, sN)
      end
    end, nil, "Save", "Cancel"
  )
end

function luapad.SaveAll()
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local tI = pS:GetItems()
  local nI, nU = #tI, 0
  if(nI <= 0) then return end
  for iT = 1, nI do
    local cT = tI[iT].Tab
    if(IsValid(cT)) then
      local tS = cT:GetStreamInfo()
      local sD, sN = tS.Path, tS.Name
      local bB, sB, oB = luapad.GetPath(sD)
      if(bB) then
        if(not canOperateIn(oB)) then
          luapad.SetStatus("File [%s%s] save failed! (origin is restricted)", "STAT_ER", oB, sN)
          return
        end
        local sF, sC = (sB .. sN), (cT:GetContents() or "")
        file.CreateDir(sB); file.Write(sF, sC)
        if(file.Exists(sF, "DATA")) then
          nU = nU + 1
        else
          luapad.SetStatus("File [%s%s] save failed! (processed [%s] of [%s] tabs)!", "STAT_ER", oB, sN, nU, nI)
          return -- First unsuccessful file
        end
      end
    end
  end
  -- In case the loop is executed
  if(nU <= 0) then -- All tabs are not from the data folder
    luapad.SetStatus("No tabs have been saved! (check the origin access rights)", "STAT_WR")
  else -- Not every tab may be from the data folder
    luapad.SetStatus("Saved successfully [%s] of [%s] tabs!", "STAT_OK", nU, nI)
  end
end

--[[
 * Delete the associated file with a given tab
 * Tab reference to be deleted. Defaults to active
]]
function luapad.DeleteScript(vTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabSwitch(vTre)
  if(not IsValid(pT)) then return end
  local tS = pT:GetStreamInfo()
  luapad.ShowConfirmDialog(
    "Confirm deletion of the file: ".. tS.Path .. tS.Name, nil,
    function()
      local sD, sN = tS.Path, tS.Name
      local bB, sB, oB = luapad.GetPath(sD)
      if(bB) then
        if(not canOperateIn(oB)) then
          luapad.SetStatus("File [%s%s] delete failed! (origin is restricted)", "STAT_ER", oB, sN)
          return
        end
        local sF = (sB .. sN)
        if (not file.Exists(sF, "DATA")) then
          luapad.SetStatus("File [%s%s] already missing!", "STAT_WR", oB, sN)
          return
        else
          if (table.HasValue(RESTRICTED_FILES, oB .. sN)) then
            luapad.SetStatus("File [%s%s] delete failed! (file is restricted)", "STAT_ER", oB, sN)
            return
          end
          if file.Delete(sF) then
            luapad.SetStatus("File [%s%s] successfully deleted!", "STAT_OK", oB, sN)
          else
            luapad.SetStatus("File [%s%s] delete failed (check your filename)! ", "STAT_ER", oB, sN)
          end
        end
      else
        luapad.SetStatus("File [%s%s] cannot be deleted!", "STAT_WR", oB, sN)
      end
    end, nil, "Delete", "Cancel"
  )
end

function luapad.RunScriptClient(vTre)
  local user = LocalPlayer()
  if(SERVER or not canUserAccess(user)) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local cT = pS:GetTabSwitch(vTre)
  if(not IsValid(cT)) then return end
  local sC = cT:GetContents()
  local tS = cT:GetStreamInfo()
  local sD, sN = tS.Path, tS.Name
  local sI = GLOB_CONFIG.MSGCAL:format(user:Nick(), "Client")..
             GLOB_CONFIG.FFDRPT:format(getString(sD, sN))
  runScriptHandler(sC, sI, luapad.SetStatus)
end

function luapad.RunScriptServer(vTre, bCon)
  local user = LocalPlayer()
  if(SERVER or not canUserAccess(user)) then return end
  local sA = GLOB_CONFIG.LOWADN..".Upload"
  if(not canUserAcceptStream(user, sA)) then
    luapad.SetStatus("User message could not be accepted! (check permissions)", "COMS_WR")
    return
  end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local cT = pS:GetTabSwitch(vTre)
  if(not IsValid(cT)) then return end
  local sC = cT:GetContents()
  if(not canWriteString(sC)) then
    luapad.SetStatus("Script exceeds the size limit! (shorten the code to proceed)", "COMS_WR")
    return
  end
  local tS = cT:GetStreamInfo()
  local sD, sN = tS.Path, tS.Name
  local sI = GLOB_CONFIG.MSGCAL:format(user:Nick(), "Server")..
             GLOB_CONFIG.FFDRPT:format(getString(sD, sN))
  net.Start(sA)
  net.WriteString(sC)
  net.WriteString(sI)
  net.WriteBool(bCon)
  net.SendToServer()
end

function luapad.RunScriptBroadcast(vTre)
  local user = LocalPlayer()
  if(SERVER or not canUserAccess(user)) then return end
  local sA = GLOB_CONFIG.LOWADN..".UploadClient"
  if(not canUserAcceptStream(user, sA)) then
    luapad.SetStatus("User message could not be accepted! (check permissions)", "COMS_WR")
    return
  end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local cT = pS:GetTabSwitch(vTre)
  if(not IsValid(cT)) then return end
  local sC = cT:GetContents()
  if(not canWriteString(sC)) then
    luapad.SetStatus("Script exceeds the size limit! (shorten the code to proceed)", "COMS_WR")
    return
  end
  local tS = cT:GetStreamInfo()
  local sD, sN = tS.Path, tS.Name
  local sI = GLOB_CONFIG.MSGCAL:format(user:Nick(), "Broadcast")..
             GLOB_CONFIG.FFDRPT:format(getString(sD, sN))
  net.Start(sA)
  net.WriteString(sC)
  net.WriteString(sI)
  net.SendToServer()
end

concommand.Add(GLOB_CONFIG.ADDONN, luapad.Toggle)

