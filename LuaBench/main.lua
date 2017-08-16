require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")


local function add1(a) return ((tonumber(a) or 0)+1) end
local function add2(a) return ((tonumber(a) or 0)+2) end
local function add3(a) return ((tonumber(a) or 0)+3) end

local ar = {
  ["add1"] = {add1},
  ["add2"] = {add2},
  ["add3"] = {add3}
}

local sum = {1,2,3}

local function single(a)
  local i, s = 1, 0
  for k, v in pairs(ar) do
    v[2] = add1(i)
    v[3] = v[2] + add2(i)
    v[4] = v[3] + add3(i)
    s = s + v[2] + v[3] + v[4]
    i = i + 1
  end
  return (a + s)
end

local function more(a)
  local i, s = 1, 0
  for k, v in pairs(ar) do v[2] = add1(i); i = i + 1 end; i = 1
  for k, v in pairs(ar) do v[3] = v[2] + add2(i); i = i + 1 end; i = 1
  for k, v in pairs(ar) do v[4] = v[3] + add3(i); i = i + 1 end; i = 1
  for k, v in pairs(ar) do s = s + v[2] + v[3] + v[4] end
  return (a + s)
end

local rec = {["Ref"] = "12"}; logTable(rec); print(rec["Ref"])

      rec["Ref"]    = strExplode(rec["Ref"], "/")
      rec["Ref"][1] = tonumber((rec["Ref"][1]):Trim()) or 0
      rec["Ref"][2] = tostring(rec["Ref"][2] or ""):Trim()
      rec["Ref"][2] = ((rec["Ref"][2] ~= "") and rec["Ref"][2] or nil)

      

      logTable(rec)
      
      





local stEstim = {
  addEstim(single, "single"),
  addEstim(more  , "morecy")
}


local stCard = {
  {1  , 67 , "Number", 5000, 5000, .2}
}

-- testPerformance(stCard,stEstim,nil,0.1)

--[[
Passed [single]: 100.000 Time: 100.000 (1474.423[s])       16955.785[c/s] Failed: 0
Passed [morecy]: 100.000 Time: 106.971 (1577.200[s])       15850.875[c/s] Failed: 0
]]

