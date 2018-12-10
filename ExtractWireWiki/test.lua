local a = "[`..`](https://github.com/dvdvideo1234/PhysPropertiesAdv/blob/master/data/physprop_adv/materials/..)"
local b = "[`..`](https://github.com/dvdvideo1234/PhysPropertiesAdv/blob/master/data/physprop_adv)"
local c = a:gsub("/%.%.%)",""):match("(.*[/\\])"):sub(1,-2)..")"
print(b==c)