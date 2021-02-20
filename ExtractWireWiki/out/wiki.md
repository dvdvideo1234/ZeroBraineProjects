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
|`newFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash tracer relative to the world by zero [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`direction`][ref-3-direction] [`length`][ref-10-length] [`distance`][ref-11-distance]|
|`newFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the world by zero [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`length`][ref-10-length] [`distance`][ref-11-distance]|
|`newFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash tracer relative to the world by [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`direction`][ref-3-direction] [`length`][ref-10-length] [`distance`][ref-11-distance]|
|`newFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the world by [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`length`][ref-10-length] [`distance`][ref-11-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash tracer relative to the world by [`origin`][ref-8-origin] [`position`][ref-9-position], [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`direction`][ref-3-direction] [`length`][ref-10-length] [`distance`][ref-11-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the world by [`origin`][ref-8-origin] [`position`][ref-9-position], [`direction`][ref-3-direction] [`vector`][ref-4-vector], [`length`][ref-10-length] [`distance`][ref-11-distance]|
|`noFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns invalid flash tracer object|

|           Class methods           | Out | Description |
|:----------------------------------|:---:|:------------|
|![image][ref-xft]:`cpyFilterEar`(![image][ref-xft])|![image][ref-xft]|[`Copies`][ref-14-Copies] other flash tracer [`entity`][ref-5-entity] [`array`][ref-15-array] [`filtering`][ref-16-filtering] data|
|![image][ref-xft]:`cpyFilterFnc`(![image][ref-xft])|![image][ref-xft]|[`Copies`][ref-14-Copies] other flash tracer [`function`][ref-17-function] [`filtering`][ref-16-filtering] data|
|![image][ref-xft]:`dumpItem`(![image][ref-n])|![image][ref-xft]|Dumps the flash tracer to the chat area by [`number`][ref-7-number] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s])|![image][ref-xft]|Dumps the flash tracer to the chat area by [`string`][ref-31-string] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Dumps the flash tracer by [`number`][ref-7-number] identifier in the specified area by first argument|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Dumps the flash tracer by [`string`][ref-31-string] identifier in the specified area by first argument|
|![image][ref-xft]:`getBase`(![image][ref-xxx])|![image][ref-e]|Returns the flash tracer base attachment [`entity`][ref-5-entity] if available|
|![image][ref-xft]:`getChip`(![image][ref-xxx])|![image][ref-e]|Returns the flash tracer auto assigned [`expression chip`][ref-46-expression chip] [`entity`][ref-5-entity]|
|![image][ref-xft]:`getCollideGroup`(![image][ref-xxx])|![image][ref-n]|Returns flash tracer [`trace`][ref-1-trace] collision group [`enums`][ref-19-enums] [`COLLISION_GROUP`][ref-20-COLLISION_GROUP]|
|![image][ref-xft]:`getCopy`(![image][ref-xxx])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object|
|![image][ref-xft]:`getCopy`(![image][ref-e])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`entity`][ref-5-entity]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-n])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`entity`][ref-5-entity] and [`length`][ref-10-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`entity`][ref-5-entity] and [`origin`][ref-8-origin]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`entity`][ref-5-entity], [`origin`][ref-8-origin] and [`length`][ref-10-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`entity`][ref-5-entity], [`origin`][ref-8-origin] and [`direction`][ref-3-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`entity`][ref-5-entity], [`origin`][ref-8-origin], [`direction`][ref-3-direction] and [`length`][ref-10-length]|
|![image][ref-xft]:`getCopy`(![image][ref-n])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`length`][ref-10-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`origin`][ref-8-origin]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`origin`][ref-8-origin] and [`length`][ref-10-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`origin`][ref-8-origin] and [`direction`][ref-3-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer [`copy`][ref-23-copy] instance of the current object with other [`origin`][ref-8-origin], [`direction`][ref-3-direction] and [`length`][ref-10-length]|
|![image][ref-xft]:`getDir`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`direction`][ref-3-direction] [`vector`][ref-4-vector]|
|![image][ref-xft]:`getDirLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer world [`direction`][ref-3-direction] [`vector`][ref-4-vector] converted to base attachment [`entity`][ref-5-entity] [`local axis`][ref-29-local axis]|
|![image][ref-xft]:`getDirLocal`(![image][ref-a])|![image][ref-v]|Returns flash tracer world [`direction`][ref-3-direction] [`vector`][ref-4-vector] converted to [`angle`][ref-28-angle] [`local axis`][ref-29-local axis]|
|![image][ref-xft]:`getDirLocal`(![image][ref-e])|![image][ref-v]|Returns flash tracer world [`direction`][ref-3-direction] [`vector`][ref-4-vector] converted to [`entity`][ref-5-entity] [`local axis`][ref-29-local axis]|
|![image][ref-xft]:`getDirWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`local`][ref-2-local] [`direction`][ref-3-direction] [`vector`][ref-4-vector] converted to base attachment [`entity`][ref-5-entity] world [`axis`][ref-6-axis]|
|![image][ref-xft]:`getDirWorld`(![image][ref-a])|![image][ref-v]|Returns flash tracer [`local`][ref-2-local] [`direction`][ref-3-direction] [`vector`][ref-4-vector] converted to [`angle`][ref-28-angle] world [`axis`][ref-6-axis]|
|![image][ref-xft]:`getDirWorld`(![image][ref-e])|![image][ref-v]|Returns flash tracer [`local`][ref-2-local] [`direction`][ref-3-direction] [`vector`][ref-4-vector] converted to [`entity`][ref-5-entity] world [`axis`][ref-6-axis]|
|![image][ref-xft]:`getDisplaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `DispFlags` [`DISPSURF`][ref-48-DISPSURF] [`bitmask`][ref-39-bitmask]|
|![image][ref-xft]:`getEar`(![image][ref-xxx])|![image][ref-r]|Returns the [`configuration`][ref-27-configuration] used by the [`entity`][ref-5-entity] [`array`][ref-15-array] [`filter`][ref-24-filter]|
|![image][ref-xft]:`getEarID`(![image][ref-xxx])|![image][ref-r]|Returns the [`configuration`][ref-27-configuration] used by the [`entity`][ref-5-entity] [`array`][ref-15-array] [`filter`][ref-24-filter] as `ID` indices|
|![image][ref-xft]:`getEarSZ`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`entity`][ref-5-entity] [`filter`][ref-24-filter] [`array`][ref-15-array] size|
|![image][ref-xft]:`getEntity`(![image][ref-xxx])|![image][ref-e]|Returns the flash tracer [`trace result`][ref-12-trace result] [`Entity`][ref-41-Entity] [`entity`][ref-5-entity]|
|![image][ref-xft]:`getEnu`(![image][ref-xxx])|![image][ref-e]|Returns the [`configuration`][ref-27-configuration] used by the [`entity`][ref-5-entity] unit [`filter`][ref-24-filter]|
|![image][ref-xft]:`getFilterMode`(![image][ref-xxx])|![image][ref-s]|Returns flash tracerr [`filter`][ref-24-filter] working mode|
|![image][ref-xft]:`getFraction`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `Fraction` in the interval `[0-1]` [`number`][ref-7-number]|
|![image][ref-xft]:`getFractionLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `FractionLeftSolid` in the interval `[0-1]` [`number`][ref-7-number]|
|![image][ref-xft]:`getFractionLen`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `Fraction` multiplied by its [`length`][ref-10-length] [`distance`][ref-11-distance] [`number`][ref-7-number]|
|![image][ref-xft]:`getFractionLenLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `FractionLeftSolid` multiplied by its [`length`][ref-10-length] [`distance`][ref-11-distance] [`number`][ref-7-number]|
|![image][ref-xft]:`getHitBox`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `HitBox` [`number`][ref-7-number]|
|![image][ref-xft]:`getHitContents`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] hit [`surface`][ref-36-surface] [`Contents`][ref-37-Contents] [`CONTENTS`][ref-38-CONTENTS] [`bitmask`][ref-39-bitmask]|
|![image][ref-xft]:`getHitGroup`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `HitGroup` group `ID` [`number`][ref-7-number]|
|![image][ref-xft]:`getHitNormal`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`trace result`][ref-12-trace result] [`surface`][ref-36-surface] `HitNormal` [`vector`][ref-4-vector]|
|![image][ref-xft]:`getHitPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash tracer [`trace result`][ref-12-trace result] `HitPos` location [`vector`][ref-4-vector]|
|![image][ref-xft]:`getHitTexture`(![image][ref-xxx])|![image][ref-s]|Returns the flash tracer [`trace result`][ref-12-trace result] `HitTexture` [`string`][ref-31-string]|
|![image][ref-xft]:`getLen`(![image][ref-xxx])|![image][ref-n]|Returns flash tracer [`length`][ref-10-length] [`distance`][ref-11-distance]|
|![image][ref-xft]:`getMask`(![image][ref-xxx])|![image][ref-n]|Returns flash tracer [`trace`][ref-1-trace] hit [`mask`][ref-33-mask] [`enums`][ref-19-enums] [`MASK`][ref-34-MASK]|
|![image][ref-xft]:`getMatType`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `MatType` material type [`number`][ref-7-number]|
|![image][ref-xft]:`getNormal`(![image][ref-xxx])|![image][ref-v]|Returns the flash tracer [`trace result`][ref-12-trace result] [`Normal`][ref-22-Normal] aim [`vector`][ref-4-vector]|
|![image][ref-xft]:`getPhysicsBoneID`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `PhysicsBone` `ID` [`number`][ref-7-number]|
|![image][ref-xft]:`getPlayer`(![image][ref-xxx])|![image][ref-e]|Returns the flash tracer auto assigned [`expression chip`][ref-46-expression chip] [`player`][ref-47-player]|
|![image][ref-xft]:`getPos`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`origin`][ref-8-origin] [`position`][ref-9-position]|
|![image][ref-xft]:`getPosLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer world [`origin`][ref-8-origin] [`position`][ref-9-position] converted to base attachment [`entity`][ref-5-entity] [`local axis`][ref-29-local axis]|
|![image][ref-xft]:`getPosLocal`(![image][ref-e])|![image][ref-v]|Returns flash tracer world [`origin`][ref-8-origin] [`position`][ref-9-position] converted to [`entity`][ref-5-entity] [`local axis`][ref-29-local axis]|
|![image][ref-xft]:`getPosLocal`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash tracer world [`origin`][ref-8-origin] [`position`][ref-9-position] converted to [`position`][ref-9-position]/[`angle`][ref-28-angle] [`local axis`][ref-29-local axis]|
|![image][ref-xft]:`getPosWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`local`][ref-2-local] [`origin`][ref-8-origin] [`position`][ref-9-position] converted to base attachment [`entity`][ref-5-entity] world [`axis`][ref-6-axis]|
|![image][ref-xft]:`getPosWorld`(![image][ref-e])|![image][ref-v]|Returns flash tracer [`local`][ref-2-local] [`origin`][ref-8-origin] [`position`][ref-9-position] converted to [`entity`][ref-5-entity] world [`axis`][ref-6-axis]|
|![image][ref-xft]:`getPosWorld`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash tracer [`local`][ref-2-local] [`origin`][ref-8-origin] [`position`][ref-9-position] converted to [`position`][ref-9-position]/[`angle`][ref-28-angle] world [`axis`][ref-6-axis]|
|![image][ref-xft]:`getStart`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`trace`][ref-1-trace] start [`position`][ref-9-position] sent to [`trace line`][ref-30-trace line]|
|![image][ref-xft]:`getStartPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash tracer [`trace result`][ref-12-trace result] `StartPos` [`vector`][ref-4-vector]|
|![image][ref-xft]:`getStop`(![image][ref-xxx])|![image][ref-v]|Returns flash tracer [`trace`][ref-1-trace] stop [`position`][ref-9-position] sent to [`trace line`][ref-30-trace line]|
|![image][ref-xft]:`getSurfPropsID`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `SurfaceProps` `ID` type [`number`][ref-7-number]|
|![image][ref-xft]:`getSurfPropsName`(![image][ref-xxx])|![image][ref-s]|Returns the flash tracer [`trace result`][ref-12-trace result] `SurfaceProps` `ID` type name [`string`][ref-31-string]|
|![image][ref-xft]:`getSurfaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `SurfaceFlags` [`SURF`][ref-45-SURF] [`bitmask`][ref-39-bitmask]|
|![image][ref-xft]:`insEar`(![image][ref-e])|![image][ref-xft]|Inserts the argument in the [`entity`][ref-5-entity] [`array`][ref-15-array] [`filter`][ref-24-filter] [`list`][ref-25-list]|
|![image][ref-xft]:`insEar`(![image][ref-r])|![image][ref-xft]|Inserts the [`entities`][ref-40-entities] from the [`array`][ref-15-array] in the [`filter`][ref-24-filter] [`list`][ref-25-list]|
|![image][ref-xft]:`insEar`(![image][ref-t])|![image][ref-xft]|Inserts the [`entities`][ref-40-entities] from the table in the [`filter`][ref-24-filter] [`list`][ref-25-list]|
|![image][ref-xft]:`insEarID`(![image][ref-n])|![image][ref-xft]|Inserts the [`entity`][ref-5-entity] `ID` in the [`filter`][ref-24-filter] [`list`][ref-25-list]|
|![image][ref-xft]:`insEarID`(![image][ref-r])|![image][ref-xft]|Inserts the [`entity`][ref-5-entity] `ID` from the [`array`][ref-15-array] in the [`filter`][ref-24-filter] [`list`][ref-25-list]|
|![image][ref-xft]:`insEarID`(![image][ref-t])|![image][ref-xft]|Inserts the [`entity`][ref-5-entity] `ID` from the table in the [`filter`][ref-24-filter] [`list`][ref-25-list]|
|![image][ref-xft]:`insEnu`(![image][ref-e])|![image][ref-xft]|Inserts the argument in the [`entity`][ref-5-entity] unit [`filter`][ref-24-filter]|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts an option to the [`function`][ref-17-function] flash tracer internal only [`list`][ref-25-list]|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts an option to the [`function`][ref-17-function] flash tracer internal only [`list`][ref-25-list]|
|![image][ref-xft]:`insFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-5-entity] to the [`function`][ref-17-function] flash tracer internal only [`list`][ref-25-list]|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts an option to the [`function`][ref-17-function] flash tracer internal ignore [`list`][ref-25-list]|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts an option to the [`function`][ref-17-function] flash tracer internal ignore [`list`][ref-25-list]|
|![image][ref-xft]:`insFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-5-entity] to the [`function`][ref-17-function] flash tracer internal ignore [`list`][ref-25-list]|
|![image][ref-xft]:`isAllSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `AllSolid` [`flag`][ref-13-flag]|
|![image][ref-xft]:`isHit`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `Hit` [`flag`][ref-13-flag]|
|![image][ref-xft]:`isHitNoDraw`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `HitNoDraw` [`flag`][ref-13-flag]|
|![image][ref-xft]:`isHitNonWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `HitNonWorld` [`flag`][ref-13-flag]|
|![image][ref-xft]:`isHitSky`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `HitSky` [`flag`][ref-13-flag]|
|![image][ref-xft]:`isHitWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `HitWorld` [`flag`][ref-13-flag]|
|![image][ref-xft]:`isIgnoreWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace`][ref-1-trace] `IgnoreWorld` [`flag`][ref-13-flag]|
|![image][ref-xft]:`isStartSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash tracer [`trace result`][ref-12-trace result] `StartSolid` [`flag`][ref-13-flag]|
|![image][ref-xft]:`rayAim`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Aims the flash tracer [`ray`][ref-32-ray] at a given [`position`][ref-9-position] using three [`numbers`][ref-21-numbers]|
|![image][ref-xft]:`rayAim`(![image][ref-v])|![image][ref-xft]|Aims the flash tracer [`ray`][ref-32-ray] at a given [`position`][ref-9-position] using a [`vector`][ref-4-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Amends the flash tracer [`ray`][ref-32-ray] [`direction`][ref-3-direction] using three [`numbers`][ref-21-numbers]|
|![image][ref-xft]:`rayAmend`(![image][ref-v])|![image][ref-xft]|Amends the flash tracer [`ray`][ref-32-ray] [`direction`][ref-3-direction] using a [`vector`][ref-4-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Amends the flash tracer [`ray`][ref-32-ray] [`direction`][ref-3-direction] using [`vector`][ref-4-vector] and [`magnitude`][ref-42-magnitude]|
|![image][ref-xft]:`rayDiv`(![image][ref-n])|![image][ref-xft]|Contracts the flash tracer [`ray`][ref-32-ray] with a [`number`][ref-7-number]|
|![image][ref-xft]:`rayDiv`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Contracts the flash tracer [`ray`][ref-32-ray] each component individually using three [`numbers`][ref-21-numbers]|
|![image][ref-xft]:`rayDiv`(![image][ref-v])|![image][ref-xft]|Contracts the flash tracer [`ray`][ref-32-ray] each component individually using a [`vector`][ref-4-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-xxx])|![image][ref-xft]|Moves the flash tracer [`ray`][ref-32-ray] with its own [`direction`][ref-3-direction] and [`magnitude`][ref-42-magnitude]|
|![image][ref-xft]:`rayMove`(![image][ref-n])|![image][ref-xft]|Moves the flash tracer [`ray`][ref-32-ray] with its own [`direction`][ref-3-direction] and [`magnitude`][ref-42-magnitude] [`length`][ref-10-length]|
|![image][ref-xft]:`rayMove`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Moves the flash tracer [`ray`][ref-32-ray] with displacement as three [`numbers`][ref-21-numbers]|
|![image][ref-xft]:`rayMove`(![image][ref-v])|![image][ref-xft]|Moves the flash tracer [`ray`][ref-32-ray] with displacement [`vector`][ref-4-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Moves the flash tracer [`ray`][ref-32-ray] with [`direction`][ref-3-direction] [`vector`][ref-4-vector], [`magnitude`][ref-42-magnitude] [`length`][ref-10-length]|
|![image][ref-xft]:`rayMul`(![image][ref-n])|![image][ref-xft]|Expands the flash tracer [`ray`][ref-32-ray] with a [`number`][ref-7-number]|
|![image][ref-xft]:`rayMul`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Expands the flash tracer [`ray`][ref-32-ray] each component individually using three [`numbers`][ref-21-numbers]|
|![image][ref-xft]:`rayMul`(![image][ref-v])|![image][ref-xft]|Expands the flash tracer [`ray`][ref-32-ray] each component individually using a [`vector`][ref-4-vector]|
|![image][ref-xft]:`remBase`(![image][ref-xxx])|![image][ref-xft]|Removes the base attachment [`entity`][ref-5-entity] of the flash tracer|
|![image][ref-xft]:`remEar`(![image][ref-xxx])|![image][ref-xft]|Removes all [`entities`][ref-40-entities] from the [`filter`][ref-24-filter] [`list`][ref-25-list]|
|![image][ref-xft]:`remEar`(![image][ref-e])|![image][ref-xft]|Removes the specified [`entity`][ref-5-entity] from the [`filter`][ref-24-filter] [`list`][ref-25-list]|
|![image][ref-xft]:`remEarID`(![image][ref-n])|![image][ref-xft]|Removes the specified [`entity`][ref-5-entity] by `ID` from the [`filter`][ref-24-filter] [`list`][ref-25-list]|
|![image][ref-xft]:`remEarN`(![image][ref-n])|![image][ref-xft]|Removes an [`entity`][ref-5-entity] using the specified sequential [`number`][ref-7-number]|
|![image][ref-xft]:`remEnu`(![image][ref-xxx])|![image][ref-xft]|Removes the [`configuration`][ref-27-configuration] used by the [`entity`][ref-5-entity] unit [`filter`][ref-24-filter]|
|![image][ref-xft]:`remFilter`(![image][ref-xxx])|![image][ref-xft]|Removes the [`filter`][ref-24-filter] from the [`trace`][ref-1-trace] [`configuration`][ref-27-configuration]|
|![image][ref-xft]:`remFnc`(![image][ref-xxx])|![image][ref-xft]|Removes all the options from the [`function`][ref-17-function] flash tracer internal preferences|
|![image][ref-xft]:`remFnc`(![image][ref-s])|![image][ref-xft]|Removes the option from the [`function`][ref-17-function] flash tracer internal preferences|
|![image][ref-xft]:`remFncEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-40-entities] from the [`function`][ref-17-function] flash tracer internal [`list`][ref-25-list]|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the [`function`][ref-17-function] flash tracer internal only [`list`][ref-25-list]|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the [`function`][ref-17-function] flash tracer internal only [`list`][ref-25-list]|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-40-entities] from the [`function`][ref-17-function] flash tracer internal only [`list`][ref-25-list]|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-5-entity] from the [`function`][ref-17-function] flash tracer internal only [`list`][ref-25-list]|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the [`function`][ref-17-function] flash tracer internal ignore [`list`][ref-25-list]|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the [`function`][ref-17-function] flash tracer internal ignore [`list`][ref-25-list]|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-40-entities] from the [`function`][ref-17-function] flash tracer internal ignore [`list`][ref-25-list]|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-5-entity] from the [`function`][ref-17-function] flash tracer internal ignore [`list`][ref-25-list]|
|![image][ref-xft]:`setBase`(![image][ref-e])|![image][ref-xft]|Updates the flash tracer base attachment [`entity`][ref-5-entity]|
|![image][ref-xft]:`setCollideGroup`(![image][ref-n])|![image][ref-xft]|Updates flash tracer [`trace`][ref-1-trace] collision group [`enums`][ref-19-enums] [`COLLISION_GROUP`][ref-20-COLLISION_GROUP]|
|![image][ref-xft]:`setDir`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash tracer [`direction`][ref-3-direction] using three [`numbers`][ref-21-numbers]|
|![image][ref-xft]:`setDir`(![image][ref-r])|![image][ref-xft]|Updates the flash tracer [`direction`][ref-3-direction] using an [`array`][ref-15-array]|
|![image][ref-xft]:`setDir`(![image][ref-v])|![image][ref-xft]|Updates the flash tracer [`direction`][ref-3-direction] using a [`vector`][ref-4-vector]|
|![image][ref-xft]:`setFilterEar`(![image][ref-xxx])|![image][ref-xft]|Changes the [`filtering`][ref-16-filtering] mode to [`entity`][ref-5-entity] [`array`][ref-15-array]|
|![image][ref-xft]:`setFilterEnu`(![image][ref-xxx])|![image][ref-xft]|Changes the [`filtering`][ref-16-filtering] mode to [`entity`][ref-5-entity] unit|
|![image][ref-xft]:`setFilterFnc`(![image][ref-xxx])|![image][ref-xft]|Changes the [`filtering`][ref-16-filtering] mode to [`function`][ref-17-function] routine|
|![image][ref-xft]:`setIsIgnoreWorld`(![image][ref-n])|![image][ref-xft]|Updates the flash tracer [`trace`][ref-1-trace] `IgnoreWorld` [`flag`][ref-13-flag]|
|![image][ref-xft]:`setLen`(![image][ref-n])|![image][ref-xft]|Updates flash tracer [`length`][ref-10-length] [`distance`][ref-11-distance]|
|![image][ref-xft]:`setMask`(![image][ref-n])|![image][ref-xft]|Updates flash tracer [`trace`][ref-1-trace] hit [`mask`][ref-33-mask] [`enums`][ref-19-enums] [`MASK`][ref-34-MASK]|
|![image][ref-xft]:`setPos`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash tracer [`origin`][ref-8-origin] [`position`][ref-9-position] using three [`numbers`][ref-21-numbers]|
|![image][ref-xft]:`setPos`(![image][ref-r])|![image][ref-xft]|Updates the flash tracer [`origin`][ref-8-origin] [`position`][ref-9-position] using an [`array`][ref-15-array]|
|![image][ref-xft]:`setPos`(![image][ref-v])|![image][ref-xft]|Updates the flash tracer [`origin`][ref-8-origin] [`position`][ref-9-position] using a [`vector`][ref-4-vector]|
|![image][ref-xft]:`smpLocal`(![image][ref-xxx])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by base attachment [`entity`][ref-5-entity] [`local axis`][ref-29-local axis]|
|![image][ref-xft]:`smpLocal`(![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by base [`position`][ref-9-position], [`angle`][ref-28-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`entity`][ref-5-entity] [`position`][ref-9-position] and forward [`vectors`][ref-43-vectors]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`entity`][ref-5-entity] [`position`][ref-9-position], [`angle`][ref-28-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`position`][ref-9-position], [`entity`][ref-5-entity] [`angle`][ref-28-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`position`][ref-9-position], base [`angle`][ref-28-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`position`][ref-9-position], [`angle`][ref-28-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-xxx])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by the world [`axis`][ref-6-axis]|
|![image][ref-xft]:`smpWorld`(![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`entity`][ref-5-entity] [`position`][ref-9-position] and [`angle`][ref-28-angle] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-e])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`entity`][ref-5-entity] [`position`][ref-9-position] and forward [`vectors`][ref-43-vectors]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`entity`][ref-5-entity] [`position`][ref-9-position], [`angle`][ref-28-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`position`][ref-9-position], [`entity`][ref-5-entity] [`angle`][ref-28-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-v])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`position`][ref-9-position] [`vector`][ref-4-vector] and [`entity`][ref-5-entity] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash tracer and updates the [`trace result`][ref-12-trace result] by [`position`][ref-9-position], [`angle`][ref-28-angle]|
|![image][ref-xft]:`updEarSZ`(![image][ref-xxx])|![image][ref-xft]|Performs flash tracer [`entity`][ref-5-entity] [`array`][ref-15-array] [`filter`][ref-24-filter] [`list`][ref-25-list] refresh|
|![image][ref-xft]:`useFilterEar`(![image][ref-xft])|![image][ref-xft]|Uses other flash tracer [`entity`][ref-5-entity] [`array`][ref-15-array] [`filtering`][ref-16-filtering] by [`reference`][ref-26-reference]|
|![image][ref-xft]:`useFilterEnu`(![image][ref-xft])|![image][ref-xft]|Uses other flash tracer [`entity`][ref-5-entity] unit [`filtering`][ref-16-filtering] by [`reference`][ref-26-reference]|
|![image][ref-xft]:`useFilterFnc`(![image][ref-xft])|![image][ref-xft]|Uses other flash tracer [`function`][ref-17-function] [`filtering`][ref-16-filtering] by [`reference`][ref-26-reference]|

|    General functions    | Out | Description |
|:------------------------|:---:|:------------|
|![image][ref-e]:`setFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash tracer relative to the [`entity`][ref-5-entity] by zero [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`direction`][ref-3-direction] [`length`][ref-10-length] [`distance`][ref-11-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the [`entity`][ref-5-entity] by zero [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`length`][ref-10-length] [`distance`][ref-11-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash tracer relative to the [`entity`][ref-5-entity] by [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`direction`][ref-3-direction] [`length`][ref-10-length] [`distance`][ref-11-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the [`entity`][ref-5-entity] by [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`length`][ref-10-length] [`distance`][ref-11-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash tracer relative to the [`entity`][ref-5-entity] by [`origin`][ref-8-origin] [`position`][ref-9-position], [`direction`][ref-3-direction] [`vector`][ref-4-vector] and [`direction`][ref-3-direction] [`length`][ref-10-length] [`distance`][ref-11-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash tracer relative to the [`entity`][ref-5-entity] by [`origin`][ref-8-origin] [`position`][ref-9-position], [`direction`][ref-3-direction] [`vector`][ref-4-vector], [`length`][ref-10-length] [`distance`][ref-11-distance]|

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
[ref-2-local]: https://en.wikipedia.org/wiki/Local_coordinates
[ref-3-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-4-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-5-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-6-axis]: https://en.wikipedia.org/wiki/Cartesian_coordinate_system
[ref-7-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-8-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-9-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-10-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-11-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-12-trace result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-13-flag]: https://en.wikipedia.org/wiki/Boolean_flag
[ref-14-Copies]: https://en.wikipedia.org/wiki/Copying
[ref-15-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-16-filtering]: https://en.wikipedia.org/wiki/Filter_(higher-order_function)
[ref-17-function]: https://en.wikipedia.org/wiki/Subroutine
[ref-18-references]: https://en.wikipedia.org/wiki/Reference_(computer_science)
[ref-19-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-20-COLLISION_GROUP]: https://wiki.facepunch.com/gmod/Enums/COLLISION_GROUP
[ref-21-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-22-Normal]: https://en.wikipedia.org/wiki/Normal_(geometry)
[ref-23-copy]: https://en.wikipedia.org/wiki/Copying
[ref-24-filter]: https://en.wikipedia.org/wiki/Filter_(higher-order_function)
[ref-25-list]: https://en.wikipedia.org/wiki/List_(abstract_data_type)
[ref-26-reference]: https://en.wikipedia.org/wiki/Reference_(computer_science)
[ref-27-configuration]: https://en.wikipedia.org/wiki/Computer_configuration
[ref-28-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-29-local axis]: https://en.wikipedia.org/wiki/Local_coordinates
[ref-30-trace line]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-31-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-32-ray]: https://en.wikipedia.org/wiki/Line_(geometry)#Ray
[ref-33-mask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-34-MASK]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-35-Surface]: https://developer.valvesoftware.com/wiki/Material_surface_properties
[ref-36-surface]: https://developer.valvesoftware.com/wiki/Material_surface_properties
[ref-37-Contents]: https://wiki.facepunch.com/gmod/Enums/CONTENTS
[ref-38-CONTENTS]: https://wiki.facepunch.com/gmod/Enums/CONTENTS
[ref-39-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-40-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-41-Entity]: https://wiki.facepunch.com/gmod/Entity
[ref-42-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-43-vectors]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-44-Flag]: https://en.wikipedia.org/wiki/Boolean_flag
[ref-45-SURF]: https://wiki.facepunch.com/gmod/Enums/SURF
[ref-46-expression chip]: https://github.com/wiremod/wire/wiki/Expression-2
[ref-47-player]: https://wiki.facepunch.com/gmod/Player
[ref-48-DISPSURF]: https://wiki.facepunch.com/gmod/Enums/DISPSURF
