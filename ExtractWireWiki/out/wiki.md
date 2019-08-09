|ˑˑˑˑˑˑˑInstance.creatorˑˑˑˑˑˑˑ|ˑOutˑ|ˑDescriptionˑ|
|------------------------------|-----|-------------|
|`newFTracer`(![image][ref-xxx])|![image][ref-xft]|Returns flash tracer relative to the world by zero origin position, zero direction vector, zero length distance|
|`newFTracer`(![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the world by length distance, direction vector, zero length distance|
|`newFTracer`(![image][ref-v])|![image][ref-xft]|Returns flash tracer relative to the world by origin position, zero direction vector, zero length distance|
|`newFTracer`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the world by origin position, direction vector from up, length distance|
|`newFTracer`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash tracer relative to the world by origin position, direction vector, length distance from direction vector|
|`newFTracer`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the world by origin position, direction vector, length distance|
|`noFTracer`(![image][ref-xxx])|![image][ref-xft]|Returns invalid flash tracer object|
|![image][ref-e]:`setFTracer`(![image][ref-xxx])|![image][ref-xft]|Returns flash tracer local to the entity by zero origin position, zero direction vector, zero length distance|
|![image][ref-e]:`setFTracer`(![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the entity by length distance, direction vector, zero length distance|
|![image][ref-e]:`setFTracer`(![image][ref-v])|![image][ref-xft]|Returns flash tracer local to the entity by origin position, zero direction vector, zero length distance|
|![image][ref-e]:`setFTracer`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the entity by origin position, direction vector from up, length distance|
|![image][ref-e]:`setFTracer`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash tracer local to the entity by origin position, direction vector, length distance from direction vector|
|![image][ref-e]:`setFTracer`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer local to the entity by origin position, direction vector, length distance|

|ˑˑˑˑˑˑˑˑˑˑˑClass.methodsˑˑˑˑˑˑˑˑˑˑˑ|ˑOutˑ|ˑDescriptionˑ|
|-----------------------------------|-----|-------------|
|![image][ref-xft]:`addEntHitOnly`(![image][ref-e])|![image][ref-xft]|Adds the entity to the flash tracer internal only hit list|
|![image][ref-xft]:`addEntHitSkip`(![image][ref-e])|![image][ref-xft]|Adds the entity to the flash tracer internal ignore hit list|
|![image][ref-xft]:`addHitOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Adds the option to the flash tracer internal hit only list|
|![image][ref-xft]:`addHitOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Adds the option to the flash tracer internal hit only list|
|![image][ref-xft]:`addHitSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Adds the option to the flash tracer internal ignore hit list|
|![image][ref-xft]:`addHitSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Adds the option to the flash tracer internal ignore hit list|
|![image][ref-xft]:`dumpItem`(![image][ref-n])|![image][ref-xft]|Dumps the flash tracer to the chat area by number identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s])|![image][ref-xft]|Dumps the flash tracer to the chat area by string identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Dumps the flash tracer by number identifier in the specified area by first argument|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Dumps the flash tracer by string identifier in the specified area by first argument|
|![image][ref-xft]:`getBase`(![image][ref-xxx])|![image][ref-e]|Returns the base attachment entity of the flash tracer|
|![image][ref-xft]:`getBone`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `PhysicsBone` `ID` number|
|![image][ref-xft]:`getCollideGroup`(![image][ref-xxx])|![image][ref-n]|Returns flash tracer [`trace-strict`](https://wiki.garrysmod.com/page/Structures/Trace) collision group enums [`COLLISION_GROUP`](https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP)|
|![image][ref-xft]:`getCopy`(![image][ref-xxx])|![image][ref-xft]|Returns flash tracer copy instance of the current object|
|![image][ref-xft]:`getDir`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer direction vector|
|![image][ref-xft]:`getDirLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer world direction vector converted to base attachment entity local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-a])|![image][ref-v]|Returns flash tracer world direction vector converted to angle local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-e])|![image][ref-v]|Returns flash tracer world direction vector converted to entity local axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer local direction vector converted to base attachment entity world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-a])|![image][ref-v]|Returns flash tracer local direction vector converted to angle world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-e])|![image][ref-v]|Returns flash tracer local direction vector converted to entity world axis|
|![image][ref-xft]:`getEntity`(![image][ref-xxx])|![image][ref-e]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Entity` entity|
|![image][ref-xft]:`getFraction`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Fraction` in the interval `[0-1]` number|
|![image][ref-xft]:`getFractionLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `FractionLeftSolid` in the interval `[0-1]` number|
|![image][ref-xft]:`getFractionLen`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Fraction` multiplied by its length distance number|
|![image][ref-xft]:`getFractionLenLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `FractionLeftSolid` multiplied by its length distance number|
|![image][ref-xft]:`getHitBox`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitBox` number|
|![image][ref-xft]:`getHitGroup`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitGroup` group `ID` number|
|![image][ref-xft]:`getHitNormal`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) surface `HitNormal` vector|
|![image][ref-xft]:`getHitPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitPos` location vector|
|![image][ref-xft]:`getHitTexture`(![image][ref-xxx])|![image][ref-s]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitTexture` string|
|![image][ref-xft]:`getLen`(![image][ref-xxx])|![image][ref-n]|Returns flash tracer length distance|
|![image][ref-xft]:`getMask`(![image][ref-xxx])|![image][ref-n]|Returns flash tracer [`trace-strict`](https://wiki.garrysmod.com/page/Structures/Trace) hit mask enums [`MASK`](https://wiki.garrysmod.com/page/Enums/MASK)|
|![image][ref-xft]:`getMatType`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `MatType` material type number|
|![image][ref-xft]:`getNormal`(![image][ref-xxx])|![image][ref-v]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Normal` aim vector|
|![image][ref-xft]:`getPos`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer origin position|
|![image][ref-xft]:`getPosLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer world origin position converted to base attachment entity local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-e])|![image][ref-v]|Returns flash tracer world origin position converted to entity local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash tracer world origin position converted to position/angle local axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer local origin position converted to base attachment entity world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-e])|![image][ref-v]|Returns flash tracer local origin position converted to entity world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash tracer local origin position converted to position/angle world axis|
|![image][ref-xft]:`getStart`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`trace-strict`](https://wiki.garrysmod.com/page/Structures/Trace) start poisition sent to [`trace-line`](https://wiki.garrysmod.com/page/util/TraceLine)|
|![image][ref-xft]:`getStartPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `StartPos` vector|
|![image][ref-xft]:`getStop`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`trace-strict`](https://wiki.garrysmod.com/page/Structures/Trace) stop poisition sent to [`trace-line`](https://wiki.garrysmod.com/page/util/TraceLine)|
|![image][ref-xft]:`getSurfPropsID`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `SurfaceProps` `ID` type number|
|![image][ref-xft]:`getSurfPropsName`(![image][ref-xxx])|![image][ref-s]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `SurfaceProps` `ID` type name string|
|![image][ref-xft]:`isAllSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `AllSolid` flag|
|![image][ref-xft]:`isHit`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Hit` flag|
|![image][ref-xft]:`isHitNoDraw`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitNoDraw` flag|
|![image][ref-xft]:`isHitNonWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitNonWorld` flag|
|![image][ref-xft]:`isHitSky`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitSky` flag|
|![image][ref-xft]:`isHitWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitWorld` flag|
|![image][ref-xft]:`isIgnoreWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer trace `IgnoreWorld` flag|
|![image][ref-xft]:`isStartSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `StartSolid` flag|
|![image][ref-xft]:`remBase`(![image][ref-xxx])|![image][ref-xft]|Removes the base attachment entity of the flash tracer|
|![image][ref-xft]:`remEntHitOnly`(![image][ref-e])|![image][ref-xft]|Removes the entity from the flash tracer internal only hit list|
|![image][ref-xft]:`remEntHitSkip`(![image][ref-e])|![image][ref-xft]|Removes the entity from the flash tracer internal ignore hit list|
|![image][ref-xft]:`remHit`(![image][ref-xxx])|![image][ref-xft]|Removes all the options from the flash tracer internal hit preferences|
|![image][ref-xft]:`remHit`(![image][ref-s])|![image][ref-xft]|Removes the option from the flash tracer internal hit preferences|
|![image][ref-xft]:`remHitOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash tracer internal only hit list|
|![image][ref-xft]:`remHitOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash tracer internal only hit list|
|![image][ref-xft]:`remHitSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash tracer internal ignore hit list|
|![image][ref-xft]:`remHitSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash tracer internal ignore hit list|
|![image][ref-xft]:`remSelf`(![image][ref-xxx])|![image][ref-n]|Removes the flash tracer from the list|
|![image][ref-xft]:`setBase`(![image][ref-e])|![image][ref-xft]|Updates the base attachment entity of the flash tracer|
|![image][ref-xft]:`setCollideGroup`(![image][ref-n])|![image][ref-xft]|Updates flash tracer [`trace-strict`](https://wiki.garrysmod.com/page/Structures/Trace) collision group enums [`COLLISION_GROUP`](https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP)|
|![image][ref-xft]:`setDir`(![image][ref-v])|![image][ref-xft]|Updates the flash tracer direction vector|
|![image][ref-xft]:`setIsIgnoreWorld`(![image][ref-n])|![image][ref-xft]|Updates the flash tracer trace `IgnoreWorld` flag|
|![image][ref-xft]:`setLen`(![image][ref-n])|![image][ref-xft]|Updates flash tracer length distance|
|![image][ref-xft]:`setMask`(![image][ref-n])|![image][ref-xft]|Updates flash tracer [`trace-strict`](https://wiki.garrysmod.com/page/Structures/Trace) hit mask enums [`MASK`](https://wiki.garrysmod.com/page/Enums/MASK)|
|![image][ref-xft]:`setPos`(![image][ref-v])|![image][ref-xft]|Updates the flash tracer origin position|
|![image][ref-xft]:`smpLocal`(![image][ref-xxx])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by base attachment entity local axis|
|![image][ref-xft]:`smpLocal`(![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by [base position `|` argument angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by entity position and forward vectors|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by argument [entity position `|` angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by argument [position `|` entity angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by [argument position `|` base angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by argument [position `|` angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-xxx])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by the world axis|
|![image][ref-xft]:`smpWorld`(![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by entity position and angle forward|
|![image][ref-xft]:`smpWorld`(![image][ref-e])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by entity position and forward vectors|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by argument [entity position `|` angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by argument [position `|` entity angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-v])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by position vector and entity forward|
|![image][ref-xft]:`smpWorld`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by argument [position `|` angle]|

|ˑGeneral.functionsˑˑ|ˑOutˑ|ˑDescriptionˑ|
|--------------------|-----|-------------|
|`maxFTracers`(![image][ref-xxx])|![image][ref-n]|Returns the upper flash tracer count|
|`sumFTracers`(![image][ref-xxx])|![image][ref-n]|Returns the used flash tracer count|

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
[ref-xft]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xft.png
[ref-xsc]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xsc.png
[ref-xxx]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xxx.png

