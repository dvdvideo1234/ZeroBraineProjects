local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

local wikilib = require("dvdlualib/wikilib")

local bPreview = true
local sTubePat = "https://www%.youtube%.com/watch%?v="

local f = assert(io.open("ExtractWireWiki/in/you-links.txt"))
if(f) then
  local sRow, iRow = f:read("*line"), 0
  while(sRow) do iRow = iRow + 1
    if(sRow:find("google") and wikilib.isEncodedURL(sRow)) then
      sRow = wikilib.getDecodeURL(sRow)
      local s, e = sRow:find(sTubePat)
      sRow = sRow:sub(1,1)..sRow:sub(s, e + 11)
    end
    -----------------------------------------
    sRow = sRow:gsub(sTubePat, "/")
    tab = wikilib.common.stringExplode(sRow, "/")
    if(tab[2]) then
      if(bPreview) then
        print("aaa", tab[1], tab[2].."  ")
        for iD = 1, 3 do print(wikilib.insYoutubeVideo(tab[2], iD)) end
      else local sOut = wikilib.insYoutubeVideo(tab[2], tab[1])
        print(((iRow % 3) == 0) and sOut.."  " or sOut)
      end
    else
      print(sRow)
    end
    -----------------------------------------
    sRow = f:read("*line")
  end
end

--[[

[![](http://img.youtube.com/vi/1rsDHU79J50/3.jpg)](http://www.youtube.com/watch?v=1rsDHU79J50 "." ---

]]
