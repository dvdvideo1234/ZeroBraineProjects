package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local basepg = "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects"
local common = require("common")
common.addLibrary(basepg, "ExtractWireWiki", "dvdlualib")
local wikilib = require("lib/wikilib")

local tSetup =
{
  {"name"    , "Construction Props"},
  {"icon"    , "page.png"}, -- http://www.famfamfam.com/lab/icons/silk/preview.php
  {"parentid", 0},
  {"id"      , 1},
  {"version" , 3},
  ["contents"] = {
    Size = 0,
    Header =
    {
      ["models/keycardspawner/keycardspawner.mdl"] = "Test"
    }
  }
}

local function getModel(m)
  return 
  {
    {"type" , "model"},
    {"model", m},
  }
end

local function getHeader(h)
  return 
  {
    {"type", "header"},
    {"text", h}
  }
end

local function writeQuoted(sM, bN)
  local sN = (bN and "\n" or "")
  io.write("\""..sM.."\""..sN)
end

local function writeTab(nT)
  for iD = 1, nT do io.write("\t") end
end

local function formatData(vSet)
  local k, v = vSet[1], vSet[2]
  if(k == "icon") then
    v = common.stringGetFileName(v)
    v = common.stringStripExtension(v)
    v = ("icon16/%s.png"):format(v)
  end
  return k, v
end

local function listModelsRecurse(tS, tC)
  for iD = 1, #tS.cont do local v = tS.cont[iD]
    if(v.size == "<DIR>") then
      listModelsRecurse(v.root, tC)
    else
      local e = common.stringGetExtension(v.name)
      if(e and e == "mdl") then
        local d = common.normFolder(tS.base)
        local m = (d..v.name):match("models/.*$")
        if(m) then
          tC.Size = tC.Size + 1
          tC[tC.Size] = m
        end
      end
    end
  end
end

local function listModels(sD, tC) 
  local tC = (common.isTable(tC) and tC or {Size = 0})
  if(not tC.Size) then tC.Size = 0 end
  local tS = wikilib.folderReadStructure(sD)
  listModelsRecurse(tS, tC)
  return tC
end

local function writeEntry(iN, iD, tE)
  writeTab(iN); writeQuoted(iD, true)
  writeTab(iN); io.write("}\n"); iN = iN + 1
  for iM = 1, #tE do local v = tE[iM]
    writeTab(iN); writeQuoted(v[1] or "")
    writeTab(2); writeQuoted(v[2] or "", true)
  end; iN = iN - 1
  writeTab(iN); io.write("}\n")
end

local sSVN = "wire-extras"
 
local sD = common.normFolder("E:/Documents/Lua-Projs/SVN/"..sSVN)
local fO, oE = io.open("out/"..sSVN:lower()..".txt", "wb")
if(fO) then io.output(fO)
  local tC = tSetup["contents"]
  local iD, iN, iE = 1, 1, 1
  local tL = listModels(sD, tSetup["contents"])
  table.sort(tL)
  writeQuoted("TableToKeyValues", true)
  io.write("{\n")
  while(tSetup[iD]) do local vSet = tSetup[iD]
    local k, v = formatData(vSet)
    writeTab(iN)
    writeQuoted(k)
    writeTab(2)
    writeQuoted(v, true)
    iD = iD + 1
  end
  writeTab(iN); writeQuoted("contents", true)
  writeTab(iN); io.write("{\n"); iN = iN + 1
  for iD = 1, tL.Size do local m = tL[iD]
    if(tC.Header[m]) then
      local h = tC.Header[m]
      writeEntry(iN, iE, getHeader(h))
      iE = iE + 1
    end
    writeEntry(iN, iE, getModel(m))
    iE = iE + 1
  end
  iN = iN - 1; writeTab(iN); io.write("}\n")
  io.write("}\n")
  fO:flush()
  fO:close()
else
  error("Output error: "..oE)
end
