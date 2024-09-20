local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("dvdlualib/gmodlib")
local testexec = require("testexec")

local nF, nT = 1, 3

function GetWrap(nV,nL,nH) local nV = nV
  while(nV < nL or nV > nH) do
    nV = ((nV < nL) and (nH - (nL - nV) + 1) or nV)
    nV = ((nV > nH) and (nL + (nV - nH) - 1) or nV)
  end; return nV -- Returns the N-stepped value
end

function GetWrap2(nV,nL,nH)
  if(nV == 0) then return nH end
  if(nV >= nL and nV <= nH) then return nV end
  local nC = nV % nH
  return (nC == 0) and nH or nC
end

function GetWrap3(nV,_,nS)
  local nC = nV % nS
  return (nC == 0) and nS or nC
end


function GetEmpty1(tArg)
  return GetWrap(unpack(tArg))
end

function GetEmpty2(tArg)
  return GetWrap2(unpack(tArg))
end

function GetEmpty3(tArg)
  return GetWrap3(unpack(tArg))
end

t = testexec.New()
t:setCase(GetEmpty1, "original")
t:setCase(GetEmpty2, "modify")
t:setCase(GetEmpty3, "mod")
t:setProgress(1, 0.1)
t:setCount(10000, 10000)
t:setCard({-6, nF, nT}, 3, "1 ")
t:setCard({-5, nF, nT}, 1, "2 ")
t:setCard({-4, nF, nT}, 2, "3 ")
t:setCard({-3, nF, nT}, 3, "4 ")
t:setCard({-2, nF, nT}, 1, "5 ")
t:setCard({-1, nF, nT}, 2, "6 ")
t:setCard({0 , nF, nT}, 3, "7 ")
t:setCard({1 , nF, nT}, 1, "8 ")
t:setCard({2 , nF, nT}, 2, "9 ")
t:setCard({3 , nF, nT}, 3, "10")
t:setCard({4 , nF, nT}, 1, "11")
t:setCard({5 , nF, nT}, 2, "12")
t:setCard({6 , nF, nT}, 3, "13")
t:setCard({7 , nF, nT}, 1, "14")
t:setCard({8 , nF, nT}, 2, "15")
t:setCard({9 , nF, nT}, 3, "16")
t:setCard({10, nF, nT}, 1, "17")
t:runMeasure()
