package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common  = require('common')

ErrorNoHalt = print
gsToolName = "TEST"
gtLang = {["S"] = 55}

local function getPhrase(sK)
  local sK = tostring(sK) if(not gtLang[sK]) then
    ErrorNoHalt(gsToolName..": getPhrase("..sK.."): Missing")
    return "Oops, missing ?" -- Return some default translation
  end; return gtLang[sK]
end

print(getPhrase(1))
