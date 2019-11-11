local sEXP = "prop"

local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE"
local fIDE = "/%s/?.lua"
local tIDE = 
{
  "myprograms",
  "ExtractWireWiki/lib"
}; for k, v in ipairs(tIDE) do package.path = package.path..";"..sIDE..fIDE:format(v) end

local wikilib = require("lib/wikilib")
local common  = require("common")

local API = require(sPRG.."api/"..sEXP)
local DSC = wikilib.readDescriptions(API)

local YTK = "pl12yIDPm3M"

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
  wikilib.printLinkReferences(API)
  print(wikilib.insRefCountry("bg"))
  print(wikilib.insType("s"))
  print(wikilib.insImage("http://www.famfamfam.com/lab/icons/flags/flags_preview_large.png", 8))
  for iD = 0, 3 do print(wikilib.insYoutubeVideo(YTK, iD)) end
else
  error("main.lua: File descriptopr fail: "..tostring(s))
end
