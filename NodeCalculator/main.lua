local dir = require("directories").remTPathID(3).setBase(1)
local node = require("NodeCalculator/node")

local r = node.New("+")
r:newLeft():setValue(6)
r:newRight():setValue(14):Validate()

print(r:Eval():getValue())