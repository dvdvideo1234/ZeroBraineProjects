local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)
      
local com = require("common")

local sB = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl"
local sN = "GearAssemblyTool/lua/gearassembly/gearasmlib.lua"
local sC = com.stringGetChunkPath():gsub("\\","/")

local fI = assert(io.open(sB.."/"..sN, "rb"))
local fO = assert(io.open(sC..com.stringGetFileName(sN), "wb"))

local tF = {
  __FName = ""
}

tF["%s*function%s+%w+%s*%("] =  function(l, s, e)
  local o = l:sub(s, e)
        o = o:gsub("function", "")
        o = o:sub(1, -2)   
  tF.__FName = com.stringTrim(o)
  return l
end

tF["return%s+StatusLog"] = function(l, s, e)
  local cs = l:sub(1, s - 1)
  local ce = l:sub(e + 1, -1)
  local bs, be = ce:find("%(.+%)")
  if(bs and be) then
    local br = ce:sub(bs + 1, be - 1)
    print(br, ">", l)
  end
  
  
  return l
end

local sD = fI:read("*line")
local sF = "" -- Function name

while(sD) do
  for k, v in pairs(tF) do
    local s, e = sD:find(k)
    if(k:sub(1,1) ~= "_" and s and e) then
      local sT = type(v)
      if(sT == "function") then
        local ok, out = pcall(v, sD, s, e)
        if(ok) then sD = out else
          error("Execution error: "..out)
        end
      end
    end
  end
  fO:write(sD.."\n")
  sD = fI:read("*line")
end


fO:flush()
fO:close()
fI:close()
