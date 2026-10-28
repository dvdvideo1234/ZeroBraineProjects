-- Luapad
-- An in-game scripting environment
-- by DarKSunrise aka Assassini
-- Ported to GMod 13 by SparkZ
luapad = {}
luapad.debugmode = true
luapad.forcedownload = true
luapad.IgnoreConsoleOpen = true
local GLOB_CONFIG = {
  DELIMS = "|", -- General symbol used for separator
  PANLSZ = 2 / 3, -- The ratio panel will use according to the screen size
  DAYINS = 86400, -- The amount of second present in one day
  MAXMSL = 60000, -- As the maximum write string limit is 65532
  ADDONN = "Luapad", -- Generic addon name
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
  CFLAGS = bit.bor(FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
}
-- They can still do cs lua if you don't have 'sv_allowcslua 0'!!!
local VAR_ARN = CreateConVar(GLOB_CONFIG.LOWADN.."_autorenew", 14, GLOB_CONFIG.CFLAGS, "File grace period for auto renew in days", 0, 1000)
local VAR_ADM = CreateConVar(GLOB_CONFIG.LOWADN.."_adminonly",  1, GLOB_CONFIG.CFLAGS, "Makes the luapad addon admin usable only", 0, 1)
local VAR_MXF = CreateConVar(GLOB_CONFIG.LOWADN.."_maxunamed", 10, GLOB_CONFIG.CFLAGS, "Maximum number of new files in the folder", 0, 100)
local VAR_MXR = CreateConVar(GLOB_CONFIG.LOWADN.."_maxrecurs", 20, GLOB_CONFIG.CFLAGS, "Recurse depth when opening a file system", 0, 100)
local VAR_EDT = CreateConVar(GLOB_CONFIG.LOWADN.."_endataorg",  1, GLOB_CONFIG.CFLAGS, "File operation in the whole data folder", 0, 1)
----------------------------

luapad.GLOB_CONFIG = GLOB_CONFIG
GLOB_CONFIG.FOLDER = "C:/Programs/ZeroBraineIDE/ZeroBraineProjects/Garrysmod/Luapad/"..GLOB_CONFIG.FOLDER

print("L1", 1, RunString)

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
  X = {package}, -- Syntax ignore globals
  N = GLOB_CONFIG.LOWADN.. "._sG", -- Name
  I = "[\"%s\"]",   -- Index
  V = " = \"%s\"",  -- Value
  H = " = %s or {}" -- Header
}
local PATPATH_CONVERT = {
  {"[\\/]+", "/"}, {"%.%./", ""},
  {"^[/]+" , "" }, {"[/]+$", ""},
  Sors = {"^data/", "", 1},
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
 * The path provided is always relative to the game folder
]]
function canOperateIn(sPath)
  local tP = PATPATH_CONVERT
  local bB, sB, oB = luapad.GetPath(sPath)
  if(bB) then -- In the data folder
    if(VAR_EDT:GetBool()) then return true end
    local nS, nE = sB:find(tP.Base[1])
    if(nS and nE and nS == 1) then return true end
  end; return false
end
function canUserAccess(pUser)
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
  for iX = 1, #tX do local vX = tX[iX] -- Ignore globals
    if(istable(vX) and vX ~= nul) then tPass[vX] = true end
  end -- Ignored global tables are loaded and ignored
   -- Global registry includes itself
  local function exportSyntax(sB, tS, iD)
    local iD = math.max((tonumber(iD) or 0), 0)
    if(iD > 5) then return end -- Recursion depth
    if(tPass[tS]) then return end -- Already printed
    local sU, rU = sB:gsub("^.-%[\"", ""):gsub("\"%]$", "")
    local tK, sC, nU = table.GetKeys(tS), ("\"][\""), 0
    local tU, bH = sC:Explode(sU), true; nU = (#tU + 1)
    table.sort(tK, function(u, v) return u < v end)
    for iE = 1, #tK do -- Loop alphabetically
      local vK = tK[iE]
      local vE = tS[vK]
      if(isfunction(vE)) then
        if(bH) then bH = false
          fS:Write(sB)
          fS:Write(sH:format(sB))
          fS:Write("\n")
        end
        fS:Write(sB)
        fS:Write(sI:format(vK))
        fS:Write(sV:format("f"))
        fS:Write("\n")
      elseif(string.upper(vK) == vK) then
        if(bH) then bH = false
          fS:Write(sB)
          fS:Write(sH:format(sB))
          fS:Write("\n")
        end
        if(rU == 0) then table.insert(tEnum, vK) else
          tU[nU] = vK -- Register local enums
          table.insert(tEnum, table.concat(tU, sC))
        end -- Nothing is replaced no keys registered
      elseif(istable(vE)) then tPass[tS] = true
        exportSyntax(sB..sI:format(vK), vE, iD + 1)
      end
    end
  end
  fS:Write("-- This is an automatically generated cache file on the server-side\n")
  fS:Write("-- The content includes global functions, meta-tables, and enumerations\n")
  fS:Write("-- Don't touch it, or you'll probably mess up your syntax highlighting\n")
  fS:Write("-- The timestamp of this generated file is ["..os.date(GLOB_CONFIG.DATFMT).."]\n")
  fS:Write("\n-- Global functions and libraries\n\n")
  local tK = table.GetKeys(_G) -- Global registry includes itself
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
  fS:Flush(); fS:Close()
  luapad.SetConsole("Syntax globals generated: %s", "STAT_OK", sG)
end
luapad.genSyntaxGlobals() -- Generate server-side globals
print("LL0", 1, RunString)
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
print("LL", 1, RunString, file.Read)
print("------------0------------")
if (file.Exists(GLOB_CONFIG.FOLDER.."cl_syntax_globals.txt", "DATA")) then
  print("------------1------------")
  RunString(file.Read(GLOB_CONFIG.FOLDER.."cl_syntax_globals.txt", "DATA"))
  print("------------2------------")
  if (file.Exists(GLOB_CONFIG.FOLDER.."sv_syntax_globals.txt", "DATA")) then
    print("------------3------------")
    RunString(file.Read(GLOB_CONFIG.FOLDER.."sv_syntax_globals.txt", "DATA"))
    print("------------4------------")
  end -- In case the server file is added and transferred merge the syntax keys
  print("------------5------------")
else -- Load the hard-coded syntax highlighter relative to the lua folder
  print("------------6------------")
  include("autorun/syntax_globals.lua")
  print("------------7------------")
end
print("------------8------------")
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
      cBar.a = math.Clamp(cBar.a - 1, 0, 255)
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
print("L20", 1, RunString)
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
  if(sTxt ~= nil) then
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
print("L2", 1, RunString)
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
function luapad.CheckGlobal(func)
  if (luapad._sG[func] ~= nil) then
    local sN = FMSYNTAX_HILIGHT.N
    if (luapad.debugmode) then
      print(GLOB_CONFIG.SRCHFM:format(func, sN))
    end
    return luapad._sG[func]
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
      tO[1], tO[2] = tS.Name , tS.Path
      tO[3], tO[4] = (tS.Term or ""), tS.Icon
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
  local sF = file.Read(GLOB_CONFIG.FOLDER.."saved_tabs.txt", "DATA" )
  if(not sF) then return end -- File not found then bail out
  local tW, aT = ("[\r\n]+"):Explode(sF, true), nil
  for iD = 1, #tW do -- Basically we have one tab on one line
    local tO = GLOB_CONFIG.DELIMS:Explode(tW[iD]) -- Empty lines are excluded
    local bA = (string.sub(tO[1], 1, 1) == "*") -- File name starts with * when active
    if(bA) then tO[1] = string.sub(tO[1], 2, -1) end
    local bB, sB, oB, pT = luapad.GetPath(tO[2])
    if(tO[1] ~= "" and tO[2] ~= "") then -- No name to identify the file
      if(bB) then -- Load a tab relative to the data folder
        pT = luapad.AddTab(tO[1], file.Read(sB..tO[1], "DATA"), oB, tO[3], tO[4])
      else -- Load a tab relative to the game folder
        pT = luapad.AddTab(tO[1], file.Read(oB..tO[1], "GAME"), oB, tO[3], tO[4])
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
      luapad.Frame:SetTitle(sN)
    end
  end
  function luapad.PropertySheet:GetTabIndex(vTre, bNop)
    if(IsValid(vTre)) then -- Valid panel
      local tI = self:GetItems()
      for iT = 1, #tI do -- Try to match reference
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
      for iT = 1, #tI do -- Try to match some info string
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
  function luapad.PropertySheet:GetTabStitch(vTre)
    if(vTre) then -- There is an argument
      local iT, vT = self:GetTabIndex(vTre)
      if(not iT) then return nil end
      return vT -- The argument is validated
    else
      local vT = self:GetActiveTab()
      if(not IsValid(vT)) then return nil end
      return vT -- No argument use active
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
  luapad.AddToolbarItem("New (CTRL + N) / Active tab origin"   , "page_add"   , luapad.NewTab, luapad.NewTabActive)
  luapad.AddToolbarItem("Open (CTRL + O) / Open file browser"  , "folder_page", luapad.OpenTab, luapad.OpenBrowse)
  luapad.AddToolbarItem("Save (CTRL + S) / Save all tabs"      , "disk"       , luapad.SaveScript, luapad.SaveAll)
  luapad.AddToolbarItem("Save As (CTRL + ALT + S)"             , "page_save"  , luapad.SaveAsScript)
  luapad.AddToolbarSpacer()
  luapad.AddToolbarItem("Execute / Execute realm", "script_lightning", luapad.RunScriptClient, luapad.RunScriptMenu)
  luapad.AddToolbarItem("Refresh / Refresh all"  , "page_refresh"  , luapad.RefreshTabActive, luapad.RefreshTabAll)
  luapad.AddToolbarItem("Close / Close all"      , "page_delete"   , luapad.CloseTabActive, luapad.CloseTabAll)
  luapad.AddToolbarSpacer()
  luapad.AddToolbarItem("Load tabs / Save tabs"  , "briefcase" , luapad.LoadTabs, luapad.SaveTabs)
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
print("L3", 1, RunString)
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
  if(vTip ~= nil) then pBut:SetTooltip(tostring(vTip)) end
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
    local iT, vT = pS:GetTabIndex(tostring(name or ""), nopat)
    if(not iT) then return end -- No such tab do nothing
    if(nI > 1) then pS:CloseTab(vT, true) else pS:Clear() end
    pS:InvalidateLayout()
  end
end
--[[
 * Closes the tab by view panel reference
 * pTre > The tab reference that must be closed
]]
function luapad.CloseTabView(pTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(pTre)
  if(not iT) then return end
  -- Avoid triggering active tab close
  local aT = pS:GetActiveTab()
  if(aT == pTre) then
    luapad.CloseTabActive()
    return
  end
  local tI = pS:GetItems()
  if(#tI == 1) then
    pS:Clear()
  else
    pS:CloseTab(pTre, true)
  end
  pS:InvalidateLayout()
end
--[[
 * Closes all tabs to the left
 * No tabs are found the index is empty
 * pTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.CloseTabLeft(pTre, bInc)
  if(SERVER) then return end
  if(not IsValid(pTre)) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(pTre)
  if(not iT) then return end
  if(not bInc) then iT = iT - 1 end
  local tI = pS:GetItems()
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
 * pTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.CloseTabRight(pTre, bInc)
  if(SERVER) then return end
  if(not IsValid(pTre)) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(pTre)
  if(not iT) then return end
  local tI = pS:GetItems()
  if(not bInc) then iT = iT + 1 end
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
]]
function luapad.CloseTabOther(pTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(pTre)
  if(not iT) then return end
  luapad.CloseTabLeft(pTre)
  luapad.CloseTabRight(pTre)
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
 * Refreshes all the tabs on name/term
]]
function luapad.RefreshTabName(name, term, nopat)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local tI = pS:GetItems()
  local nI, nU = #tI, 0
  if(nI <= 0) then return end
  local sS  = tostring(term or name)
  for iT = 1, nI do
    local cT = tI[iT].Tab
    if(IsValid(cT)) then
      local tS, bS = cT:GetStreamInfo(), false
      local sD, sN, sT = tS.Path, tS.Name, tS.Term
      local bB, sB, oB = luapad.GetPath(sD)
      if(bB) then
        local sO = (sD .. sN)
        local sF = (sB .. sN)
        if(sT and sT:find(sS, 1, nopat)) then
          bS = true  -- Match by term
        elseif(sO and sO:find(sS, 1, nopat)) then
          bS = true -- Match by origin
        elseif(sN and sN:find(sS, 1, nopat)) then
          bS = true -- Match by name
        else -- Assign false in other cases
          bS = false -- Do not match anything
        end
        if(bS) then
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
  end
  -- In case the loop is executed
  if(nU <= 0) then -- All tabs are not from the data folder
    luapad.SetStatus("No tabs have been refreshed! (check the origin access rights)", "STAT_WR")
  else -- Not every tab may be from the data folder
    luapad.SetStatus("Refreshed successfully [%s] of [%s] tabs!", "STAT_OK", nU, nI)
  end
end
print("L4", 1, RunString)
function luapad.RefreshTabView(pTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(pTre)
  if(not iT) then return end
  -- Avoid triggering active tab close
  local aT = pS:GetActiveTab()
  if(aT == pTre) then
    luapad.RefreshTabActive()
    return
  end
  local tS = pTre:GetStreamInfo()
  local sD, sN = tS.Path, tS.Name
  local bB, sB, oB = luapad.GetPath(sD)
  if(bB) then
    local sF = (sB .. sN)
    local sCon = file.Read(sF, "DATA")
    if(sCon) then pTre:SetContents(sCon)
      luapad.SetStatus("File successfully refreshed!", "STAT_OK")
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
 * pTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.RefreshTabLeft(pTre, bInc)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(pTre)
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
 * pTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.RefreshTabRight(pTre, bInc)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(pTre)
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
      luapad.SetStatus("File successfully refreshed!", "STAT_OK")
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
 * pTre > The tab to use as reference
 * bInc > Close also the reference tab
]]
function luapad.RefreshTabOther(pTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local iT = pS:GetTabIndex(pTre)
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
]]
function luapad.AddTab(name, cont, path, term, icon)
  if(SERVER) then return end
  local sPth = tostring(path or "")
  local sNam = tostring(name or "")
  local sCon = tostring(cont or "")
  local sIco = tostring(icon or "page_white")
  local bTrm = (term ~= nil and term ~= "")
  local sTag = (bTrm and tostring(term) or nil)
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
  pTab:SetTooltip(sPth .. sNam)
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
    pIn:AddOption("Name", function()
      SetClipboardText(self:GetStreamInfo().Name)
    end):SetImage(luapad.ToIcon("page_green"))
    pIn:AddOption("Label", function()
      local tS = self:GetStreamInfo()
      SetClipboardText(tS.Term or tS.Name)
    end):SetImage(luapad.ToIcon("tag_green"))
    pIn:AddOption("Path", function()
      SetClipboardText(self:GetStreamInfo().Path)
    end):SetImage(luapad.ToIcon("folder"))
    pIn:AddOption("Full", function()
      local tS = self:GetStreamInfo()
      SetClipboardText(tS.Path .. tS.Name)
    end):SetImage(luapad.ToIcon("folder_page"))
    pIn:AddOption("Index", function()
      local pS = self:GetPropertySheet()
      local iT = pS:GetTabIndex(self)
      SetClipboardText(tostring(iT or "N/A"))
    end):SetImage(luapad.ToIcon("key"))
    -- File operations
    local pIn, pOp = pMenu:AddSubMenu("File")
    pOp:SetIcon(luapad.ToIcon("table_lightning"))
    pIn:AddOption("New" , function()
      local tS = self:GetStreamInfo()
      luapad.NewTab(nil, tS.Path)
    end):SetImage(luapad.ToIcon("page_add"))
    pIn:AddOption("Open", function()
      local tS = self:GetStreamInfo()
      luapad.OpenTab(tS.Path)
    end):SetImage(luapad.ToIcon("folder_page"))
    pIn:AddOption("Save", function()
      luapad.SaveScript(self)
    end):SetImage(luapad.ToIcon("disk"))
    pIn:AddOption("Save As", function()
      luapad.SaveAsScript(self)
    end):SetImage(luapad.ToIcon("page_save"))
    pIn:AddOption("Delete", function()
      luapad.DeleteScript(self)
    end):SetImage(luapad.ToIcon("page_delete"))
    -- Refresh a tab
    local pIn, pOp = pMenu:AddSubMenu("Refresh")
    pOp:SetIcon(luapad.ToIcon("table_refresh"))
    pIn:AddOption("This", function()
      luapad.RefreshTabView(self)
    end):SetImage(luapad.ToIcon("arrow_down"))
    pIn:AddOption("Active", function()
      luapad.RefreshTabActive()
    end):SetImage(luapad.ToIcon("arrow_refresh"))
    pIn:AddOption("Right", function()
      luapad.RefreshTabRight(self)
    end):SetImage(luapad.ToIcon("arrow_right"))
    pIn:AddOption("Left", function()
      luapad.RefreshTabLeft(self)
    end):SetImage(luapad.ToIcon("arrow_left"))
    pIn:AddOption("Right (+)", function()
      luapad.RefreshTabRight(self, true)
    end):SetImage(luapad.ToIcon("arrow_turn_right"))
    pIn:AddOption("Left (+)", function()
      luapad.RefreshTabLeft(self, true)
    end):SetImage(luapad.ToIcon("arrow_turn_left"))
    pIn:AddOption("Others", function()
      luapad.RefreshTabOther(self)
    end):SetImage(luapad.ToIcon("arrow_out"))
    pIn:AddOption("All", function()
      luapad.RefreshTabAll()
    end):SetImage(luapad.ToIcon("arrow_in"))
    -- Execute a script
    local pIn, pOp = pMenu:AddSubMenu("Execute")
    pOp:SetIcon(luapad.ToIcon("table_go"))
    pIn:AddOption("Client", function()
      luapad.RunScriptClient(self)
    end):SetImage(luapad.ToIcon("user_go"))
    pIn:AddOption("Server", function()
      luapad.RunScriptServer(self)
    end):SetImage(luapad.ToIcon("server_go"))
    pIn:AddOption("Shared", function()
      luapad.RunScriptClient(self)
      luapad.RunScriptServer(self, true)
    end):SetImage(luapad.ToIcon("computer_go"))
    pIn:AddOption("Broadcast", function()
      luapad.RunScriptBroadcast(self)
    end):SetImage(luapad.ToIcon("feed_go"))
    -- Close tabs
    local pIn, pOp = pMenu:AddSubMenu("Close")
    pOp:SetIcon(luapad.ToIcon("table_delete"))
    pIn:AddOption("This", function()
      luapad.CloseTabView(self)
    end):SetImage(luapad.ToIcon("arrow_down"))
    pIn:AddOption("Active", function()
      luapad.CloseTabActive()
    end):SetImage(luapad.ToIcon("arrow_refresh"))
    pIn:AddOption("Right", function()
      luapad.CloseTabRight(self)
    end):SetImage(luapad.ToIcon("arrow_right"))
    pIn:AddOption("Left", function()
      luapad.CloseTabLeft(self)
    end):SetImage(luapad.ToIcon("arrow_left"))
    pIn:AddOption("Right (+)", function()
      luapad.CloseTabRight(self, true)
    end):SetImage(luapad.ToIcon("arrow_turn_right"))
    pIn:AddOption("Left (+)", function()
      luapad.CloseTabLeft(self, true)
    end):SetImage(luapad.ToIcon("arrow_turn_left"))
    pIn:AddOption("Others", function()
      luapad.CloseTabOther(self)
    end):SetImage(luapad.ToIcon("arrow_out"))
    pIn:AddOption("All", function()
      luapad.CloseTabAll()
    end):SetImage(luapad.ToIcon("arrow_in"))
    -- Open menu
    pMenu:Open()
  end
  pSheet:SetActiveTab(pTab)
  pSheet:InvalidateLayout()
  return pTab
end
function luapad.RunScriptMenu()
  local pMenu = DermaMenu()
  if(not IsValid(pMenu)) then return end
  pMenu:SetPos(gui.MousePos())
  -- Execute a script
  pMenu:AddOption("Client", function()
    luapad.RunScriptClient()
  end):SetImage(luapad.ToIcon("user_go"))
  pMenu:AddOption("Server", function()
    luapad.RunScriptServer()
  end):SetImage(luapad.ToIcon("server_go"))
  pMenu:AddOption("Shared", function()
    luapad.RunScriptClient()
    luapad.RunScriptServer(nil, true)
  end):SetImage(luapad.ToIcon("computer_go"))
  pMenu:AddOption("Broadcast", function()
    luapad.RunScriptBroadcast()
  end):SetImage(luapad.ToIcon("feed_go"))
  pMenu:Open()
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
          if(input.IsKeyDown(KEY_LSHIFT)) then
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
function luapad.OpenBrowse()
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
function luapad.SaveScript(pTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabStitch(pTre)
  if(not IsValid(pT)) then return end
  local tS = pT:GetStreamInfo()
  local sD, sN = tS.Path, tS.Name
  local bB, sB, oB = luapad.GetPath(sD)
  if(bB) then
    if(not canOperateIn(oB)) then
      luapad.SetStatus("File [%s%s] save failed! (origin is restricted)", "STAT_ER", oB, sN)
      return
    end
    local sF, sC = (sB .. sN), (pT:GetContents() or "")
    if (not file.Exists(sF, "DATA")) then
      luapad.SaveAsScript()
    else
      if (table.HasValue(RESTRICTED_FILES, oB .. sN)) then
        luapad.SetStatus("File [%s%s] save failed! (file is restricted)", "STAT_ER", oB, sN)
        return
      end
      file.Write(sF, sC)
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
function luapad.SaveAsScript(pTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabStitch(pTre)
  if(not IsValid(pT)) then return end
  local tS = pT:GetStreamInfo()
  luapad.ShowConfirmDialog(
    "You are about to save a file, please enter the desired filename.",
    tS.Path .. tS.Name,
    function(sName)
      if (table.HasValue(RESTRICTED_FILES, sName)) then
        luapad.SetStatus("File [%s] save failed! (file is restricted)", "STAT_ER", sName)
        return
      end
      local sD = string.GetPathFromFilename(sName)
      local sN = string.GetFileFromFilename(sName)
      local bB, sB, oB = luapad.GetPath(sD)
      if(bB) then
        if(not canOperateIn(oB)) then
          luapad.SetStatus("File [%s%s] save failed! (origin is restricted)", "STAT_ER", oB, sN)
          return
        end
        local sF, sC = (sB .. sN), (pT:GetContents() or "")
        file.CreateDir(sB)
        file.Write(sF, sC)
        if file.Exists(sF, "DATA") then
          luapad.SetStatus("File [%s%s] successfully saved!", "STAT_OK", oB, sN)
          tS.Path, tS.Name = oB, sN -- Update path and name
          pT:SetText(tS.Name)
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
          luapad.SetStatus("File [%s%s] save failed! Processed [%s] of [%s] tabs!", "STAT_ER", oB, sN, nU, nI)
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
function luapad.DeleteScript(pTre)
  if(SERVER) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local pT = pS:GetTabStitch(pTre)
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
function luapad.RunScriptClient(pTre)
  local user = LocalPlayer()
  if(SERVER or not canUserAccess(user)) then return end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local cT = pS:GetTabStitch(pTre)
  if(not IsValid(cT)) then return end
  local sC = cT:GetContents()
  local tS = cT:GetStreamInfo()
  local sD, sN = tS.Path, tS.Name
  local sI = GLOB_CONFIG.MSGCAL:format(user:Nick(), "Client")..
             GLOB_CONFIG.FFDRPT:format(getString(sD, sN))
  runScriptHandler(sC, sI, luapad.SetStatus)
end
function luapad.RunScriptServer(pTre, bCon)
  local user = LocalPlayer()
  if(SERVER or not canUserAccess(user)) then return end
  local sA = GLOB_CONFIG.LOWADN..".Upload"
  if(not canUserAcceptStream(user, sA)) then
    luapad.SetStatus("User message could not be accepted! (check permissions)", "COMS_WR")
    return
  end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local cT = pS:GetTabStitch(pTre)
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
function luapad.RunScriptBroadcast(pTre)
  local user = LocalPlayer()
  if(SERVER or not canUserAccess(user)) then return end
  local sA = GLOB_CONFIG.LOWADN..".UploadClient"
  if(not canUserAcceptStream(user, sA)) then
    luapad.SetStatus("User message could not be accepted! (check permissions)", "COMS_WR")
    return
  end
  local pS = luapad.PropertySheet
  if(not IsValid(pS)) then return end
  local cT = pS:GetTabStitch(pTre)
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

