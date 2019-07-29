|ˑˑˑˑˑˑˑInstance.creatorˑˑˑˑˑˑˑ|ˑOutˑ|ˑDescriptionˑ|
|------------------------------|-----|-------------|
|maxFSensors(![image][ref-xxx])|![image][ref-n]|Returns the upper flash sensor count|
|newFSensor(![image][ref-xxx])|![image][ref-xfs]|Returns flash sensor relative to the world by zero origin position, zero direction vector, zero length distance|
|newFSensor(![image][ref-v])|![image][ref-xfs]|Returns flash sensor relative to the world by origin position, zero direction vector, zero length distance|
|newFSensor(![image][ref-v],![image][ref-v])|![image][ref-xfs]|Returns flash sensor relative to the world by origin position, direction vector, zero length distance|
|newFSensor(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xfs]|Returns flash sensor relative to the world by origin position, direction vector, length distance|
|noFSensor(![image][ref-xxx])|![image][ref-xfs]|Returns invalid flash sensor object|
|![image][ref-e]:setFSensor(![image][ref-xxx])|![image][ref-xfs]|Returns flash sensor local to the entity by zero origin position, zero direction vector, zero length distance|
|![image][ref-e]:setFSensor(![image][ref-v])|![image][ref-xfs]|Returns flash sensor local to the entity by origin position, zero direction vector, zero length distance|
|![image][ref-e]:setFSensor(![image][ref-v],![image][ref-v])|![image][ref-xfs]|Returns flash sensor local to the entity by origin position, direction vector, zero length distance|
|![image][ref-e]:setFSensor(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xfs]|Returns flash sensor local to the entity by origin position, direction vector, length distance|
|sumFSensors(![image][ref-xxx])|![image][ref-n]|Returns the used flash sensor count|

|ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑClass.methodsˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ|ˑOutˑ|ˑDescriptionˑ|
|--------------------------------------------------|-----|-------------|
|![image][ref-xfs]:addEntityHitOnly(![image][ref-e])|![image][ref-xfs]|Adds the entity to the flash sensor internal only hit list|
|![image][ref-xfs]:addEntityHitSkip(![image][ref-e])|![image][ref-xfs]|Adds the entity to the flash sensor internal ignore hit list|
|![image][ref-xfs]:addHitOnly(![image][ref-s],![image][ref-n])|![image][ref-xfs]|Adds the option to the flash sensor internal hit only list|
|![image][ref-xfs]:addHitOnly(![image][ref-s],![image][ref-s])|![image][ref-xfs]|Adds the option to the flash sensor internal hit only list|
|![image][ref-xfs]:addHitSkip(![image][ref-s],![image][ref-n])|![image][ref-xfs]|Adds the option to the flash sensor internal ignore hit list|
|![image][ref-xfs]:addHitSkip(![image][ref-s],![image][ref-s])|![image][ref-xfs]|Adds the option to the flash sensor internal ignore hit list|
|![image][ref-xfs]:getAttachEntity(![image][ref-xxx])|![image][ref-e]|Returns the attachment entity of the flash sensor|
|![image][ref-xfs]:getCollisionGroup(![image][ref-xxx])|![image][ref-n]|Returns flash sensor [`TRACE_IN`](https://wiki.garrysmod.com/page/Structures/Trace) collision group enums [`COLLISION_GROUP`](https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP)|
|![image][ref-xfs]:getCopy(![image][ref-xxx])|![image][ref-xfs]|Returns flash sensor copy instance of the current object|
|![image][ref-xfs]:getDirection(![image][ref-xxx])|![image][ref-v]|Returns flash sensor direction vector|
|![image][ref-xfs]:getDirectionLocal(![image][ref-xxx])|![image][ref-v]|Returns flash sensor world direction vector converted to attachment entity local axis|
|![image][ref-xfs]:getDirectionLocal(![image][ref-a])|![image][ref-v]|Returns flash sensor world direction vector converted to angle local axis|
|![image][ref-xfs]:getDirectionLocal(![image][ref-e])|![image][ref-v]|Returns flash sensor world direction vector converted to entity local axis|
|![image][ref-xfs]:getDirectionWorld(![image][ref-xxx])|![image][ref-v]|Returns flash sensor local direction vector converted to attachment entity world axis|
|![image][ref-xfs]:getDirectionWorld(![image][ref-a])|![image][ref-v]|Returns flash sensor local direction vector converted to angle world axis|
|![image][ref-xfs]:getDirectionWorld(![image][ref-e])|![image][ref-v]|Returns flash sensor local direction vector converted to entity world axis|
|![image][ref-xfs]:getEntity(![image][ref-xxx])|![image][ref-e]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Entity` entity|
|![image][ref-xfs]:getFraction(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Fraction` in the interval `[0-1]` number|
|![image][ref-xfs]:getFractionLeftSolid(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `FractionLeftSolid` in the interval `[0-1]` number|
|![image][ref-xfs]:getFractionLeftSolidLength(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `FractionLeftSolid` multiplied by its length distance number|
|![image][ref-xfs]:getFractionLength(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Fraction` multiplied by its length distance number|
|![image][ref-xfs]:getHitBox(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitBox` number|
|![image][ref-xfs]:getHitGroup(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitGroup` group `ID` number|
|![image][ref-xfs]:getHitNormal(![image][ref-xxx])|![image][ref-v]|Returns flash sensor the [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) surface `HitNormal` vector|
|![image][ref-xfs]:getHitPos(![image][ref-xxx])|![image][ref-v]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitPos` location vector|
|![image][ref-xfs]:getHitTexture(![image][ref-xxx])|![image][ref-s]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitTexture` string|
|![image][ref-xfs]:getLength(![image][ref-xxx])|![image][ref-n]|Returns flash sensor length distance|
|![image][ref-xfs]:getMask(![image][ref-xxx])|![image][ref-n]|Returns flash sensor [`TRACE_IN`](https://wiki.garrysmod.com/page/Structures/Trace) hit mask enums [`MASK`](https://wiki.garrysmod.com/page/Enums/MASK)|
|![image][ref-xfs]:getMatType(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `MatType` material type number|
|![image][ref-xfs]:getNormal(![image][ref-xxx])|![image][ref-v]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Normal` aim vector|
|![image][ref-xfs]:getOrigin(![image][ref-xxx])|![image][ref-v]|Returns flash sensor origin position|
|![image][ref-xfs]:getOriginLocal(![image][ref-xxx])|![image][ref-v]|Returns flash sensor world origin position converted to attachment entity local axis|
|![image][ref-xfs]:getOriginLocal(![image][ref-e])|![image][ref-v]|Returns flash sensor world origin position converted to entity local axis|
|![image][ref-xfs]:getOriginLocal(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash sensor world origin position converted to position/angle local axis|
|![image][ref-xfs]:getOriginWorld(![image][ref-xxx])|![image][ref-v]|Returns flash sensor local origin position converted to attachment entity world axis|
|![image][ref-xfs]:getOriginWorld(![image][ref-e])|![image][ref-v]|Returns flash sensor local origin position converted to entity world axis|
|![image][ref-xfs]:getOriginWorld(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash sensor local origin position converted to position/angle world axis|
|![image][ref-xfs]:getPhysicsBone(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `PhysicsBone` `ID` number|
|![image][ref-xfs]:getStart(![image][ref-xxx])|![image][ref-v]|Returns flash sensor [`TRACE_IN`](https://wiki.garrysmod.com/page/Structures/Trace) start poisition sent to TraceLine|
|![image][ref-xfs]:getStartPos(![image][ref-xxx])|![image][ref-v]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `StartPos` vector|
|![image][ref-xfs]:getStop(![image][ref-xxx])|![image][ref-v]|Returns flash sensor [`TRACE_IN`](https://wiki.garrysmod.com/page/Structures/Trace) stop poisition sent to TraceLine|
|![image][ref-xfs]:getSurfaceProps(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `SurfaceProps` `ID` type number|
|![image][ref-xfs]:getSurfacePropsName(![image][ref-xxx])|![image][ref-s]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `SurfaceProps` `ID` type name string|
|![image][ref-xfs]:isAllSolid(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `AllSolid` flag|
|![image][ref-xfs]:isHit(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Hit` flag|
|![image][ref-xfs]:isHitNoDraw(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitNoDraw` flag|
|![image][ref-xfs]:isHitNonWorld(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitNonWorld` flag|
|![image][ref-xfs]:isHitSky(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitSky` flag|
|![image][ref-xfs]:isHitWorld(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitWorld` flag|
|![image][ref-xfs]:isIgnoreWorld(![image][ref-xxx])|![image][ref-n]|Returns flash sensor [`TRACE_IN`](https://wiki.garrysmod.com/page/Structures/Trace) ignore world flag|
|![image][ref-xfs]:isStartSolid(![image][ref-xxx])|![image][ref-n]|Returns the flash sensor [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) `StartSolid` flag|
|![image][ref-xfs]:remEntityHitOnly(![image][ref-e])|![image][ref-xfs]|Removes the entity from the flash sensor internal only hit list|
|![image][ref-xfs]:remEntityHitSkip(![image][ref-e])|![image][ref-xfs]|Removes the entity from the flash sensor internal ignore hit list|
|![image][ref-xfs]:remHit(![image][ref-xxx])|![image][ref-xfs]|Removes all the options from the flash sensor internal hit preferences|
|![image][ref-xfs]:remHit(![image][ref-s])|![image][ref-xfs]|Removes the option from the flash sensor internal hit preferences|
|![image][ref-xfs]:remHitOnly(![image][ref-s],![image][ref-n])|![image][ref-xfs]|Removes the option from the flash sensor internal only hit list|
|![image][ref-xfs]:remHitOnly(![image][ref-s],![image][ref-s])|![image][ref-xfs]|Removes the option from the flash sensor internal only hit list|
|![image][ref-xfs]:remHitSkip(![image][ref-s],![image][ref-n])|![image][ref-xfs]|Removes the option from the flash sensor internal ignore hit list|
|![image][ref-xfs]:remHitSkip(![image][ref-s],![image][ref-s])|![image][ref-xfs]|Removes the option from the flash sensor internal ignore hit list|
|![image][ref-xfs]:remSelf(![image][ref-xxx])|![image][ref-n]|Removes the flash sensor from the list|
|![image][ref-xfs]:setAttachEntity(![image][ref-e])|![image][ref-xfs]|Updates the attachment entity of the flash sensor|
|![image][ref-xfs]:setCollisionGroup(![image][ref-n])|![image][ref-xfs]|Updates flash sensor [`TRACE_IN`](https://wiki.garrysmod.com/page/Structures/Trace) collision group enums [`COLLISION_GROUP`](https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP)|
|![image][ref-xfs]:setDirection(![image][ref-v])|![image][ref-xfs]|Updates the flash sensor direction vector|
|![image][ref-xfs]:setIsIgnoreWorld(![image][ref-n])|![image][ref-xfs]|Updates flash sensor [`TRACE_IN`](https://wiki.garrysmod.com/page/Structures/Trace) ignore world flag|
|![image][ref-xfs]:setLength(![image][ref-n])|![image][ref-xfs]|Updates flash sensor length distance|
|![image][ref-xfs]:setMask(![image][ref-n])|![image][ref-xfs]|Updates flash sensor [`TRACE_IN`](https://wiki.garrysmod.com/page/Structures/Trace) hit mask enums [`MASK`](https://wiki.garrysmod.com/page/Enums/MASK)|
|![image][ref-xfs]:setOrigin(![image][ref-v])|![image][ref-xfs]|Updates the flash sensor origin position|
|![image][ref-xfs]:smpLocal(![image][ref-xxx])|![image][ref-xfs]|Samples the flash sensor and updates the [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) according to attachment entity local axis|
|![image][ref-xfs]:smpLocal(![image][ref-e])|![image][ref-xfs]|Samples the flash sensor and updates the [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) according to argument local axis|
|![image][ref-xfs]:smpWorld(![image][ref-xxx])|![image][ref-xfs]|Samples the flash sensor and updates the [`TRACE_OUT`](https://wiki.garrysmod.com/page/Structures/TraceResult) according to the world axis|

[ref-a]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-a.png
[ref-b]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-b.png
[ref-c]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-c.png
[ref-e]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-e.png
[ref-xm2]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xm2.png
[ref-m]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-m.png
[ref-xm4]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xm4.png
[ref-n]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-n.png
[ref-q]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-q.png
[ref-r]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-r.png
[ref-s]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-s.png
[ref-t]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-t.png
[ref-xv2]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xv2.png
[ref-v]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-v.png
[ref-xv4]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xv4.png
[ref-xrd]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xrd.png
[ref-xwl]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xwl.png
[ref-xfs]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xfs.png
[ref-xsc]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xsc.png
[ref-xxx]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xxx.png

