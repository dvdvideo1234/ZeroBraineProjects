local keys = {}

local __keymap = {}
__keymap["escape"] = 32
__keymap["space" ] = 27
__keymap["left"  ] = 314
__keymap["up"    ] = 315
__keymap["right" ] = 316
__keymap["down"  ] = 317

function keys.Check(nVal, sKey)
  return (__keymap[tostring(sKey)] == (tonumber(nVal) or 0))
end

function keys.Wait(nTim)
  local nTim = (tonumber(nTim) or 0)
  if(nTim < 1) then nTim = 1 end
  while(not keys.Check(nVal, sKey)) do wait(nTim) end; return true
end

return keys
