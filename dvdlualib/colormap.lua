local math = math
local clMapping = {}
local clClamp = {0, 255}
clMapping["wikipedia"] = {
  { 66,  30,  15}, -- brown 3
  { 25,   7,  26}, -- dark violett
  {  9,   1,  47}, -- darkest blue
  {  4,   4,  73}, -- blue 5
  {  0,   7, 100}, -- blue 4
  { 12,  44, 138}, -- blue 3
  { 24,  82, 177}, -- blue 2
  { 57, 125, 209}, -- blue 1
  {134, 181, 229}, -- blue 0
  {211, 236, 248}, -- lightest blue
  {241, 233, 191}, -- lightest yellow
  {248, 201,  95}, -- light yellow
  {255, 170,   0}, -- dirty yellow
  {204, 128,   0}, -- brown 0
  {153,  87,   0}, -- brown 1
  {106,  52,   3}  -- brown 2
}

function getWhiteRGB() return 255,255,255 end
function getBlackRGB() return 0  ,  0,  0 end

-- https://en.wikipedia.org/wiki/HSL_and_HSV
local function projectColor(c,h)
  local hp = h / 60
  local x  = c * (1 - math.abs((hp % 2) - 1))
  if(hp >= 0 and hp < 1) then return c, x , 0 end
  if(hp >= 1 and hp < 2) then return x, c , 0 end
  if(hp >= 2 and hp < 3) then return 0, c , x end
  if(hp >= 3 and hp < 4) then return 0, x , c end
  if(hp >= 4 and hp < 5) then return x, 0 , c end
  if(hp >= 5 and hp < 6) then return c, 0 , x end
  return 0, 0, 0
end

function getColorHSV(h,s,v)
  local c = v * s
  local m = v - c
  local r, g, b = projectColor(c,h)
  return RoundValue(clClamp[2] * (r + m),1),
         RoundValue(clClamp[2] * (g + m),1),
         RoundValue(clClamp[2] * (b + m),1)
end

function getColorMap(sKey,iTer)
  local iTer = tonumber(iTer) or 0
  if(not iTer)  then LogLine("getColorMap: Missing iteration id"); return getBlackRGB() end
  if(iTer <= 0) then LogLine("getColorMap: Missing iteration id #"..iTer); return getBlackRGB() end
  local sKey = tostring(sKey)
  local rgb = clMapping[sKey]
  if(not rgb) then LogLine("getColorMap: Missing mapping for <"..sKey..">"); return getBlackRGB() end
  local cid = iTer % #rgb; rgb = rgb[cid]
  if(not rgb) then return getBlackRGB() end
  return rgb[1], rgb[2], rgb[3]
end

function getYellowIterationMap(iTer, maxIter)
  if (iTer == maxIter) then return getBlackRGB() end
  local s1 = maxIter / 7
  local s2 = s1 + s1
  local s3 = s2 + s1 
  local s4 = s3 + s1 
  local s5 = s4 + s1 
  local s6 = s5 + s1 
  local s7 = s6 + s1 
      if (iTer < s1) then return iTer * 2, 0, 0
  elseif (iTer < s2) then return (((iTer - s1) * s2) / s2) + s2, 0, 0   -- 0x0080 to 0x00C0 
  elseif (iTer < s3) then return (((iTer - s2) * s1) / s2) + s2, 0, 0    -- 0x00C1 to 0x00FF 
  elseif (iTer < s4) then return 255, (((iTer - s3) * s1) / s2) + 1, 0    -- 0x01FF to 0x3FFF 
  elseif (iTer < s5) then return 255, (((iTer - s4) * s1) / s3) + 64, 0   -- 0x40FF to 0x7FFF 
  elseif (iTer < s6) then return 255, (((iTer - s5) * s1) / s4) + 128, 0   -- 0x80FF to 0xBFFF 
  elseif (iTer < s7) then return 255, (((iTer - s6) * s1) / s5) + 192, 0   -- 0xC0FF to 0xFFFF 
  else return 255, 255, 0 end
end
