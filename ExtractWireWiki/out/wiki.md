### What does this extension include?
Tracers with [hit][ref_trace-dt] and [ray][ref_ray] configuration. The difference with [wire rangers][ref_wranger]
is that this is a [dedicated class][ref_class_oop] being initialized once and used as many
times as it is needed, not creating an [instance][ref_oopinst] on every [E2][ref_exp2] [tick][ref_timere2] and later
wipe that [instance][ref_oopinst] out. It can extract every aspect of the [trace result structure][ref_trace-rz] returned and
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

### How can I configure the trace filter?
There are currently three types of trace filters in [Garry's mod][ref-gmod] that you can put in the
[`trace data`][ref_trace-dt].`filter` value. Utilizing the method `getFilterMode` will return the
current tracer filter operation mode. The filter configuration is `NIL` by default  
 1. [Entity][ref_entity] reference directly written to the filter. This entity is skipped by the trace  
    This filter mode is activated by utilizing the `setFilterEnt` method by `Ent` as `entity`
 2. [Entity][ref_entity] sequential table ( array ) in the filter. Every item is skipped by the trace  
    This filter mode is activated by utilizing the `setFilterEar` method by `Ear` as `entity array`
 3. [Finction][ref_entity] callback routine. This is slower but the most uiversal method available   
    This filter mode is activated by utilizing the `setFilterFnc` method by `Fnc` as `function`
 4. User can also clear the filter entierly by utilizing the `remFilter` method

### Do you have an example by any chance?
The internal type of the class is `xft` and internal expression type `ftrace`, so to create 
a tracer instance you can take a [look at the example][ref_example].

### Can you show me the methods of the class?
The description of the API is provided in the table below.

|        Instance creator        | Out | Description |
|:-------------------------------|:---:|:------------|
|`newFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the world by zero [`origin`][ref-6-origin] [`position`][ref-7-position], up [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`direction`][ref-2-direction] [`length`][ref-8-length] [`distance`][ref-9-distance]|
|`newFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the world by zero [`origin`][ref-6-origin] [`position`][ref-7-position], up [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`length`][ref-8-length] [`distance`][ref-9-distance]|
|`newFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the world by [`origin`][ref-6-origin] [`position`][ref-7-position], up [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`direction`][ref-2-direction] [`length`][ref-8-length] [`distance`][ref-9-distance]|
|`newFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the world by [`origin`][ref-6-origin] [`position`][ref-7-position], up [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`length`][ref-8-length] [`distance`][ref-9-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the world by [`origin`][ref-6-origin] [`position`][ref-7-position], [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`direction`][ref-2-direction] [`length`][ref-8-length] [`distance`][ref-9-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the world by [`origin`][ref-6-origin] [`position`][ref-7-position], [`direction`][ref-2-direction] [`vector`][ref-3-vector], [`length`][ref-8-length] [`distance`][ref-9-distance]|
|`noFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns invalid flash [`trace`][ref-1-trace] object|

|           Class methods           | Out | Description |
|:----------------------------------|:---:|:------------|
|![image][ref-xft]:`dumpItem`(![image][ref-n])|![image][ref-xft]|Dumps the flash [`trace`][ref-1-trace] to the chat area by [`number`][ref-5-number] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s])|![image][ref-xft]|Dumps the flash [`trace`][ref-1-trace] to the chat area by [`string`][ref-17-string] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Dumps the flash [`trace`][ref-1-trace] by [`number`][ref-5-number] identifier in the specified area by first argument|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Dumps the flash [`trace`][ref-1-trace] by [`string`][ref-17-string] identifier in the specified area by first argument|
|![image][ref-xft]:`getBase`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-1-trace] base attachment [`entity`][ref-4-entity] if available|
|![image][ref-xft]:`getChip`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-1-trace] auto-assigned expression chip [`entity`][ref-4-entity]|
|![image][ref-xft]:`getCollideGroup`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-1-trace] [`trace`][ref-1-trace] collision group [`enums`][ref-11-enums] [`COLLISION_GROUP`][ref-12-COLLISION_GROUP]|
|![image][ref-xft]:`getCopy`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object|
|![image][ref-xft]:`getCopy`(![image][ref-e])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`entity`][ref-4-entity]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`entity`][ref-4-entity] and [`length`][ref-8-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`entity`][ref-4-entity] and [`origin`][ref-6-origin]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`entity`][ref-4-entity], [`origin`][ref-6-origin] and [`length`][ref-8-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`entity`][ref-4-entity], [`origin`][ref-6-origin] and [`direction`][ref-2-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`entity`][ref-4-entity], [`origin`][ref-6-origin], [`direction`][ref-2-direction] and [`length`][ref-8-length]|
|![image][ref-xft]:`getCopy`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`length`][ref-8-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`origin`][ref-6-origin]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`origin`][ref-6-origin] and [`length`][ref-8-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`origin`][ref-6-origin] and [`direction`][ref-2-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] copy instance of the current object with other [`origin`][ref-6-origin], [`direction`][ref-2-direction] and [`length`][ref-8-length]|
|![image][ref-xft]:`getDir`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] [`direction`][ref-2-direction] [`vector`][ref-3-vector]|
|![image][ref-xft]:`getDirLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] world [`direction`][ref-2-direction] [`vector`][ref-3-vector] converted to base attachment [`entity`][ref-4-entity] local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] world [`direction`][ref-2-direction] [`vector`][ref-3-vector] converted to [`angle`][ref-15-angle] local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] world [`direction`][ref-2-direction] [`vector`][ref-3-vector] converted to [`entity`][ref-4-entity] local axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] local [`direction`][ref-2-direction] [`vector`][ref-3-vector] converted to base attachment [`entity`][ref-4-entity] world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] local [`direction`][ref-2-direction] [`vector`][ref-3-vector] converted to [`angle`][ref-15-angle] world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] local [`direction`][ref-2-direction] [`vector`][ref-3-vector] converted to [`entity`][ref-4-entity] world axis|
|![image][ref-xft]:`getDisplaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `DispFlags` [`DISPSURF`][ref-24-DISPSURF] [`bitmask`][ref-25-bitmask]|
|![image][ref-xft]:`getEar`(![image][ref-xxx])|![image][ref-r]|Returns the configuration used by the [`entity`][ref-4-entity] [`array`][ref-14-array] filter|
|![image][ref-xft]:`getEarID`(![image][ref-xxx])|![image][ref-r]|Returns the configuration used by the [`entity`][ref-4-entity] [`array`][ref-14-array] filter as `ID` indices|
|![image][ref-xft]:`getEarSZ`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`entity`][ref-4-entity] filter [`array`][ref-14-array] size|
|![image][ref-xft]:`getEntity`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `Entity` [`entity`][ref-4-entity]|
|![image][ref-xft]:`getFilterMode`(![image][ref-xxx])|![image][ref-s]|Returns flash tracer filter working mode|
|![image][ref-xft]:`getFraction`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `Fraction` in the interval `[0-1]` [`number`][ref-5-number]|
|![image][ref-xft]:`getFractionLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `FractionLeftSolid` in the interval `[0-1]` [`number`][ref-5-number]|
|![image][ref-xft]:`getFractionLen`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `Fraction` multiplied by its [`length`][ref-8-length] [`distance`][ref-9-distance] [`number`][ref-5-number]|
|![image][ref-xft]:`getFractionLenLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `FractionLeftSolid` multiplied by its [`length`][ref-8-length] [`distance`][ref-9-distance] [`number`][ref-5-number]|
|![image][ref-xft]:`getHitBox`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `HitBox` [`number`][ref-5-number]|
|![image][ref-xft]:`getHitContents`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] hit [`surface`][ref-27-surface] `Contents` [`CONTENTS`][ref-28-CONTENTS] [`bitmask`][ref-25-bitmask]|
|![image][ref-xft]:`getHitGroup`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `HitGroup` group `ID` [`number`][ref-5-number]|
|![image][ref-xft]:`getHitNormal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] [`surface`][ref-27-surface] `HitNormal` [`vector`][ref-3-vector]|
|![image][ref-xft]:`getHitPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `HitPos` location [`vector`][ref-3-vector]|
|![image][ref-xft]:`getHitTexture`(![image][ref-xxx])|![image][ref-s]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `HitTexture` [`string`][ref-17-string]|
|![image][ref-xft]:`getLen`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-1-trace] [`length`][ref-8-length] [`distance`][ref-9-distance]|
|![image][ref-xft]:`getMask`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-1-trace] [`trace`][ref-1-trace] hit [`mask`][ref-18-mask] [`enums`][ref-11-enums] [`MASK`][ref-19-MASK]|
|![image][ref-xft]:`getMatType`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `MatType` material type [`number`][ref-5-number]|
|![image][ref-xft]:`getNormal`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `Normal` aim [`vector`][ref-3-vector]|
|![image][ref-xft]:`getPhysicsBoneID`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `PhysicsBone` `ID` [`number`][ref-5-number]|
|![image][ref-xft]:`getPlayer`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-1-trace] auto-assigned expression chip player|
|![image][ref-xft]:`getPos`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] [`origin`][ref-6-origin] [`position`][ref-7-position]|
|![image][ref-xft]:`getPosLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] world [`origin`][ref-6-origin] [`position`][ref-7-position] converted to base attachment [`entity`][ref-4-entity] local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] world [`origin`][ref-6-origin] [`position`][ref-7-position] converted to [`entity`][ref-4-entity] local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] world [`origin`][ref-6-origin] [`position`][ref-7-position] converted to [`position`][ref-7-position]/[`angle`][ref-15-angle] local axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] local [`origin`][ref-6-origin] [`position`][ref-7-position] converted to base attachment [`entity`][ref-4-entity] world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] local [`origin`][ref-6-origin] [`position`][ref-7-position] converted to [`entity`][ref-4-entity] world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] local [`origin`][ref-6-origin] [`position`][ref-7-position] converted to [`position`][ref-7-position]/[`angle`][ref-15-angle] world axis|
|![image][ref-xft]:`getStart`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] [`trace`][ref-1-trace] start [`position`][ref-7-position] sent to [`trace-line`][ref-16-trace-line]|
|![image][ref-xft]:`getStartPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `StartPos` [`vector`][ref-3-vector]|
|![image][ref-xft]:`getStop`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] [`trace`][ref-1-trace] stop [`position`][ref-7-position] sent to [`trace-line`][ref-16-trace-line]|
|![image][ref-xft]:`getSurfPropsID`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `SurfaceProps` `ID` type [`number`][ref-5-number]|
|![image][ref-xft]:`getSurfPropsName`(![image][ref-xxx])|![image][ref-s]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `SurfaceProps` `ID` type name [`string`][ref-17-string]|
|![image][ref-xft]:`getSurfaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `SurfaceFlags` [`SURF`][ref-26-SURF] [`bitmask`][ref-25-bitmask]|
|![image][ref-xft]:`insEar`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-4-entity] in the filter list|
|![image][ref-xft]:`insEar`(![image][ref-r])|![image][ref-xft]|Inserts the [`entities`][ref-20-entities] from the [`array`][ref-14-array] in the filter list|
|![image][ref-xft]:`insEar`(![image][ref-t])|![image][ref-xft]|Inserts the [`entities`][ref-20-entities] from the table in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-n])|![image][ref-xft]|Inserts the [`entity`][ref-4-entity] `ID` in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-r])|![image][ref-xft]|Inserts the [`entity`][ref-4-entity] `ID` from the [`array`][ref-14-array] in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-t])|![image][ref-xft]|Inserts the [`entity`][ref-4-entity] `ID` from the table in the filter list|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-1-trace] internal hit only list|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-1-trace] internal hit only list|
|![image][ref-xft]:`insFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-4-entity] to the flash [`trace`][ref-1-trace] internal only hit list|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-1-trace] internal ignore hit list|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-1-trace] internal ignore hit list|
|![image][ref-xft]:`insFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-4-entity] to the flash [`trace`][ref-1-trace] internal ignore hit list|
|![image][ref-xft]:`isAllSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `AllSolid` flag|
|![image][ref-xft]:`isHit`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `Hit` flag|
|![image][ref-xft]:`isHitNoDraw`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `HitNoDraw` flag|
|![image][ref-xft]:`isHitNonWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `HitNonWorld` flag|
|![image][ref-xft]:`isHitSky`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `HitSky` flag|
|![image][ref-xft]:`isHitWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `HitWorld` flag|
|![image][ref-xft]:`isIgnoreWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace`][ref-1-trace] `IgnoreWorld` flag|
|![image][ref-xft]:`isStartSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-1-trace] [`trace-result`][ref-10-trace-result] `StartSolid` flag|
|![image][ref-xft]:`rayAim`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Aims the flash [`trace`][ref-1-trace] ray at a given [`position`][ref-7-position] using three [`numbers`][ref-13-numbers]|
|![image][ref-xft]:`rayAim`(![image][ref-v])|![image][ref-xft]|Aims the flash [`trace`][ref-1-trace] ray at a given [`position`][ref-7-position] using a [`vector`][ref-3-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Amends the flash [`trace`][ref-1-trace] ray [`direction`][ref-2-direction] using three [`numbers`][ref-13-numbers]|
|![image][ref-xft]:`rayAmend`(![image][ref-v])|![image][ref-xft]|Amends the flash [`trace`][ref-1-trace] ray [`direction`][ref-2-direction] using a [`vector`][ref-3-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Amends the flash [`trace`][ref-1-trace] ray [`direction`][ref-2-direction] using [`vector`][ref-3-vector] and [`magnitude`][ref-21-magnitude]|
|![image][ref-xft]:`rayDiv`(![image][ref-n])|![image][ref-xft]|Contracts the flash [`trace`][ref-1-trace] ray with a [`number`][ref-5-number]|
|![image][ref-xft]:`rayDiv`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Contracts the flash [`trace`][ref-1-trace] ray each component individually using three [`numbers`][ref-13-numbers]|
|![image][ref-xft]:`rayDiv`(![image][ref-v])|![image][ref-xft]|Contracts the flash [`trace`][ref-1-trace] ray each component individually using a [`vector`][ref-3-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-xxx])|![image][ref-xft]|Moves the flash [`trace`][ref-1-trace] ray with its own [`direction`][ref-2-direction] and [`magnitude`][ref-21-magnitude]|
|![image][ref-xft]:`rayMove`(![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-1-trace] ray with its own [`direction`][ref-2-direction] and [`magnitude`][ref-21-magnitude] [`length`][ref-8-length]|
|![image][ref-xft]:`rayMove`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-1-trace] ray with displacement as three [`numbers`][ref-13-numbers]|
|![image][ref-xft]:`rayMove`(![image][ref-v])|![image][ref-xft]|Moves the flash [`trace`][ref-1-trace] ray with displacement [`vector`][ref-3-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-1-trace] ray with [`direction`][ref-2-direction] [`vector`][ref-3-vector], [`magnitude`][ref-21-magnitude] [`length`][ref-8-length]|
|![image][ref-xft]:`rayMul`(![image][ref-n])|![image][ref-xft]|Expands the flash [`trace`][ref-1-trace] ray with a [`number`][ref-5-number]|
|![image][ref-xft]:`rayMul`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Expands the flash [`trace`][ref-1-trace] ray each component individually using three [`numbers`][ref-13-numbers]|
|![image][ref-xft]:`rayMul`(![image][ref-v])|![image][ref-xft]|Expands the flash [`trace`][ref-1-trace] ray each component individually using a [`vector`][ref-3-vector]|
|![image][ref-xft]:`remBase`(![image][ref-xxx])|![image][ref-xft]|Removes the base attachment [`entity`][ref-4-entity] of the flash [`trace`][ref-1-trace]|
|![image][ref-xft]:`remEar`(![image][ref-xxx])|![image][ref-xft]|Removes all [`entities`][ref-20-entities] from the filter list|
|![image][ref-xft]:`remEar`(![image][ref-e])|![image][ref-xft]|Removes the specified [`entity`][ref-4-entity] from the filter list|
|![image][ref-xft]:`remEarID`(![image][ref-n])|![image][ref-xft]|Removes the specified [`entity`][ref-4-entity] by `ID` from the filter list|
|![image][ref-xft]:`remEarN`(![image][ref-n])|![image][ref-xft]|Removes an [`entity`][ref-4-entity] using the specified sequential [`number`][ref-5-number]|
|![image][ref-xft]:`remFilter`(![image][ref-xxx])|![image][ref-xft]|Removes the filter from the [`trace`][ref-1-trace] configuration|
|![image][ref-xft]:`remFnc`(![image][ref-xxx])|![image][ref-xft]|Removes all the options from the flash [`trace`][ref-1-trace] internal hit preferences|
|![image][ref-xft]:`remFnc`(![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-1-trace] internal hit preferences|
|![image][ref-xft]:`remFncEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-20-entities] from the flash [`trace`][ref-1-trace] internal hit list|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-1-trace] internal only hit list|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-1-trace] internal only hit list|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-20-entities] from the flash [`trace`][ref-1-trace] internal only hit list|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-4-entity] from the flash [`trace`][ref-1-trace] internal only hit list|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-1-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-1-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-20-entities] from the flash [`trace`][ref-1-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-4-entity] from the flash [`trace`][ref-1-trace] internal ignore hit list|
|![image][ref-xft]:`setBase`(![image][ref-e])|![image][ref-xft]|Updates the flash [`trace`][ref-1-trace] base attachment [`entity`][ref-4-entity]|
|![image][ref-xft]:`setCollideGroup`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-1-trace] [`trace`][ref-1-trace] collision group [`enums`][ref-11-enums] [`COLLISION_GROUP`][ref-12-COLLISION_GROUP]|
|![image][ref-xft]:`setDir`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-1-trace] [`direction`][ref-2-direction] using three [`numbers`][ref-13-numbers]|
|![image][ref-xft]:`setDir`(![image][ref-r])|![image][ref-xft]|Updates the flash [`trace`][ref-1-trace] [`direction`][ref-2-direction] using an [`array`][ref-14-array]|
|![image][ref-xft]:`setDir`(![image][ref-v])|![image][ref-xft]|Updates the flash [`trace`][ref-1-trace] [`direction`][ref-2-direction] using a [`vector`][ref-3-vector]|
|![image][ref-xft]:`setFilterEar`(![image][ref-xxx])|![image][ref-xft]|Changes the filtering mode to [`entity`][ref-4-entity] [`array`][ref-14-array]|
|![image][ref-xft]:`setFilterEnt`(![image][ref-e])|![image][ref-xft]|Changes the filtering mode to [`entity`][ref-4-entity] object|
|![image][ref-xft]:`setFilterFnc`(![image][ref-xxx])|![image][ref-xft]|Changes the filtering mode to [`function`][ref-23-function] routine|
|![image][ref-xft]:`setIsIgnoreWorld`(![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-1-trace] [`trace`][ref-1-trace] `IgnoreWorld` flag|
|![image][ref-xft]:`setLen`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-1-trace] [`length`][ref-8-length] [`distance`][ref-9-distance]|
|![image][ref-xft]:`setMask`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-1-trace] [`trace`][ref-1-trace] hit [`mask`][ref-18-mask] [`enums`][ref-11-enums] [`MASK`][ref-19-MASK]|
|![image][ref-xft]:`setPos`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-1-trace] [`origin`][ref-6-origin] [`position`][ref-7-position] using three [`numbers`][ref-13-numbers]|
|![image][ref-xft]:`setPos`(![image][ref-r])|![image][ref-xft]|Updates the flash [`trace`][ref-1-trace] [`origin`][ref-6-origin] [`position`][ref-7-position] using an [`array`][ref-14-array]|
|![image][ref-xft]:`setPos`(![image][ref-v])|![image][ref-xft]|Updates the flash [`trace`][ref-1-trace] [`origin`][ref-6-origin] [`position`][ref-7-position] using a [`vector`][ref-3-vector]|
|![image][ref-xft]:`smpLocal`(![image][ref-xxx])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by base attachment [`entity`][ref-4-entity] local axis|
|![image][ref-xft]:`smpLocal`(![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by base [`position`][ref-7-position], [`angle`][ref-15-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`entity`][ref-4-entity] [`position`][ref-7-position] and forward [`vectors`][ref-22-vectors]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`entity`][ref-4-entity] [`position`][ref-7-position], [`angle`][ref-15-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`position`][ref-7-position], [`entity`][ref-4-entity] [`angle`][ref-15-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`position`][ref-7-position], base [`angle`][ref-15-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`position`][ref-7-position], [`angle`][ref-15-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-xxx])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by the world axis|
|![image][ref-xft]:`smpWorld`(![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`entity`][ref-4-entity] [`position`][ref-7-position] and [`angle`][ref-15-angle] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-e])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`entity`][ref-4-entity] [`position`][ref-7-position] and forward [`vectors`][ref-22-vectors]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`entity`][ref-4-entity] [`position`][ref-7-position], [`angle`][ref-15-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`position`][ref-7-position], [`entity`][ref-4-entity] [`angle`][ref-15-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`position`][ref-7-position] [`vector`][ref-3-vector] and [`entity`][ref-4-entity] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-1-trace] and updates the [`trace-result`][ref-10-trace-result] by [`position`][ref-7-position], [`angle`][ref-15-angle]|
|![image][ref-xft]:`updEarSZ`(![image][ref-xxx])|![image][ref-xft]|Performs flash [`trace`][ref-1-trace] [`entity`][ref-4-entity] [`array`][ref-14-array] filter list refresh|

|    General functions    | Out | Description |
|:------------------------|:---:|:------------|
|![image][ref-e]:`setFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the [`entity`][ref-4-entity] by zero [`origin`][ref-6-origin] [`position`][ref-7-position], up [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`direction`][ref-2-direction] [`length`][ref-8-length] [`distance`][ref-9-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the [`entity`][ref-4-entity] by zero [`origin`][ref-6-origin] [`position`][ref-7-position], up [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`length`][ref-8-length] [`distance`][ref-9-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the [`entity`][ref-4-entity] by [`origin`][ref-6-origin] [`position`][ref-7-position], up [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`direction`][ref-2-direction] [`length`][ref-8-length] [`distance`][ref-9-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the [`entity`][ref-4-entity] by [`origin`][ref-6-origin] [`position`][ref-7-position], up [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`length`][ref-8-length] [`distance`][ref-9-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the [`entity`][ref-4-entity] by [`origin`][ref-6-origin] [`position`][ref-7-position], [`direction`][ref-2-direction] [`vector`][ref-3-vector] and [`direction`][ref-2-direction] [`length`][ref-8-length] [`distance`][ref-9-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-1-trace] relative to the [`entity`][ref-4-entity] by [`origin`][ref-6-origin] [`position`][ref-7-position], [`direction`][ref-2-direction] [`vector`][ref-3-vector], [`length`][ref-8-length] [`distance`][ref-9-distance]|

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

[ref_localcrd]: https://en.wikipedia.org/wiki/Local_coordinates
[ref_position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref_class_oop]: https://en.wikipedia.org/wiki/Class_(computer_programming)
[ref_class_con]: https://en.wikipedia.org/wiki/Constructor_(object-oriented_programming)
[ref_orient]: https://en.wikipedia.org/wiki/Orientation_(geometry)
[ref_vec_norm]: https://en.wikipedia.org/wiki/Euclidean_vector#Length
[ref_lua]: https://en.wikipedia.org/wiki/Lua_(programming_language)
[ref_oopinst]: https://en.wikipedia.org/wiki/Instance_(computer_science)
[ref_ray]: https://en.wikipedia.org/wiki/Line_(geometry)#Ray
[ref-func]: https://en.wikipedia.org/wiki/Subroutine
[ref-gmod]: https://wiki.facepunch.com/gmod/
[ref_trace-dt]: https://wiki.facepunch.com/gmod/Structures/Trace
[ref_trace-rz]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref_entity]: https://wiki.facepunch.com/gmod/Entity
[ref_example]: https://github.com/dvdvideo1234/ControlSystemsE2/blob/master/data/Expression2/e2_code_test_ftrace.txt
[ref_exp2]: https://github.com/wiremod/wire/wiki/Expression-2
[ref_wranger]: https://github.com/wiremod/wire/wiki/Expression-2#built-in-ranger
[ref_perfe2]: https://github.com/wiremod/wire/wiki/Expression-2#performance
[ref_timere2]: https://github.com/wiremod/wire/wiki/Expression-2#timer
[ref_awaree2]: https://github.com/wiremod/wire/wiki/Expression-2#self-aware
[ref-1-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-2-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-3-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-4-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-5-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-6-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-7-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-8-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-9-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-10-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-11-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-12-COLLISION_GROUP]: https://wiki.facepunch.com/gmod/Enums/COLLISION_GROUP
[ref-13-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-14-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-15-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-16-trace-line]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-17-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-18-mask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-19-MASK]: https://wiki.facepunch.com/gmod/Enums/MASK
[ref-20-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-21-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-22-vectors]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-23-function]: https://en.wikipedia.org/wiki/Subroutine
[ref-24-DISPSURF]: https://wiki.facepunch.com/gmod/Enums/DISPSURF
[ref-25-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-26-SURF]: https://wiki.facepunch.com/gmod/Enums/SURF
[ref-27-surface]: https://developer.valvesoftware.com/wiki/Material_surface_properties
[ref-28-CONTENTS]: https://wiki.facepunch.com/gmod/Enums/CONTENTS
