local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)
      
function GetReport(...)
  local sD = GetOpVar("OPSYM_VERTDIV")
  local tV, sV = {...}, sD
  local nV = select("#", ...)
  if(nV == 0) then return sV end
  for iV = 1, nV do
    sV = sD..tV[iV]
  end; return sV
end


print(GetReport(nil, nil, 4, 1, nil, 3))


