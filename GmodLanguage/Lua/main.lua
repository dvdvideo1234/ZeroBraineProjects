local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(1)

local com = require("common")
local ser = "GmodLanguage/Lua/"
local tAb = {Size = 0, ID = 0}
local sNL = "\n"
--[[
  1. Copy the file being translated into IN
  2. Empty the MIX file traslation sources
  3. Run the program to generate the MIX file
  4. Translate the MIX file by known methods
  5. Run the program again to generate the OUT file
]]

local fM = assert(io.open(ser.."mix.txt"))
local rL = fM:read("*line")
while(rL) do
  tAb.Size = tAb.Size + 1
  tAb[tAb.Size] = com.stringTrim(rL)
  print(com.stringPadL(tostring(tAb.Size), 6, " "), tAb[tAb.Size])
  rL = fM:read("*line")
end
fM:close()

if(tAb.Size > 0) then tAb.ID = 1
  print("Base translation present. Processing...")
  local fI = assert(io.open(ser.."in.txt"))
  local fO = assert(io.open(ser.."out.txt", "w"))
  local rI = fI:read("*line")
  while(rI) do
    fO:write(rI..sNL)
    if(rI:find("^%s*%[\"en\"%]")) then
      local sI = tostring(rI:match("^%s+"))
      fO:write(sI..tAb[tAb.ID]..sNL)
      tAb.ID = tAb.ID + 1
    end
    rI = fI:read("*line")
  end
  fI:close()
  fO:flush()
  fO:close()
else
  print("Base translation are missing. Generating...")
  local fI = assert(io.open(ser.."in.txt"))
  local fM = assert(io.open(ser.."mix.txt", "w"))
  local rI = fI:read("*line")
  while(rI) do
    if(rI:find("^%s*%[\"en\"%]")) then
      local sT = com.stringTrim(rI)
      fM:write(sT..sNL)
    end
    rI = fI:read("*line")
  end
  fI:close()
  fM:flush()
  fM:close()
end
