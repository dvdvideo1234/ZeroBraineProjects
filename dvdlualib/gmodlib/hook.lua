hook = {}
local internal = {}

function hook.Add(sN, sID, fAc)
  if(not sN) then return end
  if(not sID) then return end
  local tH = internal[sN]
  if(not tH) then internal[sN] = {}; tH = internal[sN] end
  tH[sID] = fAc
end

function hook.Remove(sN, sID)
  if(not sN) then return end
  if(not sID) then return end
  local tH = internal[sN]
  if(not tH) then return end
  tH[sID] = nil
end
