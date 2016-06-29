local tostring = tostring

local treeintdb  = {}
      treeintdb["__index__"] = {}
local metaBranch = {}
local metaDataDB = {}

local function isBranch(b)
  return (getmetatable(b) == metaBranch)
end

local function makeBranch()
  local self = {}
  setmetatable(self, metaBranch)
  return self
end

treeintdb.setIndex = function(base, ind, data)
  if(type(ind) ~= "table") then return nil end
  local k, d = 1, base
   while(ind[k]) do
    local b = d[ind[k]] -- Is there such branch
    if(not isBranch(b)) then
      if(ind[k+1]) then b = makeBranch() else b = data end
      d[ind[k]] = b
    end
    d, k = b, (k + 1)
  end; return d
end

treeintdb.getIndex = function(base, ind)
  if(type(ind) ~= "table") then return nil end
  local d, k = base, 1
  while(ind[k]) do
    local b = d[ind[k]] -- Is there such branch
    if(isBranch(s)) then return LogLine("DB.getIndex("..tostring(ind[k])..")["..tostring(k).."]: Branch invalid") end
    d = b; k = k + 1
  end
  return d
end

treeintdb.toIndex = function(int)
  local m, p = 0xFF000000, treeintdb["__index__"]
  for k = 3,0,-1 do
    p[4-k] = tostring(bit.rshift(bit.band(int,m),k*8)); m = bit.rshift(m,8)
  end; return p
end

treeintdb.make = function()
  local self = {}
  local data = makeBranch()
  local buff = {}
  
  function self:getData()   return data end
  function self:getBuffer() return buff end
    
  function self:Insert(x,y,anyData)
    local p = treeintdb.setIndex(data, treeintdb.toIndex(x), makeBranch())
    return    treeintdb.setIndex(p   , treeintdb.toIndex(y), anyData)
  end
  
  function self:Select(x,y)
    local p = treeintdb.getIndex(data, treeintdb.toIndex(x))
    return    treeintdb.getIndex(p   , treeintdb.toIndex(y))
  end
  setmetatable(self,metaDataDB)
  return self
end

return treeintdb













