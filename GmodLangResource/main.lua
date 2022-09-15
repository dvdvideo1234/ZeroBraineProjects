local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki",
                  "ZeroBraineProjects/GmodLangResource")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase()

-- Manual stuff
local nam = "trackassembly"

-- Automatic stuff
local com = require("common")
local inf = require(nam.."/info")
local bas, key = inf.lang[1]
local pth = dir.getNorm(com.stringGetChunkPath())
local res = pth.."/"..nam.."/resource/localization"

dir.ersDir("resource", pth.."/"..nam)
dir.newDir("resource", pth.."/"..nam)
dir.newDir("localization", pth.."/"..nam.."/resource")

com.timeDelay(0.5)

-- Automatic loop
for ing = 1, inf.lang.size do
  local eng = inf.lang[ing]; dir.newDir(eng, res)
  local I = assert(io.open(inf.sors:format(pth, eng), "rb"))
  if(not I) then return end
  local F = assert(load(I:read("*all"))); I:seek("set", 0)
  if(not F) then return end; S, F = pcall(F)
  if(not S) then error(F) end  
  local O = assert(io.open(inf.dest:format(pth, eng), "wb"))
  if(not O) then I:Close(); return end
  local S, L = pcall(F, inf.tool, inf.limit)
  if(not S) then error(L) end
  if(eng == bas) then
    if(ing == 1) then key = L else
      error("Primary key ["..ing.."] mismatch: "..eng) end
  end
  local r = I:read("*line")
  while(r) do
    local s, e = r:find("%[.*%]%s*=%s*")
    if(s and e) then
      local k = com.stringTrim(r:sub(s + 1, e - 1))
            k = com.stringTrim(k)
            k = com.stringTrim(k, "=")
            k = com.stringTrim(k)
            k = com.stringTrim(k, "%]")
            k = com.stringTrim(k, "%[")
            k = com.stringTrim(k)
            k = com.stringTrim(k, "\"")
      for idx = 1, inf.match.size do
        local n = k:lower()
        local s, e = n:find(inf.match[idx][1], 1, true)
        if(s and e) then
          k = k:sub(1, s-1)..inf.match[idx][2]..k:sub(e+1, -1)
        end
      end
      if(L[k]) then
        if(key[k]) then
          O:write(k.."="..L[k]:gsub(":", "\\:"))
          O:write("\n")
        else
          error("Base ["..bas.."] key ["..eng.."] missing ["..k.."]!")
        end
      else
        if(not key[k]) then
          error("Miss ["..bas.."] key ["..eng.."] missing ["..k.."]!")
        end
      end
    end
    r = I:read("*line")
  end

  O:flush()
  O:close()
  I:close()
end