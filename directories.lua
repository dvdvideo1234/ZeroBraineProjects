-- The location of the ZeroBraneStudio executable `zbstudio`

local metaDirectories =
{
  iBase = 0, -- The ID of the current IDE installation
  tBase =
  {
    "D:/LuaIDE", -- Home machine
    "C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE"
  },
  tPath =
  {
    "myprograms",
    "ZeroBraineProjects",
    "CorporateProjects",
    "ZeroBraineProjects/dvdlualib",
    -- When not located in general directory search in projects
    "ZeroBraineProjects/ExtractWireWiki",
  }
}

local directories = {}

--------------- HELPER FUNCTIONS ---------------

local function tableClear(tT)
  if(not tT) then error("Table missing") end
  local sT = type(tT); if(sT ~= "table") then
    error("Type mismatch ["..sT.."]") end
  if(not next(tT)) then return tT end
  for k, v in pairs(tT) do tT[k] = nil end
  return directories
end

local function tableRemove(tT, iD, sS)
  local sS = tostring(sS or ""); sS = ((sS == "") and "N/A" or sS)
  local iV, nT = math.floor(tonumber(iD) or 0), #tT
  if((iV <= 0) or (iV > nT)) then io.write(("Available %s is:\n"):format(sS))
    for iK = 1, nT do io.write("  ["..tostring(iK).."]["..tostring(tT[iK]).."]\n") end
    error(("Invalid %s ID ["..iV.."]"):format())
  end; table.remove(tT, iV); return directories
end

local function tableInsert(tT, iT, ...)
  local tA, iK = {...}, 1
  local iT = (tonumber(iT) or 0)
  while(tA[iK]) do
    local sV = tostring(tA[iK] or "")
    if(iT > 0) then
      table.insert(tT, iT, sV)
    elseif(iT < 0) then
      table.insert(tT, #tT - iT + 1, sV)
    else
      table.insert(tT, sV)
    end
    iK = iK + 1
  end; return directories
end

--------------- LIBRARY METHODS ---------------

function directories.getCount()
  return metaDirectories.iCount
end

function directories.getTPath()
  return metaDirectories.tPath
end

function directories.remTPathID(vP)
  return tableRemove(directories.getTPath(), vP, "path")
end

function directories.addTPath(...)
  return tableInsert(directories.getTPath(), 0, ...)
end

function directories.addTPathID(iD, ...)
  return tableInsert(directories.getTPath(), iD, ...)
end

function directories.setTPath(...)
  tableClear(directories.getTPath())
  return directories.addTPath(...)
end

function directories.getTBase()
  return metaDirectories.tBase
end

function directories.remTBaseID(vB)
  return tableRemove(directories.getTBase(), vB, "base")
end

function directories.addTBase(...)
  return tableInsert(directories.getTBase(), 0, ...)
end

function directories.addTBaseID(iD, ...)
  return tableInsert(directories.getTBase(), iD, ...)
end

function directories.setTBase(...)
  tableClear(directories.getTBase())
  return directories.addTBase(...)
end

function directories.getLast()
  return metaDirectories[metaDirectories.Count]
end

function directories.getFirst()
  return metaDirectories[1]
end

function directories.getByID(vD)
  local iD = (tonumber(vD) or 0); if(iD < 1) then
    error("Identifier mismatch ["..iD.."]") end
  local sP = metaDirectories[iD]; if(not sP) then
    error("Missing path under ID ["..iD.."]") end
  return sP
end

function directories.setBase(vB)
  local iBase = math.floor(tonumber(vB) or 0)
  local tBase = metaDirectories.tBase
  if(not (tBase and next(tBase))) then 
    error("Directory base list missing") end
  local sBase = tostring(tBase[iBase] or "")
  if(sBase:len() <= 0) then 
    error("Directory base path missing ["..iBase.."]") end
  local iCount = 0 -- Stores the number of paths processed
  local tPath = metaDirectories.tPath
  metaDirectories.iCount = iCount
  metaDirectories.iBase  = iBase  
  metaDirectories.sBase  = sBase  
  for iD = 1, #tPath do
    local sP = tostring(tPath[iD] or "")
    if(sP:len() > 0) then
      local sD = (sBase.."/"..sP)
      local bS, sE, nE = os.execute("cd /d "..sD)
      if(bS and bS ~= nil and nE == 0) then
        iCount = iCount + 1; metaDirectories.iCount = iCount
        metaDirectories[iCount] = sD
        package.path = package.path..";"..sD.."/?.lua"
      else
        print("Provided directory has been skipped: ["..iD.."]["..sD.."]")
      end
    end
  end
  return directories
end

function directories.getBase()
  return metaDirectories.sBase, metaDirectories.iBase
end

return directories
