local common = require("common")
local wikilib = require("wikilib")

local spawnlib = {}
local metaSpawnlib = {}
metaSpawnlib.__indent = 0
metaSpawnlib.__ientry = 0
metaSpawnlib.__icofmt = "icon16/%s.png"
metaSpawnlib.__chkkey = {["needsapp"] = true}
metaSpawnlib.__indstr = "\t"

function spawnlib.getModel(m)
  return 
  {
    {"type" , "model"},
    {"model", m},
  }
end

function spawnlib.getHeader(h)
  return 
  {
    {"type", "header"},
    {"text", h}
  }
end

function spawnlib.writeQuoted(sM, bN)
  local sN = (bN and "\n" or "")
  io.write("\""..sM.."\""..sN)
end

function spawnlib.writeTab(nT)
  for iD = 1, nT do io.write(metaSpawnlib.__indstr) end
end

function spawnlib.setIconFormat(sF)
  metaSpawnlib.__icofmt = tostring(sF)
end

function spawnlib.formatData(tS)
  if(not common.isTable(tS)) then return "", "" end
  local k, v = tostring(tS[1] or ""), tS[2]
        k = tostring(k or "")
        k = common.stringTrim(k)
  if(not common.isTable(v)) then
    v = tostring(v or "")
    v = common.stringTrim(v)
    if(k == "") then
      error("spawnlib.formatData: Missing key for <"..v..">") end
    if(k == "icon") then
      v = common.stringGetFileName(v)
      v = common.stringStripExtension(v)
      v = metaSpawnlib.__icofmt:format(v)
    end
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

function spawnlib.getModels(sD, tC) 
  local tC = (common.isTable(tC) and tC or {Size = 0})
  if(not tC.Size) then tC.Size = 0 end
  local tS = wikilib.folderReadStructure(sD)
  listModelsRecurse(tS, tC)
  return tC
end

function spawnlib.writeIndent()
  spawnlib.writeTab(metaSpawnlib.__indent)
end

function spawnlib.writeBracket(sB)
  if(sB == "{") then
    spawnlib.writeIndent(); io.write(sB.."\n")
    metaSpawnlib.__indent = metaSpawnlib.__indent + 1
  elseif(sB == "}") then
    metaSpawnlib.__indent = metaSpawnlib.__indent - 1
    spawnlib.writeIndent(); io.write(sB.."\n")
  else
    error("spawnlib.writeBracket: There is no such bracket <"..sB..">")
  end
end

function spawnlib.writeEntry(tE)
  spawnlib.writeIndent()
  metaSpawnlib.__ientry = metaSpawnlib.__ientry + 1
  spawnlib.writeQuoted(metaSpawnlib.__ientry, true)
  spawnlib.writeBracket("{")
  for iE = 1, #tE do local v = tE[iE]
    spawnlib.writeIndent()
    spawnlib.writeQuoted(v[1] or "")
    spawnlib.writeTab(2)
    spawnlib.writeQuoted(v[2] or "", true)
  end
  spawnlib.writeBracket("}")
end

function spawnlib.writeTable(tC)
  spawnlib.writeIndent()
  spawnlib.writeQuoted("TableToKeyValues", true)
  spawnlib.writeBracket("{")
  local tCh = metaSpawnlib.__chkkey
  for iD = 1, #tC do
    local k, v = spawnlib.formatData(tC[iD])
    if(not common.isTable(v)) then
      if(not (common.isDryString(v) and tCh[k])) then
        spawnlib.writeIndent()
        spawnlib.writeQuoted(k)
        spawnlib.writeTab(2)
        spawnlib.writeQuoted(v, true)
      end
    else
      spawnlib.writeIndent()
      spawnlib.writeQuoted(k, true)
      spawnlib.writeBracket("{")
      for iM = 1, #v do
        spawnlib.writeIndent()
        spawnlib.writeQuoted(iM, true)
        spawnlib.writeBracket("{")
        for iK = 1, #v[iM] do
          local k, v = spawnlib.formatData(v[iM][iK])
          spawnlib.writeIndent()
          spawnlib.writeQuoted(k)
          spawnlib.writeTab(2)
          spawnlib.writeQuoted(v, true)
        end
        spawnlib.writeBracket("}")
      end
      spawnlib.writeBracket("}")
    end
  end
  spawnlib.writeBracket("}")
end
  
return spawnlib
