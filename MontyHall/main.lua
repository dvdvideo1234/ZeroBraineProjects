local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(1)

io.stdout:setvbuf('no')

local common = require("common")

local tData = {
  {Item = "goat", Open = false},
  {Item = "goat", Open = false},
  {Item = "goat", Open = false}
}; tData.Size = #tData

tData[common.randomGetNumber(3)].Item = "car" 

print("Pick a door!")

local iPick = io.read("*n")
if(tData[iPick]) then
  print("You picked door "..iPick.."!")
else
  while(not tData[iPick]) do
    print("There is no such door!")
    iPick = io.read("*n")
  end
end

local iShow = common.randomGetNumber(3)
while(tData[iShow].Item == "car") do
  iShow = common.randomGetNumber(3)
end

tData[iShow].Open = true

print("Goat behind door "..iShow.."!")
print("Do you want to switch (Y/N)?"); io.read("*l")

local sSwap = io.read("*l")
      sSwap = tostring(sSwap or "Y"):sub(1,1):upper()
if(sSwap ~= "Y" and sSwap ~= "N") then
  while(sSwap ~= "Y" and sSwap ~= "N") do
    print("Wrong answer ["..sSwap.."] try again!")
    sSwap = tostring(io.read("*l") or "Y"):sub(1,1):upper()
  end
end

if(sSwap == "Y") then
  for iD = 1, tData.Size do
    if(not tData[iD].Open and iD ~= iPick) then
      print("You 1 have won a ["..tData[iD].Item.."]!")
    end
  end
else
  print("You 2 have won a ["..tData[iPick].Item.."]!")
end
