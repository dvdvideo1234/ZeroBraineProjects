require("ZeroBraineProjects/dvdlualib/common")

local function num(a)
  return tonumber(a) and true or false
end

local mt = {}
local t = {}; setmetatable(t, mt)
local s = ""

local getmetatable = getmetatable

local function tomet(a)
  return (getmetatable(a) == mt)
end

local stEstim1 = {
  addEstim(num, "toNumber()")
}

local stEstim2 = {
  addEstim(tomet, "toMeta()")
}



local stCard1 = {
  {0  , true , "Number", 5000, 1000},
  {nil, false, "Nil"   , 5000, 1000},
  {t  , false, "Table" , 5000, 1000},
  {s  , false, "String" , 5000, 1000}
}

local stCard2 = {
  {0  , false , "Number", 5000, 1000},
  {nil, false, "Nil"   , 5000, 1000},
  {t  , true, "Table" , 5000, 1000},
  {s  , false, "String" , 5000, 1000}
}

testPerformance(stCard2,stEstim2)

