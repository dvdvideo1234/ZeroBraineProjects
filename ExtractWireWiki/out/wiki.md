### What does this extension include?
Tracers with [hit][ref_trace] and [ray][ref_ray] configuration. The difference with [wire rangers][ref_wranger]
is that this is a [dedicated class][ref_class_oop] being initialized once and used as many
times as it is needed, not creating an [instance][ref_oopinst] on every [E2][ref_exp2] [tick][ref_timere2] and later
wipe that [instance][ref_oopinst] out. It can extract every aspect of the [trace result structure][ref_trace] returned and
it can be sampled [locally][ref_localcrd] ( [`origin`][ref_position] and [`direction`][ref_orient] relative to
[`entity`][ref_entity] or `pos`/`dir`/`ang` ) or globally ( [`entity`][ref_entity] is not available and `pos`/`dir`/`ang`
are treated world-space data ). Also, it has better [performance][ref_perfe2] than the [regular wire rangers][ref_wranger].

### What is this thing designed for?
The `FTrace` class consists of fast performing traces object-oriented
instance that is designed to be `@persist`and initialized in expression
`first() || dupefinished()`. That way you create the tracer instance once
and you can use it as many times as you need, without creating a new one.

### What console variables can be used to setup it?
```
wire_expression2_ftrace_skip > Contains trace generator blacklisted methods ( ex. GetSkin/GetModel/IsVehicle )
wire_expression2_ftrace_only > Contains trace generator whitelisted methods ( ex. GetSkin/GetModel/IsVehicle )
wire_expression2_ftrace_dprn > Stores the default status output messages streaming destination
wire_expression2_ftrace_enst > Contains flag that enables status output messages
```

### How to create an instance then?
You can create a trace object by calling one of the dedicated creators `newFTrace` below
whenever you prefer to attach it to an entity or you prefer not to use the feature.
When sampled locally, it will use the [attachment entity][ref_entity] to [orient its direction][ref_orient]
and [length][ref_vec_norm] in [pure Lua][ref_lua]. You can also call the [class constructor][ref_class_con]
without an [entity][ref_entity] to make it world-space based. Remember that negating the trace length will
result in negating the trace direction. That is used because the trace length must always be positive so
the direction is reversed instead.

### Do you have an example by any chance?
The internal type of the class is `xft` and internal expression type `ftrace`, so to create 
a tracer instance you can take a [look at the example][ref_example].

### Can you show me the methods of the class?
The description of the API is provided in the table below.

|        Instance creator        | Out | Description |
|--------------------------------|-----|-------------|
|`newFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash trace relative to the world by zero origin position, zero direction vector, zero length distance|
|`newFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash trace relative to the world by length distance, direction vector, zero length distance|
|`newFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash trace relative to the world by origin position, zero direction vector, zero length distance|
|`newFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash trace relative to the world by origin position, direction vector from up, length distance|
|`newFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash trace relative to the world by origin position, direction vector, length distance from direction vector|
|`newFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash trace relative to the world by origin position, direction vector, length distance|
|`noFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns invalid flash trace object|

|           Class methods           | Out | Description |
|-----------------------------------|-----|-------------|
|![image][ref-xft]:`addEntHitOnly`(![image][ref-e])|![image][ref-xft]|Adds the entity to the flash trace internal only hit list|
|![image][ref-xft]:`addEntHitSkip`(![image][ref-e])|![image][ref-xft]|Adds the entity to the flash trace internal ignore hit list|
|![image][ref-xft]:`addHitOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Adds the option to the flash trace internal hit only list|
|![image][ref-xft]:`addHitOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Adds the option to the flash trace internal hit only list|
|![image][ref-xft]:`addHitSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Adds the option to the flash trace internal ignore hit list|
|![image][ref-xft]:`addHitSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Adds the option to the flash trace internal ignore hit list|
|![image][ref-xft]:`dumpItem`(![image][ref-n])|![image][ref-xft]|Dumps the flash trace to the chat area by number identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s])|![image][ref-xft]|Dumps the flash trace to the chat area by string identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Dumps the flash trace by number identifier in the specified area by first argument|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Dumps the flash trace by string identifier in the specified area by first argument|
|![image][ref-xft]:`getBase`(![image][ref-xxx])|![image][ref-e]|Returns the flash trace base attachment entity if available|
|![image][ref-xft]:`getBone`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `PhysicsBone` `ID` number|
|![image][ref-xft]:`getChip`(![image][ref-xxx])|![image][ref-e]|Returns the flash trace auto-assigned expression chip entity|
|![image][ref-xft]:`getCollideGroup`(![image][ref-xxx])|![image][ref-n]|Returns flash trace trace collision group enums [`COLLISION_GROUP`](https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP)|
|![image][ref-xft]:`getCopy`(![image][ref-xxx])|![image][ref-xft]|Returns flash trace copy instance of the current object|
|![image][ref-xft]:`getCopy`(![image][ref-e])|![image][ref-xft]|Returns flash trace copy instance of the current object using other entity|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-n])|![image][ref-xft]|Returns flash trace copy instance of the current object using other entity and length|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Returns flash trace copy instance of the current object using other entity and origin|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash trace copy instance of the current object using other entity, origin and length|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash trace copy instance of the current object using other entity, origin and direction|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash trace copy instance of the current object using other entity, origin, direction and length|
|![image][ref-xft]:`getCopy`(![image][ref-n])|![image][ref-xft]|Returns flash trace copy instance of the current object using other length|
|![image][ref-xft]:`getCopy`(![image][ref-v])|![image][ref-xft]|Returns flash trace copy instance of the current object using other origin|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash trace copy instance of the current object using other origin and length|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash trace copy instance of the current object using other origin and direction|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash trace copy instance of the current object using other origin, direction and length|
|![image][ref-xft]:`getDir`(![image][ref-xxx])|![image][ref-v]|Returns flash trace direction vector|
|![image][ref-xft]:`getDirLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash trace world direction vector converted to base attachment entity local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-a])|![image][ref-v]|Returns flash trace world direction vector converted to angle local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-e])|![image][ref-v]|Returns flash trace world direction vector converted to entity local axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash trace local direction vector converted to base attachment entity world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-a])|![image][ref-v]|Returns flash trace local direction vector converted to angle world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-e])|![image][ref-v]|Returns flash trace local direction vector converted to entity world axis|
|![image][ref-xft]:`getEntity`(![image][ref-xxx])|![image][ref-e]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Entity` entity|
|![image][ref-xft]:`getFraction`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Fraction` in the interval `[0-1]` number|
|![image][ref-xft]:`getFractionLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `FractionLeftSolid` in the interval `[0-1]` number|
|![image][ref-xft]:`getFractionLen`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Fraction` multiplied by its length distance number|
|![image][ref-xft]:`getFractionLenLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `FractionLeftSolid` multiplied by its length distance number|
|![image][ref-xft]:`getHitBox`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitBox` number|
|![image][ref-xft]:`getHitGroup`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitGroup` group `ID` number|
|![image][ref-xft]:`getHitNormal`(![image][ref-xxx])|![image][ref-v]|Returns flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) surface `HitNormal` vector|
|![image][ref-xft]:`getHitPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitPos` location vector|
|![image][ref-xft]:`getHitTexture`(![image][ref-xxx])|![image][ref-s]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitTexture` string|
|![image][ref-xft]:`getLen`(![image][ref-xxx])|![image][ref-n]|Returns flash trace length distance|
|![image][ref-xft]:`getMask`(![image][ref-xxx])|![image][ref-n]|Returns flash trace trace hit mask enums [`MASK`](https://wiki.garrysmod.com/page/Enums/MASK)|
|![image][ref-xft]:`getMatType`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `MatType` material type number|
|![image][ref-xft]:`getNormal`(![image][ref-xxx])|![image][ref-v]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Normal` aim vector|
|![image][ref-xft]:`getPos`(![image][ref-xxx])|![image][ref-v]|Returns flash trace origin position|
|![image][ref-xft]:`getPosLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash trace world origin position converted to base attachment entity local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-e])|![image][ref-v]|Returns flash trace world origin position converted to entity local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash trace world origin position converted to position/angle local axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash trace local origin position converted to base attachment entity world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-e])|![image][ref-v]|Returns flash trace local origin position converted to entity world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash trace local origin position converted to position/angle world axis|
|![image][ref-xft]:`getStart`(![image][ref-xxx])|![image][ref-v]|Returns flash trace trace start position sent to [`trace-line`](https://wiki.garrysmod.com/page/util/TraceLine)|
|![image][ref-xft]:`getStartPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `StartPos` vector|
|![image][ref-xft]:`getStop`(![image][ref-xxx])|![image][ref-v]|Returns flash trace trace stop position sent to [`trace-line`](https://wiki.garrysmod.com/page/util/TraceLine)|
|![image][ref-xft]:`getSurfPropsID`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `SurfaceProps` `ID` type number|
|![image][ref-xft]:`getSurfPropsName`(![image][ref-xxx])|![image][ref-s]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `SurfaceProps` `ID` type name string|
|![image][ref-xft]:`isAllSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `AllSolid` flag|
|![image][ref-xft]:`isHit`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `Hit` flag|
|![image][ref-xft]:`isHitNoDraw`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitNoDraw` flag|
|![image][ref-xft]:`isHitNonWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitNonWorld` flag|
|![image][ref-xft]:`isHitSky`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitSky` flag|
|![image][ref-xft]:`isHitWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `HitWorld` flag|
|![image][ref-xft]:`isIgnoreWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace trace `IgnoreWorld` flag|
|![image][ref-xft]:`isStartSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash trace [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) `StartSolid` flag|
|![image][ref-xft]:`rayAim`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Aims the flash trace ray at a given position using three numbers|
|![image][ref-xft]:`rayAim`(![image][ref-v])|![image][ref-xft]|Aims the flash trace ray at a given position using a vector|
|![image][ref-xft]:`rayAmend`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Amends the flash trace ray direction using three numbers|
|![image][ref-xft]:`rayAmend`(![image][ref-v])|![image][ref-xft]|Amends the flash trace ray direction using a vector|
|![image][ref-xft]:`rayAmend`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Amends the flash trace ray direction using vector and magnitude|
|![image][ref-xft]:`rayDiv`(![image][ref-n])|![image][ref-xft]|Contracts the flash trace ray with a number|
|![image][ref-xft]:`rayDiv`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Contracts the flash trace ray each component individually using three numbers|
|![image][ref-xft]:`rayDiv`(![image][ref-v])|![image][ref-xft]|Contracts the flash trace ray each component individually using a vector|
|![image][ref-xft]:`rayMove`(![image][ref-xxx])|![image][ref-xft]|Moves the flash trace ray with its own direction and magnitude|
|![image][ref-xft]:`rayMove`(![image][ref-n])|![image][ref-xft]|Moves the flash trace ray with its own direction and magnitude length|
|![image][ref-xft]:`rayMove`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Moves the flash trace ray with displacement as three numbers|
|![image][ref-xft]:`rayMove`(![image][ref-v])|![image][ref-xft]|Moves the flash trace ray with displacement vector|
|![image][ref-xft]:`rayMove`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Moves the flash trace ray with direction vector, magnitude length|
|![image][ref-xft]:`rayMul`(![image][ref-n])|![image][ref-xft]|Expands the flash trace ray with a number|
|![image][ref-xft]:`rayMul`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Expands the flash trace ray each component individually using three numbers|
|![image][ref-xft]:`rayMul`(![image][ref-v])|![image][ref-xft]|Expands the flash trace ray each component individually using a vector|
|![image][ref-xft]:`remBase`(![image][ref-xxx])|![image][ref-xft]|Removes the base attachment entity of the flash trace|
|![image][ref-xft]:`remEntHit`(![image][ref-xxx])|![image][ref-xft]|Removes all the entities from the flash trace internal hit list|
|![image][ref-xft]:`remEntHitOnly`(![image][ref-xxx])|![image][ref-xft]|Removes all the entities from the flash trace internal only hit list|
|![image][ref-xft]:`remEntHitOnly`(![image][ref-e])|![image][ref-xft]|Removes the entity from the flash trace internal only hit list|
|![image][ref-xft]:`remEntHitSkip`(![image][ref-xxx])|![image][ref-xft]|Removes all the entities from the flash trace internal ignore hit list|
|![image][ref-xft]:`remEntHitSkip`(![image][ref-e])|![image][ref-xft]|Removes the entity from the flash trace internal ignore hit list|
|![image][ref-xft]:`remHit`(![image][ref-xxx])|![image][ref-xft]|Removes all the options from the flash trace internal hit preferences|
|![image][ref-xft]:`remHit`(![image][ref-s])|![image][ref-xft]|Removes the option from the flash trace internal hit preferences|
|![image][ref-xft]:`remHitOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash trace internal only hit list|
|![image][ref-xft]:`remHitOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash trace internal only hit list|
|![image][ref-xft]:`remHitSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash trace internal ignore hit list|
|![image][ref-xft]:`remHitSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash trace internal ignore hit list|
|![image][ref-xft]:`setBase`(![image][ref-e])|![image][ref-xft]|Updates the flash trace base attachment entity|
|![image][ref-xft]:`setCollideGroup`(![image][ref-n])|![image][ref-xft]|Updates flash trace trace collision group enums [`COLLISION_GROUP`](https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP)|
|![image][ref-xft]:`setDir`(![image][ref-v])|![image][ref-xft]|Updates the flash trace direction vector|
|![image][ref-xft]:`setIsIgnoreWorld`(![image][ref-n])|![image][ref-xft]|Updates the flash trace trace `IgnoreWorld` flag|
|![image][ref-xft]:`setLen`(![image][ref-n])|![image][ref-xft]|Updates flash trace length distance|
|![image][ref-xft]:`setMask`(![image][ref-n])|![image][ref-xft]|Updates flash trace trace hit mask enums [`MASK`](https://wiki.garrysmod.com/page/Enums/MASK)|
|![image][ref-xft]:`setPos`(![image][ref-v])|![image][ref-xft]|Updates the flash trace origin position|
|![image][ref-xft]:`smpLocal`(![image][ref-xxx])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by base attachment entity local axis|
|![image][ref-xft]:`smpLocal`(![image][ref-a])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by base position, angle|
|![image][ref-xft]:`smpLocal`(![image][ref-e])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by entity position and forward vectors|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by entity position, angle|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by position, entity angle|
|![image][ref-xft]:`smpLocal`(![image][ref-v])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by position, base angle|
|![image][ref-xft]:`smpLocal`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by position, angle|
|![image][ref-xft]:`smpWorld`(![image][ref-xxx])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by the world axis|
|![image][ref-xft]:`smpWorld`(![image][ref-a])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by entity position and angle forward|
|![image][ref-xft]:`smpWorld`(![image][ref-e])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by entity position and forward vectors|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by entity position, angle|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by position, entity angle|
|![image][ref-xft]:`smpWorld`(![image][ref-v])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by position vector and entity forward|
|![image][ref-xft]:`smpWorld`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash trace and updates the [`trace-result`](https://wiki.garrysmod.com/page/Structures/TraceResult) by position, angle|

|    General functions    | Out | Description |
|-------------------------|-----|-------------|
|![image][ref-e]:`setFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash trace local to the entity by zero origin position, zero direction vector, zero length distance|
|![image][ref-e]:`setFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash trace relative to the entity by length distance, direction vector, zero length distance|
|![image][ref-e]:`setFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash trace local to the entity by origin position, zero direction vector, zero length distance|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash trace relative to the entity by origin position, direction vector from up, length distance|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash trace local to the entity by origin position, direction vector, length distance from direction vector|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash trace local to the entity by origin position, direction vector, length distance|

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

[ref_class_oop]: https://en.wikipedia.org/wiki/Class_(computer_programming)
[ref_example]: https://github.com/dvdvideo1234/ControlSystemsE2/blob/master/data/Expression2/e2_code_test_ftrace.txt
[ref_trace]: https://wiki.garrysmod.com/page/Structures/TraceResult
[ref_class_con]: https://en.wikipedia.org/wiki/Constructor_(object-oriented_programming)
[ref_entity]: https://wiki.garrysmod.com/page/Global/Entity
[ref_orient]: https://en.wikipedia.org/wiki/Orientation_(geometry)
[ref_vec_norm]: https://en.wikipedia.org/wiki/Euclidean_vector#Length
[ref_lua]: https://en.wikipedia.org/wiki/Lua_(programming_language)
[ref_exp2]: https://github.com/wiremod/wire/wiki/Expression-2
[ref_ray]: https://en.wikipedia.org/wiki/Line_(geometry)#Ray
[ref_wranger]: https://github.com/wiremod/wire/wiki/Expression-2#built-in-ranger
[ref_oopinst]: https://en.wikipedia.org/wiki/Instance_(computer_science)
[ref_perfe2]: https://github.com/wiremod/wire/wiki/Expression-2#performance
[ref_localcrd]: https://en.wikipedia.org/wiki/Local_coordinates
[ref_position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref_timere2]: https://github.com/wiremod/wire/wiki/Expression-2#timer
[ref_awaree2]: https://github.com/wiremod/wire/wiki/Expression-2#self-aware
