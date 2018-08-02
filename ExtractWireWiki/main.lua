local sExp = "trackasmlib"

local sProg = "ExtractWireWiki/"
local wikilib = require(sProg.."lib/wikilib")

local API = require(sProg.."api/"..sExp)
local DSC = require(sProg.."api/cl_"..sExp)

wikilib.setFormat("tfm", API.TYPE.FRM or "LOL") -- Type definition

local f, s = io.open(sProg.."out.md", "wb")
if(f) then io.output(f)
  wikilib.setInternalType(API)
  wikilib.updateAPI(API, DSC)
  wikilib.makeReturnValues(API)
  wikilib.printMatchedAPI(API, DSC)
  wikilib.printDescriptionTable(API, DSC, 1)
  wikilib.printDescriptionTable(API, DSC, 2)
 -- wikilib.printTypeTable(API)
  wikilib.printTypeReference(API)
  print(wikilib.getVideo("qd3XQF-wNN0"))
else
  error("main.lua: File descriptopr fail: "..tostring(s))
end
