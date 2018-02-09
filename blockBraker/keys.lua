local wx = require("wx")
local tu = require("turtle")

local keys = {}
local __keymap = {}
local __revmap = {}

__keymap["backsp"] = 8
__keymap["enter" ] = 13
__keymap["escape"] = 27
__keymap["space" ] = 32
__keymap["0"] = 48
__keymap["1"] = 49
__keymap["2"] = 50
__keymap["3"] = 51
__keymap["4"] = 52
__keymap["5"] = 53
__keymap["6"] = 54
__keymap["7"] = 55
__keymap["8"] = 56
__keymap["9"] = 57
__keymap[":"] = 58
__keymap[";"] = 59
__keymap["<"] = 60
__keymap["="] = 61
__keymap["<"] = 62
__keymap["?"] = 63
__keymap["A"] = 65
__keymap["B"] = 66
__keymap["C"] = 67
__keymap["D"] = 68
__keymap["E"] = 69
__keymap["F"] = 70
__keymap["G"] = 71
__keymap["H"] = 72
__keymap["I"] = 73
__keymap["J"] = 74
__keymap["K"] = 75
__keymap["L"] = 76
__keymap["M"] = 77
__keymap["N"] = 78
__keymap["O"] = 79
__keymap["P"] = 80
__keymap["Q"] = 81
__keymap["R"] = 82
__keymap["S"] = 83
__keymap["T"] = 84
__keymap["U"] = 85
__keymap["V"] = 86
__keymap["W"] = 87
__keymap["X"] = 88
__keymap["Y"] = 89
__keymap["Z"] = 90
__keymap["["] = 91
__keymap["]"] = 93
__keymap["left"  ] = 314
__keymap["up"    ] = 315
__keymap["right" ] = 316
__keymap["down"  ] = 317
__keymap["shift" ] = 306
__keymap["ctrl"  ] = 308
__keymap["alt"   ] = 307
__keymap["f1"    ] = 340
__keymap["f2"    ] = 341
__keymap["f3"    ] = 342
__keymap["f4"    ] = 343
__keymap["f5"    ] = 344
__keymap["f6"    ] = 345
__keymap["f7"    ] = 346
__keymap["f8"    ] = 347
__keymap["f9"    ] = 348
__keymap["f10"   ] = 349
__keymap["f11"   ] = 350
__keymap["f12"   ] = 351
__keymap["pgup"  ] = 366
__keymap["pgdn"  ] = 367
__keymap["nument"] = 370
__keymap["num+"  ] = 388
__keymap["num-"  ] = 390
__keymap["num8"  ] = 332
__keymap["num2"  ] = 326
__keymap["num4"  ] = 328
__keymap["num6"  ] = 330

for but, asc in pairs(__keymap) do
  __revmap[asc] = but
end

function keys.getKey()     return char()     end
function keys.getMouseLD() return clck('ld') end
function keys.getMouseRD() return clck('rd') end

function keys.getChar(nVal)
  iVal = math.floor(tonumber(nVal) or 0)
  if(iVal < __keymap["space" ]) then return "" end
  if(iVal > __keymap["Z"]     ) then return "" end
  return __revmap[iVal]
end

function keys.getPress(nVal, sKey)
  return (__keymap[tostring(sKey)] == (tonumber(nVal) or 0))
end

function keys.waitPress(nVal, sKey)
  while(not keys.getPress(nVal, sKey)) do end; return true
end

return keys
