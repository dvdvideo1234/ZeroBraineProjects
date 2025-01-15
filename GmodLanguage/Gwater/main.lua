local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local ext = false -- Generate extraction file
local tok = {"^\".+\"=%[%[",  "^%]%]" , "#$#"}
local com = require("common")
local ser = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/gwater2/data_static/gwater2/locale"

local fN = ser.."/gwater2_en.txt"
local bS, fI = pcall(io.open, fN, "r")
if(not bS) then error("Open error: "..fI) end
if(not fI) then error("File error: "..fN) end

if(ext) then
  local fN = com.stringGetChunkPath().."ext.txt"
  local bS, fA = pcall(io.open, fN, "w")
  if(not bS) then error("Open error: "..fA) end
  if(not fA) then error("File error: "..fN) end

  local bW = false
  local rI = fI:read("*line")
  while(rI) do
    if(rI:find(tok[1])) then
      fA:write(rI..tok[3])
      bW = true
    elseif(rI:find(tok[2])) then
        fA:write(rI.."\n")
        bW = false
    else
      if(bW) then
        fA:write(rI..tok[3])
      end
    end 

    rI = fI:read("*line")
  end
  
  fA:flush()
  fA:close()
  
  print("Extraction prepared in: "..fN)
  return
else
  local eA = {iC = 0, iS = 0, Key = {}, Data = {}};
  local fN, bS, fE = com.stringGetChunkPath().."new.txt"
        bS, fE = pcall(io.open, fN, "r")
  if(not bS) then error("Open error: "..fE) end
  if(not fE) then error("File error: "..fN) end 
  
  local rE = fE:read("*line")
  while(rE) do
    local nS, nE = rE:find(tok[1])
    if(nS and nE) then
      eA.iS = eA.iS + 1
      eA.Data[eA.iS] = rE:gsub(tok[3], "\n")
      print("G", eA.iS, rE:sub(nS, nE))
      eA.Key[rE:sub(nS, nE)] = eA.iS
      rE = fE:read("*line")
    end
  end
  
  fE:close()
  
  local fN = ser.."/gwater2_bg.txt"
  local bS, fO = pcall(io.open, fN, "w")
  if(not bS) then error("Open error: "..fI) end
  if(not fO) then error("File error: "..fN) end

  local bW = false

  local rI = fI:read("*line")
  while(rI) do 
    local iD = eA.Key[rI]
    local sT = eA.Data[iD]
    if(eA.Key[rI]) then
      bW = true
      fO:write(sT.."\n")
    elseif(rI:find(tok[2])) then
      if(not bW) then
        fO:write(rI.."\n")
      end
      bW = false
    else
      if(not bW) then
        fO:write(rI.."\n")
      end
    end
    rI = fI:read("*line")
  end
  fO:flush()
  fO:close()
end

fI:close()