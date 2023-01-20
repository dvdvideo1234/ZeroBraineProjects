local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local pCom = "%-%-%-*" -- Single line comment
local pMcs = "%-%-%[=*%[" -- Multi-line start
local pMce = "%]=*%]" -- Multi-line start
local src = "C:/Users/ddobromirov/Documents/Lua-Projs/SVN/LaserSTool/lua/autorun/laserlib.lua"

local f = assert(io.open(src, "r"))
if(not f) then return end
local o = assert(io.open("ExtractComments/comments.lua", "w"))
if(not o) then return end
local idx, rec = 0, false
local row = f:read("*line")

local function write(s, w)
  local n = true
  if(n) then
    s:write("["..idx.."] "..tostring(w).."\n")
  else
    s:write(tostring(w).."\n")
  end
end

while(row) do
  idx = idx + 1
  
  local ss, se = row:find(pCom)
  if(ss and se) then
    local ms, me = row:find(pMcs, ss)
    
    if(ms and me) then
      if(ms == ss) then
        rec = true
      else
        error("Wrong comment syntax: "..row)
      end
    else
      write(o, row:sub(ss, -1))
    end
  end
    
  if(rec) then
    local cs, ce = row:find(pMce)
    if(cs and ce) then
      write(o, row:sub(1, ce))
      rec = false
    else
      write(o, row)
    end
  end
  
  row = f:read("*line")
end

f:close()
o:flush()
o:close()
