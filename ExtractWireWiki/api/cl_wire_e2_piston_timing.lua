local E2Helper = {}; E2Helper.Descriptions = {}

------------------------------------------------------PUT E2 DESCRIPTION HERE------------------------------------------------------

--[[ ******************************************************************************
 My custom state LQ-PID control type handling process variables
****************************************************************************** ]]--

local DSC = E2Helper.Descriptions
local tKey = {"an integer", "a string"}
DSC["allPiston(e:)"] = "Returns the count of all piston keys"
DSC["clrPiston(e:)"] = "Clears all pistons from the E2 chip"
DSC["cntPiston(e:)"] = "Returns the count of integer piston keys"
DSC["getPiston(e:nn)"] = "Returns piston bearing timing by "..tKey[1].." key"
DSC["getPiston(e:sn)"] = "Returns piston bearing timing by "..tKey[2].." key"
DSC["higPiston(e:n)"] = "Returns the piston highest point angle in degrees by "..tKey[1].." key"
DSC["higPiston(e:s)"] = "Returns the piston highest point angle in degrees by "..tKey[2].." key"
DSC["lowPiston(e:n)"] = "Returns the piston lowest point angle in degrees by "..tKey[1].." key"
DSC["lowPiston(e:s)"] = "Returns the piston lowest point angle in degrees by "..tKey[2].." key"
DSC["remPiston(e:n)"] = "Removes the piston by "..tKey[1].." key"
DSC["remPiston(e:s)"] = "Removes the piston by "..tKey[2].." key"
DSC["setPistonSign(e:nn)"] = "Creates a sign-timed piston by "..tKey[1].." key and highest point angle in degrees"
DSC["setPistonSign(e:sn)"] = "Creates a sign-timed piston by "..tKey[2].." key and highest point angle in degrees"
DSC["setPistonWave(e:nn)"] = "Creates a wave-timed piston by "..tKey[1].." key and highest point angle in degrees"
DSC["setPistonWave(e:sn)"] = "Creates a wave-timed piston by "..tKey[2].." key and highest point angle in degrees"
DSC["wavPiston(e:n)"] = "Returns a flag if the piston is in wave mode by "..tKey[1].." key"
DSC["wavPiston(e:s)"] = "Returns a flag if the piston is in wave mode by "..tKey[2].." key"

return DSC
