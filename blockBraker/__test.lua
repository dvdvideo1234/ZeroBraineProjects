require("lib/paths").regDir("E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms","*.lua")

local complex = require("complex")
local common  = require("common")


local a = {1,2,3}
a.b = {[a]=7,["Pooh"]=a}

common.logTable(a,"a")

local b = common.copyItem(a)
common.logTable(b,"b")

local z =  function(f)
  return ({})..(1)
end

local a = complex.getNew(1,1)
local b = complex.getNew(2,2)
local m = getmetatable(a)
local c = common.copyItem(a,{[m]=complex.getNew})
local t = {a,b,c}
m.__tostring = nil

for i = 1, #t do
  local v = t[i]
  print(i, v, v:getFormat("string"))
end
