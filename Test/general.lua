package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common  = require('common')

local function getSign(nN)
  return (((nN > 0) and 1) or ((nN < 0) and -1) or 0)
end

local function getAngNorm(nA)
  return ((nA + 180) % 360 - 180)
end


local H = -45
local tT, nS = {}, 0

for iD =  0, 180, 15 do nS = nS + 1; tT[nS] = iD end
for iD = -180, 0, 15 do nS = nS + 1; tT[nS] = iD end

common.logTable(tT, "SRC")

for iD = 1, #tT do
  local R = tT[iD]
  local nD = getAngNorm(R - H)
  local nP = (((math.abs(nD) > 90) and -getAngNorm(nD+180) or nD) / 90)
  print(iD, R, nD, nP)
end

-- common.logTable(tT, "OUT")








