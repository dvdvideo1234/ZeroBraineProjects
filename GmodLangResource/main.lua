local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki",
                  "ZeroBraineProjects/GmodLangResource")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(2)

local key = "trackassembly"
local com = require("common")
local inf = require(key.."/info")
local pth = com.stringGetChunkPath():gsub("\\", "/")

for ing = 1, inf.lang.size do
  local I = assert(io.open(inf.sors:format(inf.lang[ing]), "rb"))
  if(not I) then return end
  local F = assert(load(I:read("*all"))); I:seek("set", 0)
  if(not F) then return end; S, F = pcall(F)
  if(not S) then error(F) end  
  local O = assert(io.open(inf.dest:format(pth, inf.lang[ing]), "wb"))
  if(not O) then I:Close(); return end
  local S, L = pcall(F, inf.tool, inf.limit)
  if(not S) then error(L) end
  local r = I:read("*line")
  while(r) do
    local s, e = r:find("%[.*%]")
    if(s and e) then
      local k = com.stringTrim(r:sub(s + 1, e - 1)):sub(2, -2)
      for idx = 1, inf.match.size do
        local n = k:lower()
        local s, e = n:find(inf.match[idx][1])
        if(s and e) then
          k = k:sub(1, s-1)..inf.match[idx][2]..k:sub(e+1, -1)
        end
      end
      if(L[k]) then
        O:write(k.."="..L[k]:gsub(":", "\\:"))
        O:write("\n")
      end
    end
    r = I:read("*line")
  end

  O:flush()
  O:close()
  I:close()
end