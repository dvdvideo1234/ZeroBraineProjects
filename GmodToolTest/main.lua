local szbIDE = "D:/LuaIDE"
package.path = package.path..";"..szbIDE.."/myprograms/?.lua"

local sEOL  = "\n"
local sTool = "gearassembly"
local nLibs = "gearasmlib"

local fTool = "GmodToolTest/tools/%s.lua"
local fGmod = "dvdlualib/gmodlib.lua"
local fLibs = "dvdlualib/"..nLibs..".lua"

local I = assert(io.open(fTool:format(sTool), "rb"))
local O = assert(io.open("GmodToolTest/tool.out", "wb"))
local G = assert(io.open(fGmod, "rb"))
local L = assert(io.open(fLibs, "rb"))

if(not I) then return end
if(not O) then return end
if(not G) then return end
if(not L) then return end

local sFile, sHead = I:read("*all"), ""
      sFile = sFile:gsub("%s+!", " not ")      -- Preprocessor for !
      sFile = sFile:gsub("||","or")            -- Preprocessor for ||
      sFile = sFile:gsub("&&","and")           -- Preprocessor for &&
local sGmod = G:read("*all"):gsub("%s+$",sEOL) -- Convert line endings to [sEOL]
local sLibs = L:read("*all"):gsub("%s+$",sEOL) -- Convert line endings to [sEOL]

sLibs = sLibs:gsub("function%s", "function "..nLibs..".")
sLibs = sLibs:gsub("local%sfunction%s"..nLibs.."%.", "local function ")

sHead = sHead.."----------------- BEGIN HEADER -----------------"..sEOL
sHead = sHead..sGmod..sEOL
sHead = sHead..sLibs..sEOL
sHead = sHead.."local SEVER  = true"..sEOL
sHead = sHead.."local CLIENT = true"..sEOL
sHead = sHead.."local TOOL   = {}"  ..sEOL
sHead = sHead.."----------------- END HEADER -----------------"..sEOL

O:write(sHead..sFile)
O:flush()
O:close()
I:close()
G:close()

local fCode = assert(load(sHead..sFile))
local bS, sE = pcall(fCode)
if(bS) then
  print("Pass OK")
else
  error("Fails NOK: "..sE)
end
