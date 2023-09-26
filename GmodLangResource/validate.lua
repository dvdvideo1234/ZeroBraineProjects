local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)
      
local prop = require("gmodlib/custom/properties")
local lst = prop.newList()
      lst:setBase("D:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons")
      lst:recItem("TrackAssemblyTool_GIT", "trackassembly", "en", "bg", "ru", "fr", "ja")
      lst:recItem("GearAssemblyTool_GIT", "gearassembly", "en", "bg")
      lst:recItem("Offset-Hoverballs", "offset_hoverball", "en", "bg")
      lst:recItem("PhysPropertiesAdv", {"material_adv", "physprop_adv"}, "en", "bg")
      lst:recItem("PropCannonTool_GIT", "propcannon", "en")
      lst:recItem("SpinnerTool", "spinner", "en", "bg", "ja")
      lst:recItem("LaserSTool", "laseremitter", "en", "bg")
      lst:isItems()
 