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

function getColorBlackRGB()  return 0  ,  0,  0 end
function getColorRedRGB()    return 255,  0,  0 end
function getColorGreenRGB()  return 0  ,255,  0 end
function getColorBlueRGB()   return 0  ,  0,255 end
function getColorYellowRGB() return 255,255,  0 end
function getColorCyanRGB()   return 0  ,255,255 end
function getColorMagenRGB()  return 255,  0,255 end
function getColorWhiteRGB()  return 255,255,255 end

function getColorRotateLeft(r, g, b) return g, b, r end
function getColorRotateRigh(r, g, b) return b, r, g end

-- https://en.wikipedia.org/wiki/HSL_and_HSV
local function projectColorHC(h,c)
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

-- H [0,360], S [0,1], V [0,1]
function getColorHSV(h,s,v)
  local c = v * s
  local m = v - c
  local r, g, b = projectColorHC(h,c)
  return RoundValue(clClamp[2] * (r + m),1),
         RoundValue(clClamp[2] * (g + m),1),
         RoundValue(clClamp[2] * (b + m),1)
end

-- H [0,360], S [0,1], L [0,1]
function getColorHSL(h,s,l)
  local c = (1 - math.abs(2*l - 1)) * s
  local m = l - 0.5*c
  local r, g, b = projectColorHC(h,c)
  return RoundValue(clClamp[2] * (r + m),1),
         RoundValue(clClamp[2] * (g + m),1),
         RoundValue(clClamp[2] * (b + m),1)
end

-- H [0,360], C [0,1], L [0,1]
function getColorHCL(h,c,l)
  local r, g, b = projectColorHC(h,c)
  local m = l - (0.30*r + 0.59*g + 0.11*b)
  return RoundValue(clClamp[2] * (r + m),1),
         RoundValue(clClamp[2] * (g + m),1),
         RoundValue(clClamp[2] * (b + m),1)
end

function printColorMap(r,g,b) LogLine("colorMap: {"..r..","..g..","..b.."}") end
  
function getColorMap(sKey,iNdex)
  local iNdex = tonumber(iNdex) or 0
  if(iNdex <= 0) then LogLine("getColorMap: Missing iteration id #"..iTer); return getColorBlackRGB() end
  local sKey = tostring(sKey)
  local rgb = clMapping[sKey]
  if(not rgb) then LogLine("getColorMap: Missing mapping for <"..sKey..">"); return getColorBlackRGB() end
  local cid = iNdex % #rgb; rgb = rgb[cid]
  if(not rgb) then return getColorBlackRGB() end
  return rgb[1], rgb[2], rgb[3]
end

function getColorRegion(iDepth, maxDepth, iRegions)
  local sKey = "getColorRegion"
  local iDepth = tonumber(iDepth) or 0
  if(iDepth <= 0) then LogLine("getColorRegion: Missing Region depth #"..iDepth); return getColorBlackRGB() end
  local maxDepth = tonumber(maxDepth) or 0
  if(maxDepth <= 0) then LogLine("getColorRegion: Missing Region max depth #"..maxDepth); return getColorBlackRGB() end
  local iRegions = tonumber(iRegions) or 0
  if(iRegions <= 0) then LogLine("getColorRegion: Missing Regions count #"..iRegions); return getColorBlackRGB() end
  if (iDepth == maxDepth) then return getColorBlackRGB() end
  -- Cache the damn thing as it is too heavy
  if(not clMapping[sKey]) then clMapping[sKey] = {} end
  if(not clMapping[sKey][iRegions]) then clMapping[sKey][iRegions] = {} end
  local arRegions = clMapping[sKey][iRegions][maxDepth]
  if(not clMapping[sKey][iRegions][maxDepth]) then
    clMapping[sKey][iRegions][maxDepth] = {{brd = (maxDepth / iRegions), foo = function(iTer) return iTer * 2, 0, 0 end}}
    arRegions = clMapping[sKey][iRegions][maxDepth]
    local oneThird = math.ceil(0.33 * iRegions)
    for regid = 2,iRegions do
      arRegions[regid] = {}
      arRegions[regid].brd = arRegions[regid - 1].brd + arRegions[1].brd
      if(regid <= oneThird and regid > 1) then
        arRegions[regid].foo = function(iTer)
          return ((((iTer - arRegions[regid-1].brd) * arRegions[oneThird-regid+1].brd) / arRegions[2].brd) + arRegions[2].brd), 0, 0
        end  
      else
        arRegions[regid].foo = function(iTer)
          return 255, ((((iTer - arRegions[regid-1].brd) * arRegions[1].brd) / arRegions[regid-2].brd) + arRegions[regid-3].brd), 0
        end  
      end
    end
  end
  local lowBorder = 1
  for regid = 1, iRegions do
    local uppBorder = arRegions[regid].brd
    if(iDepth >= lowBorder and iDepth < uppBorder) then return arRegions[regid].foo(iDepth) end
    lowBorder = arRegions[regid].brd
  end
end
