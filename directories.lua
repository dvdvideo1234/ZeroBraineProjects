-- The location of the ZeroBraneStudio executable `zbstudio`
local sInstall = "D:/LuaIDE"

local tDir =
{
  "myprograms",
  "ZeroBraineProjects",
  "ZeroBraineProjects/dvdlualib",
  -- When not located in general directory search in projects
  "ZeroBraineProjects/ExtractWireWiki",
}

local metaDirectories =
{
  Base  = sInstall,
  Count = 0
}

for iD = 1, #tDir do
  local sP = tostring(tDir[iD] or "")
  if(sP:len() > 0) then
    local sD = sInstall.."/"..sP
    local bS, sE, nE = os.execute("cd "..sD)
    if(bS and bS ~= nil and nE == 0) then
      metaDirectories.Count = metaDirectories.Count + 1
      metaDirectories[metaDirectories.Count] = (sInstall.."/"..sP)
      package.path = package.path..";"..sInstall.."/"..sP.."/?.lua"
    else
      print("Provided directory has been skipped: ["..sP.."]")
    end
  end
end

local directories = {}

function directories.getBase()
  return metaDirectories.Base
end

function directories.getLast()
  return metaDirectories[metaDirectories.Count]
end

function directories.getFirst()
  return metaDirectories[1]
end

function directories.getByID(vD)
  local iD = (tonumber(vD) or 0)
  if(iD < 1) then error("Identifier mismatch ["..iD.."]") end
  local sP = metaDirectories[iD]
  if(not sP) then error("Missing path under id ["..iD.."]") end
  return sP
end

function directories.getList()
  local tL, iD = {}, 1
  while(metaDirectories[iD]) do
    tL[iD] = metaDirectories[iD]
    iD = iD + 1
  end
  tL.Base  = metaDirectories.Base
  tL.Count = (iD - 1)
  return tL
end

return directories
