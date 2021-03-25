local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(1)
local com = require("common")
local fou = com.stringGetChunkPath():gsub("\\","/").."out.sh"

tAddons =
{ 
  Base = {
    ath = "dvdvideo1234", -- My account
    inf = "Garry's mod addon", -- Default name
    upd = {"OVERWRITE", "NOUPDATE"},
  },
  -- [1]s: Addon repositoty name from github
  -- [2]s: Addon description
  -- [3]s: Addon ownner when diffrent than my account
  -- [4]s: Addon custom name when the converted is desired
  -- [5]b: Should the addon be updated automatically or not
  -- My persinal addons
  {"advduplicator"       , "Save your constructions. First version", "wiremod", "Advanced Duplicator 1"},
  {"TrackAssemblyTool"   , "Assembles segmented track. Supports wire"},
  {"PhysPropertiesAdv"   , "Advanced configurable properties"},
  {"ControlSystemsE2"    , "PID controllers and fast traces for E2. Minor included in wire-extas"},
  {"E2PistonTiming"      , "Routine driven piston engine timings for E2"},
  {"PropCannonTool"      , "Cannon entity that can fire props. Supports wire"},
  {"GearAssemblyTool"    , "Assembles segmented gearbox"},
  {"SpinnerTool"         , "Torque lever controlled spinner. Supports wire"},
  {"SurfaceFrictionTool" , "Controls the surface friction of a prop"},
  {"MagneticDipole"      , "Magnet entity that runs forces on its poles. Supports wire"},
  {"EnvironmentOrganizer", "Installs routines designed for server settings adjustment"},
  -- Other cool people addons
  {"improved-stacker"    , "Stacks entities in the direction chosen", "Mista-Tea"},
  {"improved-weight"     , "Weight tool but with more features", "Mista-Tea"},
  {"improved-antinoclip" , "Controls clipping trough an object", "Mista-Tea"}
}; tAddons.Size = #tAddons

local function getName(sRepo)
  local nam = sRepo:gsub("%W+", " "):gsub("%s+", " ") -- Equalize non-alphanum
        nam = " "..com.stringTrim(nam) -- Trim the trailing spaces and concat one in front
        nam = nam:gsub(" %w", function(x) return " "..x:sub(2,2):upper() end) -- Convert
        nam = com.stringTrim(nam) -- Trim the remaining spaces when any are present
        nam = nam:gsub("(%S)(%u)", "%1 %2") -- Put a space between lowercase and uppercase
  return nam
end

local function printAddon(sRepo, sInfo, sAuth, sName, bOvr)
local rep = tostring(sRepo or "") -- https://github.com/GameServerManagers/LinuxGSM/blob/master/lgsm/functions/mods_list.sh
if(rep:len() == 0 or not rep:find("%w+")) then error("Repo invalid: ["..rep.."]") end
local low, inf = rep:lower(), tostring(sInfo or tAddons.Base.inf)
local ath = tostring(sAuth or tAddons.Base.ath) -- Utilize my account if not provided
if(ath:len() == 0 or not ath:find("%w+")) then error("Auth invalid: ["..ath.."]") end
local nam = tostring(sName or getName(rep))
local ovr = ((bOvr ~= nil) and tAddons.Base.upd[1] or tAddons.Base.upd[2])
-- [0]  | "MOD": separator, all mods must begin with it
-- [1]  | "modcommand": the LGSM name and command to install the mod (must be unique and lowercase)
-- [2]  | "Pretty Name": the common name people use to call the mod that will be displayed to the user
-- [3]  | "URL": link to the mod archive file; can be a variable previously defined while scraping a URL
-- [4]  | "filename": the output filename
-- [5]  | "modsubdirs": in how many subdirectories is the mod (none is 0) (not used at release, but could be in the future)
-- [6]  | "LowercaseOn/Off": LowercaseOff or LowercaseOn: enable/disable converting extracted files and directories to lowercase (some games require it)
-- [7]  | "modinstalldir": the directory in which to install the mode (use LGSM dir variables such as ${systemdir})
-- [8]  | "/files/to/keep;", files & directories that should not be overwritten upon update, separated and ended with a semicolon; you can also use "OVERWRITE" value to ignore the value or "NOUPDATE" to disallow updating; for files to keep upon uninstall, see fn_mod_tidy_files_list from mods_core.sh
-- [9]  | "Supported Engines;": list them according to LGSM ${engine} variables, separated and ended with a semicolon, or use ENGINES to ignore the value
-- [10] | "Supported Games;": list them according to LGSM ${gamename} variables, separated and ended with a semicolon, or use GAMES to ignore the value
-- [11] | "Unsupported Games;": list them according to LGSM ${gamename} variables, separated and ended with a semicolon, or use NOTGAMES to ignore the value (useful to exclude a game when using Supported Engines)
-- [12] | "AUTHOR_URL" is the author's website, displayed to the user when chosing mods to install
-- [13] | "Short Description" a description showed to the user upon installation/removal
io.write("mod_info_"..low.."=( MOD \""..low.."\" \""..nam.."\" \"https://github.com/"..ath.."/"..low.."/archive/master.zip\" \""..low.."-master.zip\" \"0\" \"LowercaseOn\" \"${systemdir}/addons\" \"OVERWRITE\" \"ENGINES\" \"Garry's Mod;\" \"NOTGAMES\" \"https://github.com/"..ath.."/"..rep.."\" \""..inf.."\" )")
io.write("\n")
end

local function printSettings()
  for iD = 1, tAddons.Size do local vA = tAddons[iD]
    local a, b, c, d = vA[1], vA[2], vA[3], vA[4]
    local e, f, g, h = vA[5], vA[6], vA[7], vA[8]
    local suc, out = pcall(printAddon, a, b, c, d, e, f, g, h)
    if(not suc) then error("Failed ["..tostring(a).."]: "..out) end
  end
end

if(not fou or fou == "") then
  printSettings()
else
  local f = assert(io.open(fou, "wb"))
  if(f) then io.output(f)
    printSettings()
  end
end
