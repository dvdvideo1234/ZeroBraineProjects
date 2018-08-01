local E2Helper = {}; E2Helper.Descriptions = {}

------------------------------------------------------PUT E2 DESCRIPTION HERE------------------------------------------------------

--[[ ******************************************************************************
 My custom state LQ-PID control type handling process variables
****************************************************************************** ]]--

local DSC = E2Helper.Descriptions

DSC["trackasmlibApplyPhysicalAnchor(e:enn)"] = "Anchors the track entity to a base entity with with additional weld 0/1 and no-collide 0/1 flag options available."
DSC["trackasmlibApplyPhysicalSettings(e:nnns)"] = "Modifies track entity physical settings with physgun enabled, freeze, gravity toggle and surface material behavior"
DSC["trackasmlibAttachAdditions(e:)"] = "Attaches the track entity additoions when available"
DSC["trackasmlibAttachBodyGroups(e:s)"] = "Attaches track piece bodygroups by providing selection code"
DSC["trackasmlibGenActivePointDSV(e:essnss)"] = "Exports the track entity as external database record"
DSC["trackasmlibGenActivePointINS(e:essns)"] = "Exports the track entity as internal database record"
DSC["trackasmlibGetAdditionsCount(e:)"] = "Returns record additions count by entity"
DSC["trackasmlibGetAdditionsCount(s)"] = "Returns record additions count by model"
DSC["trackasmlibGetAdditionsLine(e:n)"] = "Returns record additions line by entity"
DSC["trackasmlibGetAdditionsLine(sn)"] = "Returns record additions lune by model"
DSC["trackasmlibGetName(e:)"] = "Returns record name by entity"
DSC["trackasmlibGetName(s)"] = "Returns record name by model"
DSC["trackasmlibGetOffset(e:ns)"] = "Returns record snap offsets by entity"
DSC["trackasmlibGetOffset(sns)"] = "Returns record snap offsets by model"
DSC["trackasmlibGetPointsCount(e:)"] = "Returns record points count by entity"
DSC["trackasmlibGetPointsCount(s)"] = "Returns record points count by model"
DSC["trackasmlibGetProperty()"] = "Returns the surface property types"
DSC["trackasmlibGetProperty(s)"] = "Returns the surface properties available for a given type"
DSC["trackasmlibGetType(e:)"] = "Returns record track type by entity"
DSC["trackasmlibGetType(s)"] = "Returns record track type by model"
DSC["trackasmlibHasAdditions(e:)"] = "Returns 1 when the record has additions and 0 otherwise by entity"
DSC["trackasmlibHasAdditions(s)"] = "Returns 1 when the record has additions and 0 otherwise by model"
DSC["trackasmlibIsPiece(e:)"] = "Returns 1 when the record is actual track and 0 otherwise by entity"
DSC["trackasmlibIsPiece(s)"] = "Returns 1 when the record is actual track and 0 otherwise by model"
DSC["trackasmlibMakePiece(e:va)"] = "Duplicates the given track using the new position and angle"
DSC["trackasmlibMakePiece(svansnnnn)"] = "Creates new track piece wuth position angle, mass, bodygroup code and color by model"
DSC["trackasmlibSnapEntity(e:vsnnnnvv)"] = "Snaps a track with position, holder model, point ID, active radius, flatten, ignore type, position offset and angle offset"
DSC["trackasmlibSnapNormal(vasnvv)"] = "Snaps a track on the trace surface with poisition, angle, model, point ID, position offset and angle offset"

return DSC
