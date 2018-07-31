local E2Helper = {}; E2Helper.Descriptions = {}

------------------------------------------------------PUT E2 DESCRIPTION HERE------------------------------------------------------

--[[ ******************************************************************************
 My custom flash sensor tracer type ( Based on wire rangers )
****************************************************************************** ]]--

local DSC = E2Helper.Descriptions
local xfs, par = "flash sensor", {"attachment entity", "origin position", "direction vector", "length distance"}
DSC["noFSensor()"] = "Returns invalid "..xfs.." object"
DSC["setFSensor(e:vvn)"] = "Returns "..xfs.." local to the entity by "..par[2]..", "..par[3]..", "..par[4]
DSC["newFSensor(vvn)"] = "Returns "..xfs.." relative to the world by "..par[2]..", "..par[3]..", "..par[4]
DSC["setFSensor(e:vv)"] = "Returns "..xfs.." local to the entity by "..par[2]..", "..par[3]..", zero "..par[4]
DSC["newFSensor(vv)"] = "Returns "..xfs.." relative to the world by "..par[2]..", "..par[3]..", zero "..par[4]
DSC["setFSensor(e:v)"] = "Returns "..xfs.." local to the entity by "..par[2]..", zero "..par[3]..", zero "..par[4]
DSC["newFSensor(v)"] = "Returns "..xfs.." relative to the world by "..par[2]..", zero "..par[3]..", zero "..par[4]
DSC["setFSensor(e:)"] = "Returns "..xfs.." local to the entity by zero "..par[2]..", zero "..par[3]..", zero "..par[4]
DSC["newFSensor()"] = "Returns "..xfs.." relative to the world by zero "..par[2]..", zero "..par[3]..", zero "..par[4]
DSC["copyFSensor(xfs:)"] = "Returns "..xfs.." copy instance of the current object"
DSC["addEntityHitSkip(xfs:e)"] = "Adds the entity to the "..xfs.." internal ignore hit list"
DSC["remEntityHitSkip(xfs:e)"] = "Removes the entity from the "..xfs.." internal ignore hit list"
DSC["addEntityHitOnly(xfs:e)"] = "Adds the entity to the "..xfs.." internal only hit list"
DSC["remEntityHitOnly(xfs:e)"] = "Removes the entity from the "..xfs.." internal only hit list"
DSC["remHit(xfs:s)"] = "Removes the option from the "..xfs.." internal hit preferences"
DSC["addHitSkip(xfs:sn)"] = "Adds the option to the "..xfs.." internal ignore hit list"
DSC["remHitSkip(xfs:sn)"] = "Removes the option from the "..xfs.." internal ignore hit list"
DSC["addHitOnly(xfs:sn)"] = "Adds the option to the "..xfs.." internal hit only list"
DSC["remHitOnly(xfs:sn)"] = "Removes the option from the "..xfs.." internal only hit list"
DSC["addHitSkip(xfs:ss)"] = "Adds the option to the "..xfs.." internal ignore hit list"
DSC["remHitSkip(xfs:ss)"] = "Removes the option from the "..xfs.." internal ignore hit list"
DSC["addHitOnly(xfs:ss)"] = "Adds the option to the "..xfs.." internal hit only list"
DSC["remHitOnly(xfs:ss)"] = "Removes the option from the "..xfs.." internal only hit list"
DSC["getAttachEntity(xfs:)"] = "Returns the attachment entity of the "..xfs
DSC["setAttachEntity(xfs:e)"] = "Updates the attachment entity of the "..xfs
DSC["isIgnoreWorld(xfs:)"] = "Returns the ignore world flag of the "..xfs
DSC["setIsIgnoreWorld(xfs:n)"] = "Updates the ignore world flag of the "..xfs
DSC["getOrigin(xfs:)"] = "Returns "..xfs.." "..par[2]
DSC["getOriginLocal(xfs:)"] = "Returns "..xfs.." world "..par[2].." converted to "..par[1].." local axis"
DSC["getOriginLocal(xfs:e)"] = "Returns "..xfs.." world "..par[2].." converted to entity local axis"
DSC["getOriginLocal(xfs:va)"] = "Returns "..xfs.." world "..par[2].." converted to position/angle local axis"
DSC["getOriginWorld(xfs:)"] = "Returns "..xfs.." local "..par[2].." converted to "..par[1].." world axis"
DSC["getOriginWorld(xfs:e)"] = "Returns "..xfs.." local "..par[2].." converted to entity world axis"
DSC["getOriginWorld(xfs:va)"] = "Returns "..xfs.." local "..par[2].." converted to position/angle world axis"
DSC["setOrigin(xfs:v)"] = "Updates the "..xfs.." "..par[2]
DSC["getDirection(xfs:)"] = "Returns "..xfs.." "..par[3]
DSC["getDirectionLocal(xfs:)"] = "Returns "..xfs.." world "..par[3].." converted to "..par[1].." local axis"
DSC["getDirectionLocal(xfs:e)"] = "Returns "..xfs.." world "..par[3].." converted to entity local axis"
DSC["getDirectionLocal(xfs:a)"] = "Returns "..xfs.." world "..par[3].." converted to angle local axis"
DSC["getDirectionWorld(xfs:)"] = "Returns "..xfs.." local "..par[3].." converted to "..par[1].." world axis"
DSC["getDirectionWorld(xfs:e)"] = "Returns "..xfs.." local "..par[3].." converted to entity world axis"
DSC["getDirectionWorld(xfs:a)"] = "Returns "..xfs.." local "..par[3].." converted to angle world axis"
DSC["setDirection(xfs:v)"] = "Updates the "..xfs.." "..par[3]
DSC["getLength(xfs:)"] = "Returns "..xfs.." "..par[4]
DSC["setLength(xfs:n)"] = "Updates "..xfs.." "..par[4]
DSC["getMask(xfs:)"] = "Returns "..xfs.." trace hit mask enums MASK"
DSC["setMask(xfs:n)"] = "Updates "..xfs.." trace hit mask enums MASK"
DSC["getCollisionGroup(xfs:)"] = "Returns "..xfs.." trace collision group enums COLLISION_GROUP"
DSC["setCollisionGroup(xfs:n)"] = "Updates "..xfs.." trace collision group enums COLLISION_GROUP"
DSC["smpLocal(xfs:)"] = "Samples the "..xfs.." and updates the trace result according to "..par[1].." local axis"
DSC["smpWorld(xfs:)"] = "Samples the "..xfs.." and updates the trace result according to the world axis"
DSC["isHitNoDraw(xfs:)"] = "Returns the "..xfs.." sampled trace `HitNoDraw` flag"
DSC["isHitNonWorld(xfs:)"] = "Returns the "..xfs.." sampled trace `HitNonWorld` flag"
DSC["isHit(xfs:)"] = "Returns the "..xfs.." sampled trace `Hit` flag"
DSC["isHitSky(xfs:)"] = "Returns the "..xfs.." sampled trace `HitSky` flag"
DSC["isHitWorld(xfs:)"] = "Returns the "..xfs.." sampled trace `HitWorld` flag"
DSC["getHitBox(xfs:)"] = "Returns the "..xfs.." sampled trace `HitBox` number"
DSC["getMatType(xfs:)"] = "Returns the "..xfs.." sampled trace `MatType` material type number"
DSC["getHitGroup(xfs:)"] = "Returns the "..xfs.." sampled trace `HitGroup` group ID number"
DSC["getHitPos(xfs:)"] = "Returns the "..xfs.." sampled trace `HitPos` location vector"
DSC["getHitNormal(xfs:)"] = "Returns "..xfs.." the sampled trace surface `HitNormal` vector"
DSC["getNormal(xfs:)"] = "Returns the "..xfs.." sampled trace `Normal` aim vector"
DSC["getHitTexture(xfs:)"] = "Returns the "..xfs.." sampled trace `HitTexture` string"
DSC["getStartPos(xfs:)"] = "Returns the "..xfs.." sampled trace `StartPos` vector"
DSC["getSurfaceProps(xfs:)"] = "Returns the "..xfs.." sampled trace `SurfaceProps` ID type number"
DSC["getSurfacePropsName(xfs:)"] = "Returns the "..xfs.." sampled trace `SurfaceProps` ID type name string"
DSC["getPhysicsBone(xfs:)"] = "Returns the "..xfs.." sampled trace `PhysicsBone` ID number"
DSC["getFraction(xfs:)"] = "Returns the "..xfs.." sampled trace `Fraction` in the interval [0-1] number"
DSC["getFractionLength(xfs:)"] = "Returns the "..xfs.." sampled trace `Fraction` multiplied by its "..par[4].." number"
DSC["isStartSolid(xfs:)"] = "Returns the "..xfs.." sampled trace `StartSolid` flag"
DSC["isAllSolid(xfs:)"] = "Returns the "..xfs.." sampled trace `AllSolid` flag"
DSC["getFractionLeftSolid(xfs:)"] = "Returns the "..xfs.." sampled trace `FractionLeftSolid` in the interval [0-1] number"
DSC["getFractionLeftSolidLength(xfs:)"] = "Returns the "..xfs.." sampled trace `FractionLeftSolid` multiplied by its "..par[4].." number"
DSC["getEntity(xfs:)"] = "Returns the "..xfs.." sampled trace `Entity` entity"

return DSC
