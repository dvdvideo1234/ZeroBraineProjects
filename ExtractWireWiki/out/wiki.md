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
|`newFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-17-trace] relative to the world by zero origin [`position`][ref-18-position], up [`direction`][ref-19-direction] [`vector`][ref-20-vector] and [`direction`][ref-21-direction] [`length`][ref-22-length] [`distance`][ref-23-distance]|
|`newFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-388-trace] relative to the world by zero origin [`position`][ref-389-position], up [`direction`][ref-390-direction] [`vector`][ref-391-vector] and [`length`][ref-392-length] [`distance`][ref-393-distance]|
|`newFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-394-trace] relative to the world by origin [`position`][ref-395-position], up [`direction`][ref-396-direction] [`vector`][ref-397-vector] and [`direction`][ref-398-direction] [`length`][ref-399-length] [`distance`][ref-400-distance]|
|`newFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-7-trace] relative to the world by origin [`position`][ref-8-position], up [`direction`][ref-9-direction] [`vector`][ref-10-vector] and [`length`][ref-11-length] [`distance`][ref-12-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-144-trace] relative to the world by origin [`position`][ref-145-position], [`direction`][ref-146-direction] [`vector`][ref-147-vector] and [`direction`][ref-148-direction] [`length`][ref-149-length] [`distance`][ref-150-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-403-trace] relative to the world by origin [`position`][ref-404-position], [`direction`][ref-405-direction] [`vector`][ref-406-vector], [`length`][ref-407-length] [`distance`][ref-408-distance]|
|`noFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns invalid flash [`trace`][ref-182-trace] object|

|           Class methods           | Out | Description |
|:----------------------------------|:---:|:------------|
|![image][ref-xft]:`dumpItem`(![image][ref-n])|![image][ref-xft]|Dumps the flash [`trace`][ref-5-trace] to the chat area by [`number`][ref-6-number] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s])|![image][ref-xft]|Dumps the flash [`trace`][ref-73-trace] to the chat area by [`string`][ref-74-string] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Dumps the flash [`trace`][ref-347-trace] by [`number`][ref-348-number] identifier in the specified area by first argument|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Dumps the flash [`trace`][ref-454-trace] by [`string`][ref-455-string] identifier in the specified area by first argument|
|![image][ref-xft]:`getBase`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-204-trace] base attachment [`entity`][ref-205-entity] if available|
|![image][ref-xft]:`getChip`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-451-trace] auto-assigned expression chip [`entity`][ref-452-entity]|
|![image][ref-xft]:`getCollideGroup`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-32-trace] [`trace`][ref-33-trace] collision group [`enums`][ref-34-enums] [`COLLISION_GROUP`][ref-35-COLLISION_GROUP]|
|![image][ref-xft]:`getCopy`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-178-trace] copy instance of the current object|
|![image][ref-xft]:`getCopy`(![image][ref-e])|![image][ref-xft]|Returns flash [`trace`][ref-262-trace] copy instance of the current object with other [`entity`][ref-263-entity]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-234-trace] copy instance of the current object with other [`entity`][ref-235-entity] and [`length`][ref-236-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-113-trace] copy instance of the current object with other [`entity`][ref-114-entity] and origin|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-464-trace] copy instance of the current object with other [`entity`][ref-465-entity], origin and [`length`][ref-466-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-175-trace] copy instance of the current object with other [`entity`][ref-176-entity], origin and [`direction`][ref-177-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-98-trace] copy instance of the current object with other [`entity`][ref-99-entity], origin, [`direction`][ref-100-direction] and [`length`][ref-101-length]|
|![image][ref-xft]:`getCopy`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-45-trace] copy instance of the current object with other [`length`][ref-46-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-206-trace] copy instance of the current object with other origin|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-119-trace] copy instance of the current object with other origin and [`length`][ref-120-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-335-trace] copy instance of the current object with other origin and [`direction`][ref-336-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-385-trace] copy instance of the current object with other origin, [`direction`][ref-386-direction] and [`length`][ref-387-length]|
|![image][ref-xft]:`getDir`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-442-trace] [`direction`][ref-443-direction] [`vector`][ref-444-vector]|
|![image][ref-xft]:`getDirLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-364-trace] world [`direction`][ref-365-direction] [`vector`][ref-366-vector] converted to base attachment [`entity`][ref-367-entity] local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-353-trace] world [`direction`][ref-354-direction] [`vector`][ref-355-vector] converted to [`angle`][ref-356-angle] local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-197-trace] world [`direction`][ref-198-direction] [`vector`][ref-199-vector] converted to [`entity`][ref-200-entity] local axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-121-trace] local [`direction`][ref-122-direction] [`vector`][ref-123-vector] converted to base attachment [`entity`][ref-124-entity] world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-419-trace] local [`direction`][ref-420-direction] [`vector`][ref-421-vector] converted to [`angle`][ref-422-angle] world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] local [`direction`][ref-2-direction] [`vector`][ref-3-vector] converted to [`entity`][ref-4-entity] world axis|
|![image][ref-xft]:`getDisplaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-349-trace] [`trace-result`][ref-350-trace-result] `DispFlags` [`DISPSURF`][ref-351-DISPSURF] [`bitmask`][ref-352-bitmask]|
|![image][ref-xft]:`getEarSZ`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-316-trace] [`entity`][ref-317-entity] filter [`array`][ref-318-array] size|
|![image][ref-xft]:`getEntity`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-184-trace] [`trace-result`][ref-185-trace-result] `Entity` [`entity`][ref-186-entity]|
|![image][ref-xft]:`getFilterMode`(![image][ref-xxx])|![image][ref-s]|Returns flash tracer filter working mode|
|![image][ref-xft]:`getFraction`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-227-trace] [`trace-result`][ref-228-trace-result] `Fraction` in the interval `[0-1]` [`number`][ref-229-number]|
|![image][ref-xft]:`getFractionLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-125-trace] [`trace-result`][ref-126-trace-result] `FractionLeftSolid` in the interval `[0-1]` [`number`][ref-127-number]|
|![image][ref-xft]:`getFractionLen`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-426-trace] [`trace-result`][ref-427-trace-result] `Fraction` multiplied by its [`length`][ref-428-length] [`distance`][ref-429-distance] [`number`][ref-430-number]|
|![image][ref-xft]:`getFractionLenLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-62-trace] [`trace-result`][ref-63-trace-result] `FractionLeftSolid` multiplied by its [`length`][ref-64-length] [`distance`][ref-65-distance] [`number`][ref-66-number]|
|![image][ref-xft]:`getHitBox`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-431-trace] [`trace-result`][ref-432-trace-result] `HitBox` [`number`][ref-433-number]|
|![image][ref-xft]:`getHitContents`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-330-trace] [`trace-result`][ref-331-trace-result] hit [`surface`][ref-332-surface] `Contents` [`CONTENTS`][ref-333-CONTENTS] [`bitmask`][ref-334-bitmask]|
|![image][ref-xft]:`getHitGroup`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-357-trace] [`trace-result`][ref-358-trace-result] `HitGroup` group `ID` [`number`][ref-359-number]|
|![image][ref-xft]:`getHitNormal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-311-trace] [`trace-result`][ref-312-trace-result] [`surface`][ref-313-surface] `HitNormal` [`vector`][ref-314-vector]|
|![image][ref-xft]:`getHitPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-39-trace] [`trace-result`][ref-40-trace-result] `HitPos` location [`vector`][ref-41-vector]|
|![image][ref-xft]:`getHitTexture`(![image][ref-xxx])|![image][ref-s]|Returns the flash [`trace`][ref-423-trace] [`trace-result`][ref-424-trace-result] `HitTexture` [`string`][ref-425-string]|
|![image][ref-xft]:`getLen`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-412-trace] [`length`][ref-413-length] [`distance`][ref-414-distance]|
|![image][ref-xft]:`getMask`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-128-trace] [`trace`][ref-129-trace] hit [`mask`][ref-130-mask] [`enums`][ref-131-enums] [`MASK`][ref-132-MASK]|
|![image][ref-xft]:`getMatType`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-179-trace] [`trace-result`][ref-180-trace-result] `MatType` material type [`number`][ref-181-number]|
|![image][ref-xft]:`getNormal`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-42-trace] [`trace-result`][ref-43-trace-result] `Normal` aim [`vector`][ref-44-vector]|
|![image][ref-xft]:`getPhysicsBoneID`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-201-trace] [`trace-result`][ref-202-trace-result] `PhysicsBone` `ID` [`number`][ref-203-number]|
|![image][ref-xft]:`getPlayer`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-418-trace] auto-assigned expression chip player|
|![image][ref-xft]:`getPos`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-277-trace] origin [`position`][ref-278-position]|
|![image][ref-xft]:`getPosLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-327-trace] world origin [`position`][ref-328-position] converted to base attachment [`entity`][ref-329-entity] local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-274-trace] world origin [`position`][ref-275-position] converted to [`entity`][ref-276-entity] local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-58-trace] world origin [`position`][ref-59-position] converted to [`position`][ref-60-position]/[`angle`][ref-61-angle] local axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-222-trace] local origin [`position`][ref-223-position] converted to base attachment [`entity`][ref-224-entity] world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-436-trace] local origin [`position`][ref-437-position] converted to [`entity`][ref-438-entity] world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-368-trace] local origin [`position`][ref-369-position] converted to [`position`][ref-370-position]/[`angle`][ref-371-angle] world axis|
|![image][ref-xft]:`getStart`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-67-trace] [`trace`][ref-68-trace] start [`position`][ref-69-position] sent to [`trace-line`][ref-70-trace-line]|
|![image][ref-xft]:`getStartPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-140-trace] [`trace-result`][ref-141-trace-result] `StartPos` [`vector`][ref-142-vector]|
|![image][ref-xft]:`getStop`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-91-trace] [`trace`][ref-92-trace] stop [`position`][ref-93-position] sent to [`trace-line`][ref-94-trace-line]|
|![image][ref-xft]:`getSurfPropsID`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-409-trace] [`trace-result`][ref-410-trace-result] `SurfaceProps` `ID` type [`number`][ref-411-number]|
|![image][ref-xft]:`getSurfPropsName`(![image][ref-xxx])|![image][ref-s]|Returns the flash [`trace`][ref-110-trace] [`trace-result`][ref-111-trace-result] `SurfaceProps` `ID` type name [`string`][ref-112-string]|
|![image][ref-xft]:`getSurfaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-381-trace] [`trace-result`][ref-382-trace-result] `SurfaceFlags` [`SURF`][ref-383-SURF] [`bitmask`][ref-384-bitmask]|
|![image][ref-xft]:`insEar`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-207-entity] in the filter list|
|![image][ref-xft]:`insEar`(![image][ref-r])|![image][ref-xft]|Inserts the [`entities`][ref-345-entities] from the [`array`][ref-346-array] in the filter list|
|![image][ref-xft]:`insEar`(![image][ref-t])|![image][ref-xft]|Inserts the [`entities`][ref-246-entities] from the table in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-n])|![image][ref-xft]|Inserts the [`entity`][ref-51-entity] `ID` in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-r])|![image][ref-xft]|Inserts the [`entity`][ref-151-entity] `ID` from the [`array`][ref-152-array] in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-t])|![image][ref-xft]|Inserts the [`entity`][ref-453-entity] `ID` from the table in the filter list|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-50-trace] internal hit only list|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-290-trace] internal hit only list|
|![image][ref-xft]:`insFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-117-entity] to the flash [`trace`][ref-118-trace] internal only hit list|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-212-trace] internal ignore hit list|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-269-trace] internal ignore hit list|
|![image][ref-xft]:`insFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-401-entity] to the flash [`trace`][ref-402-trace] internal ignore hit list|
|![image][ref-xft]:`isAllSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-279-trace] [`trace-result`][ref-280-trace-result] `AllSolid` flag|
|![image][ref-xft]:`isHit`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-447-trace] [`trace-result`][ref-448-trace-result] `Hit` flag|
|![image][ref-xft]:`isHitNoDraw`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-191-trace] [`trace-result`][ref-192-trace-result] `HitNoDraw` flag|
|![image][ref-xft]:`isHitNonWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-13-trace] [`trace-result`][ref-14-trace-result] `HitNonWorld` flag|
|![image][ref-xft]:`isHitSky`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-217-trace] [`trace-result`][ref-218-trace-result] `HitSky` flag|
|![image][ref-xft]:`isHitWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-379-trace] [`trace-result`][ref-380-trace-result] `HitWorld` flag|
|![image][ref-xft]:`isIgnoreWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-449-trace] [`trace`][ref-450-trace] `IgnoreWorld` flag|
|![image][ref-xft]:`isStartSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-434-trace] [`trace-result`][ref-435-trace-result] `StartSolid` flag|
|![image][ref-xft]:`rayAim`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Aims the flash [`trace`][ref-95-trace] ray at a given [`position`][ref-96-position] using three [`numbers`][ref-97-numbers]|
|![image][ref-xft]:`rayAim`(![image][ref-v])|![image][ref-xft]|Aims the flash [`trace`][ref-415-trace] ray at a given [`position`][ref-416-position] using a [`vector`][ref-417-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Amends the flash [`trace`][ref-83-trace] ray [`direction`][ref-84-direction] using three [`numbers`][ref-85-numbers]|
|![image][ref-xft]:`rayAmend`(![image][ref-v])|![image][ref-xft]|Amends the flash [`trace`][ref-172-trace] ray [`direction`][ref-173-direction] using a [`vector`][ref-174-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Amends the flash [`trace`][ref-230-trace] ray [`direction`][ref-231-direction] using [`vector`][ref-232-vector] and [`magnitude`][ref-233-magnitude]|
|![image][ref-xft]:`rayDiv`(![image][ref-n])|![image][ref-xft]|Contracts the flash [`trace`][ref-244-trace] ray with a [`number`][ref-245-number]|
|![image][ref-xft]:`rayDiv`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Contracts the flash [`trace`][ref-445-trace] ray each component individually using three [`numbers`][ref-446-numbers]|
|![image][ref-xft]:`rayDiv`(![image][ref-v])|![image][ref-xft]|Contracts the flash [`trace`][ref-115-trace] ray each component individually using a [`vector`][ref-116-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-xxx])|![image][ref-xft]|Moves the flash [`trace`][ref-286-trace] ray with its own [`direction`][ref-287-direction] and [`magnitude`][ref-288-magnitude]|
|![image][ref-xft]:`rayMove`(![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-193-trace] ray with its own [`direction`][ref-194-direction] and [`magnitude`][ref-195-magnitude] [`length`][ref-196-length]|
|![image][ref-xft]:`rayMove`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-362-trace] ray with displacement as three [`numbers`][ref-363-numbers]|
|![image][ref-xft]:`rayMove`(![image][ref-v])|![image][ref-xft]|Moves the flash [`trace`][ref-75-trace] ray with displacement [`vector`][ref-76-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-456-trace] ray with [`direction`][ref-457-direction] [`vector`][ref-458-vector], [`magnitude`][ref-459-magnitude] [`length`][ref-460-length]|
|![image][ref-xft]:`rayMul`(![image][ref-n])|![image][ref-xft]|Expands the flash [`trace`][ref-210-trace] ray with a [`number`][ref-211-number]|
|![image][ref-xft]:`rayMul`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Expands the flash [`trace`][ref-156-trace] ray each component individually using three [`numbers`][ref-157-numbers]|
|![image][ref-xft]:`rayMul`(![image][ref-v])|![image][ref-xft]|Expands the flash [`trace`][ref-89-trace] ray each component individually using a [`vector`][ref-90-vector]|
|![image][ref-xft]:`remBase`(![image][ref-xxx])|![image][ref-xft]|Removes the base attachment [`entity`][ref-225-entity] of the flash [`trace`][ref-226-trace]|
|![image][ref-xft]:`remEar`(![image][ref-xxx])|![image][ref-xft]|Removes all [`entities`][ref-183-entities] from the filter list|
|![image][ref-xft]:`remEar`(![image][ref-e])|![image][ref-xft]|Removes the specified [`entity`][ref-143-entity] from the filter list|
|![image][ref-xft]:`remEarID`(![image][ref-n])|![image][ref-xft]|Removes the specified [`entity`][ref-88-entity] by `ID` from the filter list|
|![image][ref-xft]:`remEarN`(![image][ref-n])|![image][ref-xft]|Removes an [`entity`][ref-440-entity] using the specified sequential [`number`][ref-441-number]|
|![image][ref-xft]:`remFilter`(![image][ref-xxx])|![image][ref-xft]|Removes the filter from the [`trace`][ref-55-trace] configuration|
|![image][ref-xft]:`remFnc`(![image][ref-xxx])|![image][ref-xft]|Removes all the options from the flash [`trace`][ref-24-trace] internal hit preferences|
|![image][ref-xft]:`remFnc`(![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-289-trace] internal hit preferences|
|![image][ref-xft]:`remFncEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-305-entities] from the flash [`trace`][ref-306-trace] internal hit list|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-77-trace] internal only hit list|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-467-trace] internal only hit list|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-238-entities] from the flash [`trace`][ref-239-trace] internal only hit list|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-86-entity] from the flash [`trace`][ref-87-trace] internal only hit list|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-439-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-237-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-360-entities] from the flash [`trace`][ref-361-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-71-entity] from the flash [`trace`][ref-72-trace] internal ignore hit list|
|![image][ref-xft]:`setBase`(![image][ref-e])|![image][ref-xft]|Updates the flash [`trace`][ref-208-trace] base attachment [`entity`][ref-209-entity]|
|![image][ref-xft]:`setCollideGroup`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-187-trace] [`trace`][ref-188-trace] collision group [`enums`][ref-189-enums] [`COLLISION_GROUP`][ref-190-COLLISION_GROUP]|
|![image][ref-xft]:`setDir`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-52-trace] [`direction`][ref-53-direction] using three [`numbers`][ref-54-numbers]|
|![image][ref-xft]:`setDir`(![image][ref-r])|![image][ref-xft]|Updates the flash [`trace`][ref-102-trace] [`direction`][ref-103-direction] using an [`array`][ref-104-array]|
|![image][ref-xft]:`setDir`(![image][ref-v])|![image][ref-xft]|Updates the flash [`trace`][ref-461-trace] [`direction`][ref-462-direction] using a [`vector`][ref-463-vector]|
|![image][ref-xft]:`setFilterEar`(![image][ref-xxx])|![image][ref-xft]|Changes the filtering mode to [`entity`][ref-56-entity] [`array`][ref-57-array]|
|![image][ref-xft]:`setFilterEnt`(![image][ref-e])|![image][ref-xft]|Changes the filtering mode to [`entity`][ref-315-entity] object|
|![image][ref-xft]:`setFilterFnc`(![image][ref-xxx])|![image][ref-xft]|Changes the filtering mode to [`function`][ref-310-function] routine|
|![image][ref-xft]:`setIsIgnoreWorld`(![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-15-trace] [`trace`][ref-16-trace] `IgnoreWorld` flag|
|![image][ref-xft]:`setLen`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-307-trace] [`length`][ref-308-length] [`distance`][ref-309-distance]|
|![image][ref-xft]:`setMask`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-105-trace] [`trace`][ref-106-trace] hit [`mask`][ref-107-mask] [`enums`][ref-108-enums] [`MASK`][ref-109-MASK]|
|![image][ref-xft]:`setPos`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-36-trace] origin [`position`][ref-37-position] using three [`numbers`][ref-38-numbers]|
|![image][ref-xft]:`setPos`(![image][ref-r])|![image][ref-xft]|Updates the flash [`trace`][ref-219-trace] origin [`position`][ref-220-position] using an [`array`][ref-221-array]|
|![image][ref-xft]:`setPos`(![image][ref-v])|![image][ref-xft]|Updates the flash [`trace`][ref-153-trace] origin [`position`][ref-154-position] using a [`vector`][ref-155-vector]|
|![image][ref-xft]:`smpLocal`(![image][ref-xxx])|![image][ref-xft]|Samples the flash [`trace`][ref-302-trace] and updates the [`trace-result`][ref-303-trace-result] by base attachment [`entity`][ref-304-entity] local axis|
|![image][ref-xft]:`smpLocal`(![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-213-trace] and updates the [`trace-result`][ref-214-trace-result] by base [`position`][ref-215-position], [`angle`][ref-216-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e])|![image][ref-xft]|Samples the flash [`trace`][ref-297-trace] and updates the [`trace-result`][ref-298-trace-result] by [`entity`][ref-299-entity] [`position`][ref-300-position] and forward [`vectors`][ref-301-vectors]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-158-trace] and updates the [`trace-result`][ref-159-trace-result] by [`entity`][ref-160-entity] [`position`][ref-161-position], [`angle`][ref-162-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-78-trace] and updates the [`trace-result`][ref-79-trace-result] by [`position`][ref-80-position], [`entity`][ref-81-entity] [`angle`][ref-82-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-270-trace] and updates the [`trace-result`][ref-271-trace-result] by [`position`][ref-272-position], base [`angle`][ref-273-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-293-trace] and updates the [`trace-result`][ref-294-trace-result] by [`position`][ref-295-position], [`angle`][ref-296-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-xxx])|![image][ref-xft]|Samples the flash [`trace`][ref-291-trace] and updates the [`trace-result`][ref-292-trace-result] by the world axis|
|![image][ref-xft]:`smpWorld`(![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-281-trace] and updates the [`trace-result`][ref-282-trace-result] by [`entity`][ref-283-entity] [`position`][ref-284-position] and [`angle`][ref-285-angle] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-e])|![image][ref-xft]|Samples the flash [`trace`][ref-264-trace] and updates the [`trace-result`][ref-265-trace-result] by [`entity`][ref-266-entity] [`position`][ref-267-position] and forward [`vectors`][ref-268-vectors]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-257-trace] and updates the [`trace-result`][ref-258-trace-result] by [`entity`][ref-259-entity] [`position`][ref-260-position], [`angle`][ref-261-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-252-trace] and updates the [`trace-result`][ref-253-trace-result] by [`position`][ref-254-position], [`entity`][ref-255-entity] [`angle`][ref-256-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-247-trace] and updates the [`trace-result`][ref-248-trace-result] by [`position`][ref-249-position] [`vector`][ref-250-vector] and [`entity`][ref-251-entity] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-240-trace] and updates the [`trace-result`][ref-241-trace-result] by [`position`][ref-242-position], [`angle`][ref-243-angle]|
|![image][ref-xft]:`updEarSZ`(![image][ref-xxx])|![image][ref-xft]|Performs flash [`trace`][ref-47-trace] [`entity`][ref-48-entity] [`array`][ref-49-array] list refresh|

|    General functions    | Out | Description |
|:------------------------|:---:|:------------|
|![image][ref-e]:`setFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-164-trace] relative to the [`entity`][ref-165-entity] by zero origin [`position`][ref-166-position], up [`direction`][ref-167-direction] [`vector`][ref-168-vector] and [`direction`][ref-169-direction] [`length`][ref-170-length] [`distance`][ref-171-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-133-trace] relative to the [`entity`][ref-134-entity] by zero origin [`position`][ref-135-position], up [`direction`][ref-136-direction] [`vector`][ref-137-vector] and [`length`][ref-138-length] [`distance`][ref-139-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-337-trace] relative to the [`entity`][ref-338-entity] by origin [`position`][ref-339-position], up [`direction`][ref-340-direction] [`vector`][ref-341-vector] and [`direction`][ref-342-direction] [`length`][ref-343-length] [`distance`][ref-344-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-25-trace] relative to the [`entity`][ref-26-entity] by origin [`position`][ref-27-position], up [`direction`][ref-28-direction] [`vector`][ref-29-vector] and [`length`][ref-30-length] [`distance`][ref-31-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-319-trace] relative to the [`entity`][ref-320-entity] by origin [`position`][ref-321-position], [`direction`][ref-322-direction] [`vector`][ref-323-vector] and [`direction`][ref-324-direction] [`length`][ref-325-length] [`distance`][ref-326-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-372-trace] relative to the [`entity`][ref-373-entity] by origin [`position`][ref-374-position], [`direction`][ref-375-direction] [`vector`][ref-376-vector], [`length`][ref-377-length] [`distance`][ref-378-distance]|

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
[ref-5-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-6-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-7-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-8-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-9-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-10-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-11-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-12-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-13-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-14-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-15-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-16-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-17-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-18-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-19-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-20-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-21-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-22-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-23-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-24-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-25-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-26-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-27-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-28-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-29-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-30-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-31-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-32-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-33-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-34-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-35-COLLISION_GROUP]: https://wiki.facepunch.com/gmod/Enums/COLLISION_GROUP
[ref-36-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-37-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-38-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-39-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-40-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-41-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-42-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-43-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-44-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-45-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-46-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-47-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-48-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-49-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-50-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-51-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-52-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-53-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-54-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-55-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-56-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-57-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-58-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-59-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-60-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-61-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-62-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-63-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-64-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-65-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-66-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-67-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-68-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-69-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-70-trace-line]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-71-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-72-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-73-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-74-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-75-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-76-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-77-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-78-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-79-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-80-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-81-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-82-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-83-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-84-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-85-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-86-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-87-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-88-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-89-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-90-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-91-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-92-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-93-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-94-trace-line]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-95-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-96-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-97-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-98-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-99-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-100-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-101-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-102-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-103-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-104-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-105-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-106-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-107-mask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-108-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-109-MASK]: https://wiki.facepunch.com/gmod/Enums/MASK
[ref-110-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-111-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-112-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-113-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-114-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-115-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-116-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-117-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-118-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-119-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-120-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-121-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-122-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-123-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-124-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-125-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-126-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-127-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-128-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-129-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-130-mask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-131-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-132-MASK]: https://wiki.facepunch.com/gmod/Enums/MASK
[ref-133-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-134-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-135-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-136-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-137-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-138-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-139-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-140-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-141-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-142-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-143-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-144-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-145-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-146-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-147-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-148-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-149-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-150-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-151-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-152-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-153-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-154-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-155-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-156-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-157-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-158-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-159-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-160-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-161-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-162-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-163-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-164-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-165-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-166-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-167-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-168-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-169-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-170-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-171-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-172-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-173-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-174-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-175-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-176-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-177-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-178-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-179-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-180-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-181-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-182-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-183-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-184-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-185-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-186-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-187-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-188-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-189-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-190-COLLISION_GROUP]: https://wiki.facepunch.com/gmod/Enums/COLLISION_GROUP
[ref-191-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-192-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-193-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-194-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-195-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-196-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-197-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-198-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-199-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-200-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-201-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-202-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-203-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-204-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-205-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-206-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-207-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-208-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-209-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-210-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-211-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-212-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-213-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-214-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-215-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-216-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-217-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-218-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-219-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-220-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-221-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-222-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-223-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-224-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-225-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-226-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-227-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-228-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-229-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-230-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-231-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-232-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-233-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-234-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-235-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-236-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-237-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-238-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-239-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-240-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-241-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-242-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-243-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-244-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-245-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-246-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-247-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-248-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-249-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-250-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-251-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-252-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-253-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-254-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-255-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-256-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-257-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-258-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-259-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-260-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-261-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-262-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-263-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-264-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-265-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-266-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-267-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-268-vectors]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-269-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-270-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-271-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-272-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-273-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-274-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-275-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-276-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-277-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-278-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-279-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-280-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-281-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-282-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-283-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-284-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-285-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-286-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-287-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-288-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-289-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-290-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-291-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-292-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-293-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-294-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-295-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-296-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-297-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-298-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-299-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-300-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-301-vectors]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-302-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-303-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-304-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-305-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-306-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-307-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-308-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-309-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-310-function]: https://en.wikipedia.org/wiki/Subroutine
[ref-311-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-312-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-313-surface]: https://developer.valvesoftware.com/wiki/Material_surface_properties
[ref-314-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-315-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-316-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-317-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-318-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-319-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-320-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-321-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-322-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-323-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-324-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-325-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-326-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-327-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-328-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-329-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-330-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-331-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-332-surface]: https://developer.valvesoftware.com/wiki/Material_surface_properties
[ref-333-CONTENTS]: https://wiki.facepunch.com/gmod/Enums/CONTENTS
[ref-334-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-335-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-336-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-337-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-338-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-339-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-340-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-341-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-342-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-343-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-344-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-345-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-346-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-347-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-348-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-349-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-350-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-351-DISPSURF]: https://wiki.facepunch.com/gmod/Enums/DISPSURF
[ref-352-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-353-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-354-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-355-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-356-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-357-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-358-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-359-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-360-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-361-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-362-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-363-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-364-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-365-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-366-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-367-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-368-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-369-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-370-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-371-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-372-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-373-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-374-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-375-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-376-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-377-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-378-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-379-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-380-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-381-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-382-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-383-SURF]: https://wiki.facepunch.com/gmod/Enums/SURF
[ref-384-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-385-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-386-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-387-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-388-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-389-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-390-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-391-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-392-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-393-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-394-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-395-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-396-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-397-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-398-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-399-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-400-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-401-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-402-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-403-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-404-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-405-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-406-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-407-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-408-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-409-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-410-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-411-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-412-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-413-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-414-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-415-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-416-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-417-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-418-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-419-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-420-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-421-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-422-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-423-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-424-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-425-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-426-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-427-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-428-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-429-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-430-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-431-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-432-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-433-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-434-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-435-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-436-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-437-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-438-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-439-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-440-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-441-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-442-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-443-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-444-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-445-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-446-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-447-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-448-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-449-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-450-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-451-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-452-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-453-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-454-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-455-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-456-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-457-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-458-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-459-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-460-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-461-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-462-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-463-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-464-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-465-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-466-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-467-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
