local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(1)

local com = require("common")

local sEXP = "ftrace"

local wikilib = require("wikilib")
local API = require("api/"..sEXP)
local DSC = wikilib.readDescriptions(API)
local sProj = "/ZeroBraineProjects/ExtractWireWiki"

local YTK = "pl12yIDPm3M"

local sB = com.normFolder(dir.getBase()..sProj)
local f, s = io.open(sB.."out/wiki.md", "wb")
if(f) then io.output(f)
  if(API) then
    local tyF = type(API.FLAG)
    if(tyF == "table") then
      wikilib.setFlags(API.FLAG)
    elseif(tyF == "function") then
      local bS, tF = pcall(API.FLAG); if(bS) then
        wikilib.setFlags(tF)
      else error("main.lua: API flag: "..tF) end
    else
      wikilib.isFlag("erro", true)
    end
    wikilib.setFormat("tfm", API.TYPE.FRM or "LOL") -- Type definition
    if(DSC) then
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
      wikilib.printTokenReferences()
      print(wikilib.insRefCountry("bg"))
      print(wikilib.insType("s"))
      print(wikilib.insImage("http://www.famfamfam.com/lab/icons/flags/flags_preview_large.png"))
      for iD = 0, 3 do print(wikilib.insYoutubeVideo(YTK, iD)) end
    else
      error("main.lua: DSC missing: "..sEXP)
    end  
  else
    error("main.lua: API missing: "..sEXP)
  end
else
  error("main.lua: File descriptopr fail: "..tostring(s))
end
