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

local function format(sRepo, sInfo, sAuth)
local rep = tostring(sRepo or "") -- lgsm/functions/mods_list.sh
if(rep:len() == 0 or not rep:find("%w+")) then error("Repo invalid: ["..rep.."]") end
local low, inf = rep:lower(), tostring(sInfo or "Garry's mod addon")
local ath = tostring(sAuth or "dvdvideo1234") -- Utilize my account if not provided
if(ath:len() == 0 or not ath:find("%w+")) then error("Auth invalid: ["..ath.."]") end
local nam = rep:gsub("%W+", " "):gsub("%s+", " ") -- Equalize non-alphanum
      nam = " "..com.stringTrim(nam) -- Trim the trailing spaces and concat one in front
      nam = nam:gsub(" %w", function(x) return " "..x:sub(2,2):upper() end) -- Convert
      nam = com.stringTrim(nam) -- Trim the remaining spaces when any are present
      nam = nam:gsub("(%l)(%u)", "%1 %2") -- Put a space between lowercase and uppercase
print("mod_info_"..low.."=( MOD \""..low.."\" \""..nam.."\" \"https://github.com/"..ath.."/"..low.."/archive/master.zip\" \""..low.."-master.zip\" \"0\" \"LowercaseOn\" \"${systemdir}/addons\" \"NOUPDATE\" \"ENGINES\" \"Garry's Mod;\" \"NOTGAMES\" \"https://github.com/"..ath.."/"..rep.."\" \""..inf.."\" )")
end

format("TrackAssemblyTool", "Assembles segmented train track. Supports wire")
format("PhysPropertiesAdv", "Advanced configurable properties")
format("ControlSystemsE2", "Adds PID controllers and fast traces as OOP to wire E2. Minor version included in wire-extas")
format("E2PistonTiming", "Adds routine driven timings for piston engines to wire E2")
format("PropCannonTool", "An actual cannon entity that can fire props. Supports wire")
format("GearAssemblyTool", "Assembles segmented gearbox")
format("SpinnerTool", "Torque lever controlled spinner. Supports wire")
format("SurfaceFrictionTool", "Controls the surface friction of a prop")
format("MagneticDipole", "An actual magnet entity that runs forces on its poles unlike magnetize. Supports wire")
format("EnvironmentOrganizer", "Installs routines designed for server settings adjustment")

format("improved-stacker", "Stacks entities in the direction chosen", "Mista-Tea")
format("improved-weight", "Weight tool but with more features", "Mista-Tea")
format("improved-antinoclip", "Controls clipping trough an object", "Mista-Tea")
