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

local function tableClear(tT)
  if(not tT) then error("Table missing") end
  local sT = type(tT); if(sT ~= "table") then
    error("Type mismatch ["..sT.."]") end
  if(not next(tT)) then return tT end
  for k, v in pairs(tT) do tT[k] = nil end
end

local directories = {}

function directories.getCount()
  return metaDirectories.iCount
end

function directories.getTPath()
  return metaDirectories.tPath
end

function directories.addTPath(...)
  local tPath = metaDirectories.tPath
  local tA, iK = {...}, 1
  while(tA[iK]) do
    local sV = tostring(tA[iK] or "")
    table.insert(metaDirectories.tPath, sV)
    iK = iK + 1
  end
end

function directories.setTPath(...)
  tableClear(metaDirectories.tPath)
  directories.addTPath(...)
end

function directories.getTBase()
  return metaDirectories.tBase
end

function directories.addTBase(...)
  local tBase = metaDirectories.tBase
  local tA, iK = {...}, 1
  while(tA[iK]) do
    local sV = tostring(tA[iK] or "")
    table.insert(metaDirectories.tBase, sV)
    iK = iK + 1
  end
end

function directories.setTBase(...)
  tableClear(metaDirectories.tBase)
  directories.addTBase(...)
end

function directories.getBase()
  return metaDirectories.sBase, metaDirectories.iBase
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
        print("Provided directory has been skipped: ["..sD.."]")
      end
    end
  end
  return directories
end

return directories
