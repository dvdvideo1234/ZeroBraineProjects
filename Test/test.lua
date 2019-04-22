local com = require("dvdlualib/common")
local gmd = require("dvdlualib/gmodlib")

local tableConcat = table and table.concat
local tableCopy   = table and table.Copy
local mathSqrt    = math and math.sqrt
local mathSin     = math and math.sin
local mathAbs     = math and math.abs

local function getAngNorm(nA)
  return ((nA + 180) % 360 - 180)
end

local function roll1(R, H, L)
  local vP = ((H  > 0) and ((R > H or R  < L) and  1 or -1) or nil)
  local vN = ((H  < 0) and ((R < H or R  > L) and -1 or  1) or nil)
  local vZ = ((H == 0) and ((R < H) and -1 or 1) or nil)
  return (vZ or vP or vN)
end






