local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE"
local fIDE = "/%s/?.lua"
local tIDE = 
{
  "myprograms",
  "ExtractWireWiki/lib"
}; for k, v in ipairs(tIDE) do package.path = package.path..";"..sIDE..fIDE:format(v) end

local wikilib = require("lib/wikilib")
local common  = require("common")

wikilib.setDecoderURL("UTF-8")

local url = "https://github.com/wiremod/wire/blob/master/materials/expression%202"

print(wikilib.getDecodeURL(url))
print("-------------------------------------")
common.addLibrary(sIDE, tIDE)
