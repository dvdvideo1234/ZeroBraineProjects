local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE/"
package.path = package.path..";"..sIDE.."myprograms/?.lua"

local wikilib = require("lib/wikilib")
local common  = require("common")

local url = "https://webcache.googleusercontent.com/search?q=cache:GDU8ifER8EgJ:https://steamcommunity.com/sharedfiles/filedetails/%3Fid%3D114297900+&cd=1&hl=en&ct=clnk&gl=bg&client=firefox-b-d"

print(wikilib.getDecodeURL(url))

print(common.toBool(-4))