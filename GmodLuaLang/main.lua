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
local ser = "GmodLuaLang/"
local tAb = {Size = 0, ID = 0}
local sNL = "\n"
--[[
  1. Populate the source file as input
  2. Update the mix file with your translations
  3. Write mixed content in the output file
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
  local fI = assert(io.open(ser.."in.txt"))
  local fO = assert(io.open(ser.."out.txt", "w"))
  local rI = fI:read("*line")
  while(rI) do
    fO:write(rI..sNL)
    if(rI:find("^%s*%[\"en\"%]")) then
      local sI = tostring(rI:match("^%s+"))
      print(tAb.ID, "<"..sI..">: ", rI)
      fO:write(sI..tAb[tAb.ID]..sNL)
      tAb.ID = tAb.ID + 1
    end
    rI = fI:read("*line")
  end
  fI:close()
  fO:flush()
  fO:close()
end
