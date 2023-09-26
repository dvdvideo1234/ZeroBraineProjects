local tP = {
  Base = "D:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/",
  Prop = "resource/localization/",
  {
    Dir  = "TrackAssemblyTool_GIT",
    Name = {"trackassembly"},
    Tran = {"en", "bg", "ru", "fr", "ja"}
  },
  {
    Dir  = "GearAssemblyTool_GIT",
    Name = {"gearassembly"},
    Tran = {"en", "bg"}
  },
  {
    Dir  = "Offset-Hoverballs",
    Name = {"offset_hoverball"},
    Tran = {"en", "bg"}
  },
  {
    Dir  = "PhysPropertiesAdv",
    Name = {"material_adv", "physprop_adv"},
    Tran = {"en", "bg"}
  },     
  {
    Dir  = "PropCannonTool_GIT",
    Name = {"propcannon"},
    Tran = {"en"}
  },  
  {
    Dir  = "SpinnerTool",
    Name = {"spinner"},
    Tran = {"en", "bg", "ja"}
  },    
  {
    Dir  = "LaserSTool",
    Name = {"laseremitter"},
    Tran = {"en", "bg"}
  }
}; tP.Size = #tP

for i = 1, tP.Size do
  local v = tP[i]
  v.Name.Size = #v.Name
  v.Tran.Size = #v.Tran
end

return tP
