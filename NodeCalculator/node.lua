local dir = require("directories").setBase(1)

local node = {}
local metaNode = {}

metaNode.__type    = "node.node"
metaNode.__index   = metaNode

local metaData = 
{
  ["+"] = 
  {
    1,
    function(a, b) return a + b end -- Plus
  },
  ["-"] = 
  {
    1,
    function(a, b) return a - b end -- Minus
  },
  ["*"] = 
  {
    2,
    function(a, b) return a * b end -- Multiply
  },
  ["/"] = 
  {
    2,
    function(a, b) return a / b end -- Divide
  },
  ["%"] = 
  {
    2,
    function(a, b) return a % b end -- Modulo
  },
  ["^"] =
  {
    3,
    function(a, b) return a ^ b end -- Power
  }
}

function node.New(sO)
  local self = {}
  local toL, toR = nil, nil
  local nbV, evB, ID = 0, false, ""
  local opC = tostring(sO or ""):sub(1,1)
  setmetatable(self, metaNode)
  function self:isEval() return evB end
  function self:getIndex() return ID end
  function self:getLeft() return toL end
  function self:getRight() return toR end
  function self:getValue() return nbV end
  function self:getOpcode() return opC end
  function self:setIndex(I) ID = tostring(I or "#"):sub(1,1); return self end
  function self:setLeft(L) toL = L; return self end
  function self:setRight(R) toR = R; return self end
  function self:setIsEval() evB = true; return self end
  function self:setValue(V) nbV, evB = (tonumber(V) or 0), true; return self end
  function self:setOpcode(O) opC = tostring(O or ""):sub(1,1); return self end
  return self
end

function metaNode:newLeft(sO)
  local sI = self:getIndex()
  local vL = node.New(sO):setIndex(sI.."<")
  self:setLeft(vL); return vL
end

function metaNode:newRight(sO)
  local sI = self:getIndex()
  local vR = node.New(sO):setIndex(sI..">")
  self:setRight(vR); return vR
end

function metaNode:Eval()
  if(self:isEval()) then return self end
  local sO = self:getOpcode()
  local tO = metaData[sO]
  local nP, pF = tO[1], tO[2]
  local vL, vR = self:getLeft(), self:getRight()
  if(vL) then vL:Eval() end
  if(vR) then vR:Eval() end
  local nL = (vL and vL:getValue() or 0)
  local nR = (vR and vR:getValue() or 0)
  return self:setValue(pF(nL, nR))
end

function metaNode:Validate()
  local evB = self:isEval()
  local ID  = self:getIndex()
  local opC = self:getOpcode()
  if(not evB) then
    if(not metaData[opC]) then
      error("Opcode missing ["..opC.."] at ["..ID.."]")
    else
      local tO = metaData[opC]
      local nP, pF = tO[1], tO[2]
      if(type(nP) ~= "number") then
        error("Opcode ["..opC.."] priority missing at ["..ID.."]") end
      if(type(pF) ~= "function") then
        error("Opcode ["..opC.."] function missing at ["..ID.."]") end
    end
  end; return self
end

return node
