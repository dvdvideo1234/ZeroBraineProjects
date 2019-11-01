local sEXP = "ftrace"

local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE/"
-- local sPRG = "ExtractWireWiki/" -- From the main folder
local sPRG = "" -- From the project folder

package.path = package.path..";"..sIDE.."myprograms/?.lua"

local wikilib = require(sPRG.."lib/wikilib")
local common  = require("common")

wikilib.setDescriptionChunk(
[[
local E2Helper = {Descriptions = {}}
]],
[[
return E2Helper.Descriptions
]],
"E2Helper.Descriptions"
)

local API = require(sPRG.."api/"..sEXP)
local DSC = wikilib.readDescriptions(API)

local YTK = "pl12yIDPm3M"

wikilib.setBaseFolder([[E:\Documents\Lua-Projs\ZeroBraineIDE\ZeroBraineProjects\ExtractWireWiki]])

wikilib.setFormat("tfm", API.TYPE.FRM or "LOL") -- Type definition

local f, s = io.open(sPRG.."out/wiki.md", "wb")
if(f) then io.output(f)
  wikilib.writeBOM("UTF8")
  wikilib.setInternalType(API)
  wikilib.updateAPI(API, DSC)
  wikilib.makeReturnValues(API)
  wikilib.printMatchedAPI(API, DSC)
  if(type(API.TEXT) == "function") then
    local bS, sT = pcall(API.TEXT)
    if(not bS) then error("Header taxt fail: "..sT.." !") end
    io.write(tostring(sT or "").."\n")
  end
  for iD = 1, #API.POOL do
    if(API.POOL[iD][1]) then
      wikilib.printDescriptionTable(API, DSC, iD)
    end
  end
  -- wikilib.printTypeTable(API)
  wikilib.printTypeReference(API)
  print(wikilib.insRefCountry("bg"))
  print(wikilib.insType("s"))
  print(wikilib.insImage("http://www.famfamfam.com/lab/icons/flags/flags_preview_large.png", 8))
  for iD = 0, 3 do print(wikilib.insYoutubeVideo(YTK, iD)) end
else
  error("main.lua: File descriptopr fail: "..tostring(s))
end
