package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")


local s= [[E:\Documents\Lua-Projs\SVN\wire-extras\models\keycard\keycard]]
s = common.stringTrim(common.normFolder(s),"/")

print(common.stringGetFileName(s))

