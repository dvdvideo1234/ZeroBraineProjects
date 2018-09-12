package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common  = require('common')

local sC = "E:/Documents/Lua-Projs/SVN/E2PistonTiming/lua/entities/gmod_wire_expression2/core/custom/cl_wire_e2_piston_timing.lua"

local t = io.open(sC, "rb")
local s = t:read("*all")
      s = "return function()\nlocal E2Helper = {}; E2Helper.Descriptions = {}\n"..s.."\nreturn DSC\nend"
local FOO, OK = load(s)
if(FOO) then OK, DSC = pcall(FOO)
  if(OK) then
    common.logStatus(s)
    common.logTable(DSC(1))
  else
    common.logStatus("PCALL: Fail: "..DSC)
  end
else
  common.logStatus("LOAD: Fail: "..s)
  common.logStatus(FOO)
end


