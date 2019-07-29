local sEXP = "fsensor"

local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE/"
-- local sPRG = "ExtractWireWiki/" -- From the main folder
local sPRG = "" -- From the project folder

package.path = package.path..";"..sIDE.."myprograms/?.lua"

local wikilib = require(sPRG.."lib/wikilib")
local common  = require("common")
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
  wikilib.printDescriptionTable(API, DSC, 1)
  wikilib.printDescriptionTable(API, DSC, 2)
 -- wikilib.printTypeTable(API)
  wikilib.printTypeReference(API)
  print(wikilib.insRefCountry("bg"))
  print(wikilib.insType("s"))
  print(wikilib.insImage("http://www.famfamfam.com/lab/icons/flags/flags_preview_large.png", 8))
  for iD = 0, 3 do print(wikilib.insYoutubeVideo(YTK, iD)) end
else
  error("main.lua: File descriptopr fail: "..tostring(s))
end
