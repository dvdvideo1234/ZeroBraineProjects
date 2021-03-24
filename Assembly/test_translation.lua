local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/LuaIDE")
      dir.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(1)

local com = require("common")
local cpx = require("complex")
require("dvdlualib/trackasmlib")
local asmlib = trackasmlib
asmlib.InitBase("track","assembly")
asmlib.SetLogControl(1000, false)

local function readTranslation(sK)
  local tR = require("Assembly/data/lang_"..sK)
  local bS, tI = pcall(tR, "assembly", "tracks")
  if(not bS) then error("Compilation: "..tI) end
  print("Repeat check started ("..sK..")...")
  local t, tL = os.clock(), {}; tI.Hash = tL
  for ID = 1, #tI do
    local key = com.stringTrim(tI[ID][1])
    if(not tL[key]) then
      tL[key] = 1
    else
      tL[key] = tL[key] + 1
    end
  end
  for k, v in pairs(tL) do
    if(v > 1) then print(k, v) end
  end
  print("Repeat hash complete("..sK..")... "..((os.clock()-t)*1000000).."us")
  return tI
end

local function compareTranslation(sT)
  local tE = readTranslation("en")
  local tT = readTranslation(sT)  
  for iD = 1, #tE do
    local vE, vT = tE[iD], tT[iD]
    if(vE[1] ~= vT[1]) then
      error("Translation misplaced: ["..vE[1].."] > ["..vT[1].."]")
    end
  end
  
  
end


compareTranslation("tr")


