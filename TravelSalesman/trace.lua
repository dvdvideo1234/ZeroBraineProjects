local common = require("dvdlualib/common")
local trace  = {}
local mtSale = {}

local function cityPermutationMinSum(oSelf)
  local tP = common.getPermute()
end

function trace.newSale(W)
  if(not common.isTable(W)) then return nil end
  local sy = #W; if(sx == 0) then return nil end
  local sx = #W[1]; if(sy == 0) then return nil end
  if(sx ~= sy) then return nil end
  local self, tData, dV, pSt = {}, common.copyItem(W), 0
  for iD = 1, sy do pSt = tData[iD]
    if(pSt and pSt.Info and pSt.Info.Start) then break end end
  function self:getData() return tData end
  function self:setValue(nV) dV = (tonumber(nV) or 0) end
  function self:getValue() return dV end
  setmetatable(self, mtSale); return self
end

function mtSale:Solve(sMeth)
  if(sMeth == "perm") then return end
end

return trace
