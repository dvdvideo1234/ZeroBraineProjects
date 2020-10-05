local dir = require("directories").setBase(1)
local com = require("common")
local cpx = require("complex")
local tableRemove = table and table.remove
--[[
local function conv(x) return " "..x:sub(2,2):upper() end
for i = 1, #o do o[i] = ("_"..o[i]):gsub("_%w", conv):sub(2,-1) end
:gsub("%W.+$","")
:gsub("%.mdl","")
:gsub("/","_")
:match("[\\/]([^/\\]+)$")
]]




local old = function(m)
    local g = m:gsub("models/bobsters_trains/rails/2ft/",""):gsub("/","_")
    local r = g:match(".-_"):sub(1, -2); g = g:gsub(r.."_", "")
    local t, n = g:match(".-_"), g:gsub("%.mdl","")
    if(t) then t = t:sub(1, -2); g = g:gsub(r.."_", "")
      if(r:find(t)) then n = n:gsub(t.."_", "") end
    end; return r, n; end

local new = function(m) local o = {}
    local n = m:gsub("models/bobsters_trains/rails/2ft/","")
    local r = n:match("^%a+"); n = n:gsub("%.mdl","")
    for w in n:gmatch("%a+") do
      if(r:find(w)) then n = n:gsub(w.."%W+", "") end
    end table.insert(o, r); local f = n:match("^%a+")
    if(f) then table.insert(o, f); n = n:gsub(f.."%W+", "") end; return o, n
end
    
    

    
local m = "models/bobsters_trains/rails/2ft/straight_rack_512.mdl"
--local m = "models/bobsters_trains/rails/2ft/curves/curve_bank_90_left_2048.mdl"
-- print("ggg", new(m))
local to, nn = new(m)
print("Name", nn)
com.logTable(to, "NEW")


