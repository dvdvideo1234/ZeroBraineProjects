local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase()

local sEOL  = "\n"
local sTool = "physprop_adv" -- Which tool definition to use. From folder `tools`
local sLibs = ""   -- Which library does the tool use

local fTool = "GmodToolTest/tools/%s.lua"
local fGmod = "dvdlualib/gmodlib.lua"
local fLibs = "dvdlualib/"..sLibs..".lua"
local bLibs = (tostring(sLibs or "") ~= "")
local I, O, G, L

I = assert(io.open(fTool:format(sTool), "rb"))
O = assert(io.open("GmodToolTest/tool.out", "wb"))
G = assert(io.open(fGmod, "rb"))
if(bLibs) then L = assert(io.open(fLibs, "rb")) end

if(not I) then error("No input file!"); return end
if(not O) then error("No output file!"); return end
if(not G) then error("No gmod file!"); return end
if(not L and bLibs) then error("No library file!"); return end

local fC, bS, sE
local sFile, sHead = I:read("*all"), ""
      sFile = sFile:gsub("%s+!", " not ")      -- Preprocessor for !
      sFile = sFile:gsub("||","or")            -- Preprocessor for ||
      sFile = sFile:gsub("&&","and")           -- Preprocessor for &&
      sFile = sFile:gsub("local%s+function%s+","function ") -- Local variables limit      
      
sHead = sHead.."----------------- BEGIN HEADER -----------------"..sEOL
if(bLibs) then
  sHead = sHead.."require(\"../"..fLibs:gsub("%.lua", "").."\")"..sEOL
else
  sHead = sHead.."require(\"../"..fGmod:gsub("%.lua", "").."\")"..sEOL
end
sHead = sHead.."SEVER  = true"..sEOL
sHead = sHead.."CLIENT = true"..sEOL
sHead = sHead.."local TOOL   = {Mode = \""..sTool.."\"}"  ..sEOL
sHead = sHead.."----------------- END HEADER -----------------"..sEOL

O:write(sHead..sFile)
O:flush()
O:close()
I:close()
G:close()

fC, sE = load(sHead..sFile)
if(not fC) then
  error(sE)
end

bS, sE = pcall(fC)
if(bS) then
  print("Pass OK")
else
  error("Fails NOK: "..sE)
end


