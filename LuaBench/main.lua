require("ZeroBraineProjects/dvdlualib/common")

local s1 = function(n)
  return ((n < 0) and -1) or ((n > 0) and 1) or 0 end
local s2 = function(n)
  return (n ~= 0) and (n / math.abs(n)) or 0 end

local stEstim = {
  addEstim(s1, "Sign-1"),
  addEstim(s2, "Sign-2")
}

local stCard = {
  {0 , 0, "Zero", 10000, 100},
  {-5,-1, "Nega", 10000, 100},
  { 5, 1, "Posi", 10000, 100}
}


testPerformance(stCard,stEstim)






