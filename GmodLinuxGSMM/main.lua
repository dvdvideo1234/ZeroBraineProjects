local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(2)
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
  {"TrackAssemblyTool"   , "Assembles segmented train track. Supports wire"},
  {"PhysPropertiesAdv"   , "Advanced configurable properties"},
  {"ControlSystemsE2"    , "Adds PID controllers and fast traces as OOP to wire E2. Minor version included in wire-extas"},
  {"E2PistonTiming"      , "Adds routine driven timings for piston engines to wire E2"},
  {"PropCannonTool"      , "An actual cannon entity that can fire props. Supports wire"},
  {"GearAssemblyTool"    , "Assembles segmented gearbox"},
  {"SpinnerTool"         , "Torque lever controlled spinner. Supports wire"},
  {"SurfaceFrictionTool" , "Controls the surface friction of a prop"},
  {"MagneticDipole"      , "An actual magnet entity that runs forces on its poles unlike magnetize. Supports wire"},
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
local rep = tostring(sRepo or "") -- lgsm/functions/mods_list.sh
if(rep:len() == 0 or not rep:find("%w+")) then error("Repo invalid: ["..rep.."]") end
local low, inf = rep:lower(), tostring(sInfo or tAddons.Base.inf)
local ath = tostring(sAuth or tAddons.Base.ath) -- Utilize my account if not provided
if(ath:len() == 0 or not ath:find("%w+")) then error("Auth invalid: ["..ath.."]") end
local nam = tostring(sName or getName(rep))
local ovr = ((bOvr ~= nil) and tAddons.Base.upd[1] or tAddons.Base.upd[2])
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
