local c = require("../dvdlualib/common")

local t = {}

t[0] = 7
t[2] = 7

c.logTable(t)

print(#t)
