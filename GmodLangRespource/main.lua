local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase()

local com = require("common")

local lang = "en"

local tMatch = {
  {"\"%.%..*tool.*%.%.\"", "trackassembly"},
  {"\"%.%..*lim.*%.%.\"", "asmtracks"},
  {"\"%.%..*lim%S+", "asmtracks"}
}; tMatch.Size = #tMatch

local src = "C:/Users/ddobromirov/Documents/Lua-Projs/SVN/TrackAssemblyTool_GIT/lua/trackassembly/lang/"..lang..".lua"
local pth = com.stringGetChunkPath()
local I = assert(io.open(src, "rb"))
if(not I) then return end
local F = assert(load(I:read("*all"))); I:seek("set", 0)
if(not F) then return end; S, F = pcall(F)
if(not S) then error(F) end  
local O = assert(io.open(pth:gsub("\\", "/")..tMatch[1][2]..".properties", "wb"))
if(not O) then I:Close(); return end
local S, L = pcall(F, tMatch[1][2], tMatch[2][2])
if(not S) then error(L) end
local r = I:read("*line")
while(r) do
  local s, e = r:find("%[.*%]")
  if(s and e) then
    local k = com.stringTrim(r:sub(s + 1, e - 1)):sub(2, -2)
    for idx = 1, tMatch.Size do
      local n = k:lower()
      local s, e = n:find(tMatch[idx][1])
      if(s and e) then
        k = k:sub(1, s-1)..tMatch[idx][2]..k:sub(e+1, -1)
      end
    end
    O:write(k.."="..L[k]:gsub(":", "\\:"))
    O:write("\n")
  end
  r = I:read("*line")
end

O:flush()
O:close()
I:close()
