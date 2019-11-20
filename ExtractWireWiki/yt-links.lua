local sIDE = "E:/Documents/Lua-Projs/ZeroBraineIDE/"
package.path = package.path..";"..sIDE.."myprograms/?.lua"

local wikilib = require("lib/wikilib")

local bPreview = false
local sTubePat = "https://www%.youtube%.com/watch%?v="

local f = io.open("in/you-links.txt")
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
        print(tab[1], tab[2].."  ")
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