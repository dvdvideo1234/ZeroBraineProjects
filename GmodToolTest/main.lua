package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local sEOL  = "\r\n"
local sTool = "wire_dupeport"

local fTool = "GmodToolTest/tools/%s.lua"
local fGmod = "dvdlualib/gmodlib.lua"

local I = assert(io.open(fTool:format(sTool), "rb"))
local O = assert(io.open("GmodToolTest/tool.out", "wb"))
local G = assert(io.open(fGmod, "rb"))

if(not I) then return end
if(not O) then return end
if(not G) then return end

local sFile, sHead = I:read("*all"), ""
      sFile = sFile:gsub("%s+!", " not ")      -- Preprocessor for !
      sFile = sFile:gsub("||","or")            -- Preprocessor for ||
      sFile = sFile:gsub("&&","and")           -- Preprocessor for &&
local sGmod = G:read("*all"):gsub("%s+$",sEOL) -- Convert line endings to [sEOL]

sHead = sHead.."----------------- BEGIN HEADER -----------------"..sEOL
sHead = sHead..sGmod..sEOL
sHead = sHead.."local SEVER  = true"..sEOL
sHead = sHead.."local CLIENT = true"..sEOL
sHead = sHead.."local TOOL   = {}"  ..sEOL
sHead = sHead.."----------------- END HEADER -----------------"..sEOL

O:write(sHead..sFile)
O:flush()
O:close()
I:close()
G:close()

assert(load(sHead..sFile))()
