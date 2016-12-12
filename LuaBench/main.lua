require("ZeroBraineProjects/dvdlualib/common")

local stmt1_3= {"select * from test where model = '","' and id = "," and type = '","' order by model asc;"}
local stmt2_3 =  "select * from test where model = '%s' and id = %d and type = '%s' order by model asc;"

local stmt1_1= {"select * from test where model = '","' order by model asc;"}
local stmt2_1 =  "select * from test where model = '%s' order by model asc;"


local stmt1 = {[3] = stmt1_3, [1] = stmt1_1}
local stmt2 = {[3] = stmt2_3, [1] = stmt2_1}
local rez = {
  [1] = "select * from test where model = 'model' order by model asc;",
  [3] = "select * from test where model = 'model' and id = 1 and type = 'ron' order by model asc;"
}


function stmtQuery1(arg)
  local tStore, tVal, sQ = stmt1[3], arg, ""
  local iCnt   = #tStore
  for ID = 1, (iCnt - 1) do
 --   if(not tVal[ID]) then
  --    return StatusLog(nil, "SQLFetchSelect: Not enough <"..tostring(sHash).."> values ["..tostring(ID).."]") end
    sQ = sQ..tStore[ID]..tostring(tVal[ID])
  end; return sQ..tStore[iCnt]
end

function stmtQuery2(arg)
  local tStore, tVal = stmt2[3], arg
  return tStore:format(tVal[1], tVal[2], tVal[3])
end

local stEstim = {
  addEstim(stmtQuery1, "Concat"),
  addEstim(stmtQuery2, "Format")
}

local stCard = {
  {{"model",1,"ron"}, rez[3], "Zero", 5000, 10}
}


testPerformance(stCard,stEstim)

--[[ arg = 1 / 500000, 100
Passed [Concat]: 100.000 Time: 100.000 (291.364[s])      171606.650[c/s] Failed: 0
Passed [Format]: 100.000 Time: 106.758 (311.055[s])      160743.277[c/s] Failed: 0
]]



