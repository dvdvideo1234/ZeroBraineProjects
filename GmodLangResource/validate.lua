local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)
      
local prop = require("gmodlib/custom/properties")
--[[
local lst = prop.newList()
      lst:setBase("D:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons")
      lst:recItem("TrackAssemblyTool_GIT", "trackassembly", "en", "bg", "ru", "fr", "ja")
      lst:recItem("GearAssemblyTool_GIT", "gearassembly", "en", "bg")
      lst:recItem("Offset-Hoverballs", "offset_hoverball", "en", "bg")
      lst:recItem("PhysPropertiesAdv", {"material_adv", "physprop_adv"}, "en", "bg")
      lst:recItem("PropCannonTool_GIT", "propcannon", "en", "bg")
      lst:recItem("SpinnerTool", "spinner", "en", "bg", "ja")
      lst:recItem("LaserSTool", "laseremitter", "en", "bg")
      lst:isItems()
 ]]
 local lst = prop.newList()
      lst:setBase("C:/Users/ddobromirov/Documents/Lua-Projs/VerControl")
      lst:recItem("TrackAssemblyTool_GIT", "trackassembly", "en", "bg", "ru", "fr", "ja")
      lst:recItem("GearAssemblyTool", "gearassembly", "en", "bg")
      lst:recItem("Offset-Hoverballs-ME", "offset_hoverball", "en", "bg")
      lst:recItem("PhysPropertiesAdv", {"material_adv", "physprop_adv"}, "en", "bg")
      lst:recItem("PropCannonTool", "propcannon", "en", "bg")
      lst:recItem("SpinnerTool", "spinner", "en", "bg", "ja")
      lst:recItem("LaserSTool", "laseremitter", "en", "bg")
      lst:isItems()
 