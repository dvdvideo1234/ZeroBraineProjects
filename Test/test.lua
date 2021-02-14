local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")
local tableRemove = table and table.remove

local function isValid(vE, vT)
  if(vT) then local sT = tostring(vT or "")
    if(sT ~= type(vE)) then return false end end
  return (vE and vE.IsValid and vE:IsValid())
end


local function updateFilterSize(oFTrc)
  if(not oFTrc) then return nil end
  local tE, iE = oFTrc.mFlt.Ent, 1
  while(tE[iE]) do
    local vE = tE[iE]
    if(isValid(vE)) then iE = iE + 1
    else table.remove(tE, iE) end
  end; oFTrc.mFlt.Size = (iE - 1)
  return oFTrc
end


local tT = {mFlt = {Size = 0, Ent = {}}}

for i = 1, 4 do
  tT.mFlt.Ent[i] = ents.Create(i)
end

for i = 5, 7 do
  tT.mFlt.Ent[i] = ents.Create(i)
  tT.mFlt.Ent[i].IsValid = function(self)
    return false
  end
end

for i = 8, 10 do
  tT.mFlt.Ent[i] = ents.Create(i)
end

for i = 1, #tT.mFlt.Ent do
  print(tT.mFlt.Ent[i], tT.mFlt.Ent[i]:IsValid())
end
print("\n")

updateFilterSize(tT)

for i = 1, #tT.mFlt.Ent do
  print(tT.mFlt.Ent[i], tT.mFlt.Ent[i]:IsValid())
end
print("\n", tT.mFlt.Size)