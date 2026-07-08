concommand = {}
local internal = {}

function concommand.Remove(sID)
  if(not sID) then return end
  internal[sID] = nil 
end

function concommand.Add(sID, fAct)
  if(not sID) then return end
  internal[sID] = fAct 
end

return concommand
