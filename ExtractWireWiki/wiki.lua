local sExp = "wire_e2_piston_timing"

local sProg = "ExtractWireWiki/"
local wikilib = require(sProg.."lib/wikilib")

local API = require(sProg.."api/"..sExp)
local DSC = wikilib.readDescriptions(API)
local YTK = "u59E4rv-28E"

wikilib.setFormat("tfm", API.TYPE.FRM or "LOL") -- Type definition

local f, s = io.open(sProg.."out/wiki.md", "wb")
if(f) then io.output(f)
  wikilib.setInternalType(API)
  wikilib.updateAPI(API, DSC)
  wikilib.makeReturnValues(API)
  wikilib.printMatchedAPI(API, DSC)
  wikilib.printDescriptionTable(API, DSC, 1)
  wikilib.printDescriptionTable(API, DSC, 2)
  wikilib.printTypeTable(API)
  wikilib.printTypeReference(API)
  print(wikilib.getLocal())
  print(wikilib.getImage("http://www.famfamfam.com/lab/icons/flags/flags_preview_large.png", 8))
  for iD = 0, 3 do print(wikilib.getYoutubeVideo(YTK, iD)) end
else
  error("main.lua: File descriptopr fail: "..tostring(s))
end
