local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

local gmod   = require("dvdlualib/gmodlib")

local list = {data={}}
list.Set = function(kK, vV) list.data[kK] = vV end
list.GetForEdit = function(kK) return list.data[kK] end

list.Set("aaa", "bbb")

local function readConfigData(sN) 
  local fI = fileOpen(sN, "rb", "DATA")
  if(not fI) then return end
  local sL = fI:Read("*line")
  while(sL) do
    sL = sL:Trim()
    if(sL ~= "" and sL:sub(1,1) ~= "#") then
      print(sL)
    end
    sL = fI:Read("*line")
  end
end

readConfigData("Test/physprop_adv_test.txt")

print(("physprop_adv_test.txt"):gsub("%.txt", ""))

for name in ("dsfsdf asdasd\tdsdf"):gmatch("%w+") do
  print("aaaa", name)
end



common.logTable(list, "list")