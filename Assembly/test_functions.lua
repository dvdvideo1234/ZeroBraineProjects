local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local mathRandom = math.random

local com = require("common")
local cpx = require("complex")
require("dvdlualib/gmodlib")
require("dvdlualib/trackasmlib")
local asmlib = trackasmlib
asmlib.InitBase("track","assembly")
asmlib.SetLogControl(1000, false)


function QuickSort(tD, iL, iH)
  if(not (iL and iH and (iL > 0) and (iL < iH))) then
    print("Data dimensions mismatch"); return nil end
  local iM = mathRandom(iH-iL-1)+iL-1
  tD[iL], tD[iM] = tD[iM], tD[iL]; iM = iL
  local vM, iC = tD[iL].Val, (iL + 1)
  while(iC <= iH)do
    if(tD[iC].Val < vM) then iM = iM + 1
      tD[iM], tD[iC] = tD[iC], tD[iM]
    end; iC = iC + 1
  end; tD[iL], tD[iM] = tD[iM], tD[iL]
  QuickSort(tD,iL,iM-1)
  QuickSort(tD,iM+1,iH)
end

function Sort(tTable, tCols)
  local tS, iS = {Size = 0}, 0
  local tC = tCols or {}; tC.Size = #tC
  for key, rec in pairs(tTable) do
    iS = (iS + 1); tS[iS] = {}
    tS[iS].Key, tS[iS].Rec = key, rec
    if(asmlib.IsTable(rec)) then tS[iS].Val = "" -- Allocate sorting value
      if(tC.Size > 0) then -- When there are sorting column names provided
        for iI = 1, tC.Size do local sC = tC[iI]; if(not asmlib.IsHere(rec[sC])) then
          print("Key <"..sC.."> not found on the current record"); return nil end
            tS[iS].Val = tS[iS].Val..tostring(rec[sC]) -- Concatenate sort value
        end -- When no sort columns are provided sort by the keys instead
      else tS[iS].Val = key end -- When column list not specified use the key
    else tS[iS].Val = rec end -- When the element is not a table use the value
  end; tS.Size = iS; QuickSort(tS,1,iS); return tS
end

local t = {
    Name = function(a) return tostring(a or "") end, 
    Age = function(a) return (tonumber(a) or 0) end,
    {Name = "D", Age = 50},
    {Name = "A", Age = 5},
    {Name = "C"}, -- , Age = 15
    {Name = "B", Age = 45}
  }

com.logTable(Sort(t, {"Age", "Name"}), "ORG")

function sort_on_values(t,...)
    local idx, cnt = {...}, select("#", ...)
    for i = 1, cnt do idx[i] = idx[i] or 1 end
    local a, b, c = unpack(idx)
    table.sort(t, function (u, v)
      return
        (cnt >= 1 and  t[a](u[a])< t[a](v[a])) or
        (cnt >= 2 and (t[a](u[a])==t[a](v[a]) and t[b](u[b])< t[b](v[b]))) or
        (cnt >= 3 and (t[a](u[a])==t[a](v[a]) and t[b](u[b])==t[b](v[b]) and t[c](u[c])< t[c](v[c])))
    end)
end

sort_on_values(t, "Name", "Age")

com.logTable(t, "NEW")






