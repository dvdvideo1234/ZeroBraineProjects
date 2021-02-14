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
|`newFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-18-trace] relative to the world by zero [`origin`][ref-19-origin] [`position`][ref-20-position], up [`direction`][ref-21-direction] [`vector`][ref-22-vector] and [`direction`][ref-23-direction] [`length`][ref-24-length] [`distance`][ref-25-distance]|
|`newFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-413-trace] relative to the world by zero [`origin`][ref-414-origin] [`position`][ref-415-position], up [`direction`][ref-416-direction] [`vector`][ref-417-vector] and [`length`][ref-418-length] [`distance`][ref-419-distance]|
|`newFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-420-trace] relative to the world by [`origin`][ref-421-origin] [`position`][ref-422-position], up [`direction`][ref-423-direction] [`vector`][ref-424-vector] and [`direction`][ref-425-direction] [`length`][ref-426-length] [`distance`][ref-427-distance]|
|`newFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-7-trace] relative to the world by [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-10-direction] [`vector`][ref-11-vector] and [`length`][ref-12-length] [`distance`][ref-13-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-153-trace] relative to the world by [`origin`][ref-154-origin] [`position`][ref-155-position], [`direction`][ref-156-direction] [`vector`][ref-157-vector] and [`direction`][ref-158-direction] [`length`][ref-159-length] [`distance`][ref-160-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-430-trace] relative to the world by [`origin`][ref-431-origin] [`position`][ref-432-position], [`direction`][ref-433-direction] [`vector`][ref-434-vector], [`length`][ref-435-length] [`distance`][ref-436-distance]|
|`noFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns invalid flash [`trace`][ref-195-trace] object|

|           Class methods           | Out | Description |
|:----------------------------------|:---:|:------------|
|![image][ref-xft]:`dumpItem`(![image][ref-n])|![image][ref-xft]|Dumps the flash [`trace`][ref-5-trace] to the chat area by [`number`][ref-6-number] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s])|![image][ref-xft]|Dumps the flash [`trace`][ref-78-trace] to the chat area by [`string`][ref-79-string] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Dumps the flash [`trace`][ref-369-trace] by [`number`][ref-370-number] identifier in the specified area by first argument|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Dumps the flash [`trace`][ref-483-trace] by [`string`][ref-484-string] identifier in the specified area by first argument|
|![image][ref-xft]:`getBase`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-217-trace] base attachment [`entity`][ref-218-entity] if available|
|![image][ref-xft]:`getChip`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-480-trace] auto-assigned expression chip [`entity`][ref-481-entity]|
|![image][ref-xft]:`getCollideGroup`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-35-trace] [`trace`][ref-36-trace] collision group [`enums`][ref-37-enums] [`COLLISION_GROUP`][ref-38-COLLISION_GROUP]|
|![image][ref-xft]:`getCopy`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-191-trace] copy instance of the current object|
|![image][ref-xft]:`getCopy`(![image][ref-e])|![image][ref-xft]|Returns flash [`trace`][ref-278-trace] copy instance of the current object with other [`entity`][ref-279-entity]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-250-trace] copy instance of the current object with other [`entity`][ref-251-entity] and [`length`][ref-252-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-119-trace] copy instance of the current object with other [`entity`][ref-120-entity] and [`origin`][ref-121-origin]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-493-trace] copy instance of the current object with other [`entity`][ref-494-entity], [`origin`][ref-495-origin] and [`length`][ref-496-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-187-trace] copy instance of the current object with other [`entity`][ref-188-entity], [`origin`][ref-189-origin] and [`direction`][ref-190-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-103-trace] copy instance of the current object with other [`entity`][ref-104-entity], [`origin`][ref-105-origin], [`direction`][ref-106-direction] and [`length`][ref-107-length]|
|![image][ref-xft]:`getCopy`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-49-trace] copy instance of the current object with other [`length`][ref-50-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-219-trace] copy instance of the current object with other [`origin`][ref-220-origin]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-126-trace] copy instance of the current object with other [`origin`][ref-127-origin] and [`length`][ref-128-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-355-trace] copy instance of the current object with other [`origin`][ref-356-origin] and [`direction`][ref-357-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-409-trace] copy instance of the current object with other [`origin`][ref-410-origin], [`direction`][ref-411-direction] and [`length`][ref-412-length]|
|![image][ref-xft]:`getDir`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-471-trace] [`direction`][ref-472-direction] [`vector`][ref-473-vector]|
|![image][ref-xft]:`getDirLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-386-trace] world [`direction`][ref-387-direction] [`vector`][ref-388-vector] converted to base attachment [`entity`][ref-389-entity] local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-375-trace] world [`direction`][ref-376-direction] [`vector`][ref-377-vector] converted to [`angle`][ref-378-angle] local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-210-trace] world [`direction`][ref-211-direction] [`vector`][ref-212-vector] converted to [`entity`][ref-213-entity] local axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-129-trace] local [`direction`][ref-130-direction] [`vector`][ref-131-vector] converted to base attachment [`entity`][ref-132-entity] world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-447-trace] local [`direction`][ref-448-direction] [`vector`][ref-449-vector] converted to [`angle`][ref-450-angle] world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] local [`direction`][ref-2-direction] [`vector`][ref-3-vector] converted to [`entity`][ref-4-entity] world axis|
|![image][ref-xft]:`getDisplaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-371-trace] [`trace-result`][ref-372-trace-result] `DispFlags` [`DISPSURF`][ref-373-DISPSURF] [`bitmask`][ref-374-bitmask]|
|![image][ref-xft]:`getEarSZ`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-334-trace] [`entity`][ref-335-entity] filter [`array`][ref-336-array] size|
|![image][ref-xft]:`getEntity`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-197-trace] [`trace-result`][ref-198-trace-result] `Entity` [`entity`][ref-199-entity]|
|![image][ref-xft]:`getFilterMode`(![image][ref-xxx])|![image][ref-s]|Returns flash tracer filter working mode|
|![image][ref-xft]:`getFraction`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-243-trace] [`trace-result`][ref-244-trace-result] `Fraction` in the interval `[0-1]` [`number`][ref-245-number]|
|![image][ref-xft]:`getFractionLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-133-trace] [`trace-result`][ref-134-trace-result] `FractionLeftSolid` in the interval `[0-1]` [`number`][ref-135-number]|
|![image][ref-xft]:`getFractionLen`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-454-trace] [`trace-result`][ref-455-trace-result] `Fraction` multiplied by its [`length`][ref-456-length] [`distance`][ref-457-distance] [`number`][ref-458-number]|
|![image][ref-xft]:`getFractionLenLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-67-trace] [`trace-result`][ref-68-trace-result] `FractionLeftSolid` multiplied by its [`length`][ref-69-length] [`distance`][ref-70-distance] [`number`][ref-71-number]|
|![image][ref-xft]:`getHitBox`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-459-trace] [`trace-result`][ref-460-trace-result] `HitBox` [`number`][ref-461-number]|
|![image][ref-xft]:`getHitContents`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-350-trace] [`trace-result`][ref-351-trace-result] hit [`surface`][ref-352-surface] `Contents` [`CONTENTS`][ref-353-CONTENTS] [`bitmask`][ref-354-bitmask]|
|![image][ref-xft]:`getHitGroup`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-379-trace] [`trace-result`][ref-380-trace-result] `HitGroup` group `ID` [`number`][ref-381-number]|
|![image][ref-xft]:`getHitNormal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-329-trace] [`trace-result`][ref-330-trace-result] [`surface`][ref-331-surface] `HitNormal` [`vector`][ref-332-vector]|
|![image][ref-xft]:`getHitPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-43-trace] [`trace-result`][ref-44-trace-result] `HitPos` location [`vector`][ref-45-vector]|
|![image][ref-xft]:`getHitTexture`(![image][ref-xxx])|![image][ref-s]|Returns the flash [`trace`][ref-451-trace] [`trace-result`][ref-452-trace-result] `HitTexture` [`string`][ref-453-string]|
|![image][ref-xft]:`getLen`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-440-trace] [`length`][ref-441-length] [`distance`][ref-442-distance]|
|![image][ref-xft]:`getMask`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-136-trace] [`trace`][ref-137-trace] hit [`mask`][ref-138-mask] [`enums`][ref-139-enums] [`MASK`][ref-140-MASK]|
|![image][ref-xft]:`getMatType`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-192-trace] [`trace-result`][ref-193-trace-result] `MatType` material type [`number`][ref-194-number]|
|![image][ref-xft]:`getNormal`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-46-trace] [`trace-result`][ref-47-trace-result] `Normal` aim [`vector`][ref-48-vector]|
|![image][ref-xft]:`getPhysicsBoneID`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-214-trace] [`trace-result`][ref-215-trace-result] `PhysicsBone` `ID` [`number`][ref-216-number]|
|![image][ref-xft]:`getPlayer`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-446-trace] auto-assigned expression chip player|
|![image][ref-xft]:`getPos`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-294-trace] [`origin`][ref-295-origin] [`position`][ref-296-position]|
|![image][ref-xft]:`getPosLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-346-trace] world [`origin`][ref-347-origin] [`position`][ref-348-position] converted to base attachment [`entity`][ref-349-entity] local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-290-trace] world [`origin`][ref-291-origin] [`position`][ref-292-position] converted to [`entity`][ref-293-entity] local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-62-trace] world [`origin`][ref-63-origin] [`position`][ref-64-position] converted to [`position`][ref-65-position]/[`angle`][ref-66-angle] local axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-237-trace] local [`origin`][ref-238-origin] [`position`][ref-239-position] converted to base attachment [`entity`][ref-240-entity] world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-464-trace] local [`origin`][ref-465-origin] [`position`][ref-466-position] converted to [`entity`][ref-467-entity] world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-390-trace] local [`origin`][ref-391-origin] [`position`][ref-392-position] converted to [`position`][ref-393-position]/[`angle`][ref-394-angle] world axis|
|![image][ref-xft]:`getStart`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-72-trace] [`trace`][ref-73-trace] start [`position`][ref-74-position] sent to [`trace-line`][ref-75-trace-line]|
|![image][ref-xft]:`getStartPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-149-trace] [`trace-result`][ref-150-trace-result] `StartPos` [`vector`][ref-151-vector]|
|![image][ref-xft]:`getStop`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-96-trace] [`trace`][ref-97-trace] stop [`position`][ref-98-position] sent to [`trace-line`][ref-99-trace-line]|
|![image][ref-xft]:`getSurfPropsID`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-437-trace] [`trace-result`][ref-438-trace-result] `SurfaceProps` `ID` type [`number`][ref-439-number]|
|![image][ref-xft]:`getSurfPropsName`(![image][ref-xxx])|![image][ref-s]|Returns the flash [`trace`][ref-116-trace] [`trace-result`][ref-117-trace-result] `SurfaceProps` `ID` type name [`string`][ref-118-string]|
|![image][ref-xft]:`getSurfaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-405-trace] [`trace-result`][ref-406-trace-result] `SurfaceFlags` [`SURF`][ref-407-SURF] [`bitmask`][ref-408-bitmask]|
|![image][ref-xft]:`insEar`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-221-entity] in the filter list|
|![image][ref-xft]:`insEar`(![image][ref-r])|![image][ref-xft]|Inserts the [`entities`][ref-367-entities] from the [`array`][ref-368-array] in the filter list|
|![image][ref-xft]:`insEar`(![image][ref-t])|![image][ref-xft]|Inserts the [`entities`][ref-262-entities] from the table in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-n])|![image][ref-xft]|Inserts the [`entity`][ref-55-entity] `ID` in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-r])|![image][ref-xft]|Inserts the [`entity`][ref-161-entity] `ID` from the [`array`][ref-162-array] in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-t])|![image][ref-xft]|Inserts the [`entity`][ref-482-entity] `ID` from the table in the filter list|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-54-trace] internal hit only list|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-308-trace] internal hit only list|
|![image][ref-xft]:`insFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-124-entity] to the flash [`trace`][ref-125-trace] internal only hit list|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-226-trace] internal ignore hit list|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-285-trace] internal ignore hit list|
|![image][ref-xft]:`insFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-428-entity] to the flash [`trace`][ref-429-trace] internal ignore hit list|
|![image][ref-xft]:`isAllSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-297-trace] [`trace-result`][ref-298-trace-result] `AllSolid` flag|
|![image][ref-xft]:`isHit`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-476-trace] [`trace-result`][ref-477-trace-result] `Hit` flag|
|![image][ref-xft]:`isHitNoDraw`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-204-trace] [`trace-result`][ref-205-trace-result] `HitNoDraw` flag|
|![image][ref-xft]:`isHitNonWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-14-trace] [`trace-result`][ref-15-trace-result] `HitNonWorld` flag|
|![image][ref-xft]:`isHitSky`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-231-trace] [`trace-result`][ref-232-trace-result] `HitSky` flag|
|![image][ref-xft]:`isHitWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-403-trace] [`trace-result`][ref-404-trace-result] `HitWorld` flag|
|![image][ref-xft]:`isIgnoreWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-478-trace] [`trace`][ref-479-trace] `IgnoreWorld` flag|
|![image][ref-xft]:`isStartSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-462-trace] [`trace-result`][ref-463-trace-result] `StartSolid` flag|
|![image][ref-xft]:`rayAim`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Aims the flash [`trace`][ref-100-trace] ray at a given [`position`][ref-101-position] using three [`numbers`][ref-102-numbers]|
|![image][ref-xft]:`rayAim`(![image][ref-v])|![image][ref-xft]|Aims the flash [`trace`][ref-443-trace] ray at a given [`position`][ref-444-position] using a [`vector`][ref-445-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Amends the flash [`trace`][ref-88-trace] ray [`direction`][ref-89-direction] using three [`numbers`][ref-90-numbers]|
|![image][ref-xft]:`rayAmend`(![image][ref-v])|![image][ref-xft]|Amends the flash [`trace`][ref-184-trace] ray [`direction`][ref-185-direction] using a [`vector`][ref-186-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Amends the flash [`trace`][ref-246-trace] ray [`direction`][ref-247-direction] using [`vector`][ref-248-vector] and [`magnitude`][ref-249-magnitude]|
|![image][ref-xft]:`rayDiv`(![image][ref-n])|![image][ref-xft]|Contracts the flash [`trace`][ref-260-trace] ray with a [`number`][ref-261-number]|
|![image][ref-xft]:`rayDiv`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Contracts the flash [`trace`][ref-474-trace] ray each component individually using three [`numbers`][ref-475-numbers]|
|![image][ref-xft]:`rayDiv`(![image][ref-v])|![image][ref-xft]|Contracts the flash [`trace`][ref-122-trace] ray each component individually using a [`vector`][ref-123-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-xxx])|![image][ref-xft]|Moves the flash [`trace`][ref-304-trace] ray with its own [`direction`][ref-305-direction] and [`magnitude`][ref-306-magnitude]|
|![image][ref-xft]:`rayMove`(![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-206-trace] ray with its own [`direction`][ref-207-direction] and [`magnitude`][ref-208-magnitude] [`length`][ref-209-length]|
|![image][ref-xft]:`rayMove`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-384-trace] ray with displacement as three [`numbers`][ref-385-numbers]|
|![image][ref-xft]:`rayMove`(![image][ref-v])|![image][ref-xft]|Moves the flash [`trace`][ref-80-trace] ray with displacement [`vector`][ref-81-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-485-trace] ray with [`direction`][ref-486-direction] [`vector`][ref-487-vector], [`magnitude`][ref-488-magnitude] [`length`][ref-489-length]|
|![image][ref-xft]:`rayMul`(![image][ref-n])|![image][ref-xft]|Expands the flash [`trace`][ref-224-trace] ray with a [`number`][ref-225-number]|
|![image][ref-xft]:`rayMul`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Expands the flash [`trace`][ref-167-trace] ray each component individually using three [`numbers`][ref-168-numbers]|
|![image][ref-xft]:`rayMul`(![image][ref-v])|![image][ref-xft]|Expands the flash [`trace`][ref-94-trace] ray each component individually using a [`vector`][ref-95-vector]|
|![image][ref-xft]:`remBase`(![image][ref-xxx])|![image][ref-xft]|Removes the base attachment [`entity`][ref-241-entity] of the flash [`trace`][ref-242-trace]|
|![image][ref-xft]:`remEar`(![image][ref-xxx])|![image][ref-xft]|Removes all [`entities`][ref-196-entities] from the filter list|
|![image][ref-xft]:`remEar`(![image][ref-e])|![image][ref-xft]|Removes the specified [`entity`][ref-152-entity] from the filter list|
|![image][ref-xft]:`remEarID`(![image][ref-n])|![image][ref-xft]|Removes the specified [`entity`][ref-93-entity] by `ID` from the filter list|
|![image][ref-xft]:`remEarN`(![image][ref-n])|![image][ref-xft]|Removes an [`entity`][ref-469-entity] using the specified sequential [`number`][ref-470-number]|
|![image][ref-xft]:`remFilter`(![image][ref-xxx])|![image][ref-xft]|Removes the filter from the [`trace`][ref-59-trace] configuration|
|![image][ref-xft]:`remFnc`(![image][ref-xxx])|![image][ref-xft]|Removes all the options from the flash [`trace`][ref-26-trace] internal hit preferences|
|![image][ref-xft]:`remFnc`(![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-307-trace] internal hit preferences|
|![image][ref-xft]:`remFncEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-323-entities] from the flash [`trace`][ref-324-trace] internal hit list|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-82-trace] internal only hit list|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-497-trace] internal only hit list|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-254-entities] from the flash [`trace`][ref-255-trace] internal only hit list|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-91-entity] from the flash [`trace`][ref-92-trace] internal only hit list|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-468-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-253-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-382-entities] from the flash [`trace`][ref-383-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-76-entity] from the flash [`trace`][ref-77-trace] internal ignore hit list|
|![image][ref-xft]:`setBase`(![image][ref-e])|![image][ref-xft]|Updates the flash [`trace`][ref-222-trace] base attachment [`entity`][ref-223-entity]|
|![image][ref-xft]:`setCollideGroup`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-200-trace] [`trace`][ref-201-trace] collision group [`enums`][ref-202-enums] [`COLLISION_GROUP`][ref-203-COLLISION_GROUP]|
|![image][ref-xft]:`setDir`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-56-trace] [`direction`][ref-57-direction] using three [`numbers`][ref-58-numbers]|
|![image][ref-xft]:`setDir`(![image][ref-r])|![image][ref-xft]|Updates the flash [`trace`][ref-108-trace] [`direction`][ref-109-direction] using an [`array`][ref-110-array]|
|![image][ref-xft]:`setDir`(![image][ref-v])|![image][ref-xft]|Updates the flash [`trace`][ref-490-trace] [`direction`][ref-491-direction] using a [`vector`][ref-492-vector]|
|![image][ref-xft]:`setFilterEar`(![image][ref-xxx])|![image][ref-xft]|Changes the filtering mode to [`entity`][ref-60-entity] [`array`][ref-61-array]|
|![image][ref-xft]:`setFilterEnt`(![image][ref-e])|![image][ref-xft]|Changes the filtering mode to [`entity`][ref-333-entity] object|
|![image][ref-xft]:`setFilterFnc`(![image][ref-xxx])|![image][ref-xft]|Changes the filtering mode to [`function`][ref-328-function] routine|
|![image][ref-xft]:`setIsIgnoreWorld`(![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-16-trace] [`trace`][ref-17-trace] `IgnoreWorld` flag|
|![image][ref-xft]:`setLen`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-325-trace] [`length`][ref-326-length] [`distance`][ref-327-distance]|
|![image][ref-xft]:`setMask`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-111-trace] [`trace`][ref-112-trace] hit [`mask`][ref-113-mask] [`enums`][ref-114-enums] [`MASK`][ref-115-MASK]|
|![image][ref-xft]:`setPos`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-39-trace] [`origin`][ref-40-origin] [`position`][ref-41-position] using three [`numbers`][ref-42-numbers]|
|![image][ref-xft]:`setPos`(![image][ref-r])|![image][ref-xft]|Updates the flash [`trace`][ref-233-trace] [`origin`][ref-234-origin] [`position`][ref-235-position] using an [`array`][ref-236-array]|
|![image][ref-xft]:`setPos`(![image][ref-v])|![image][ref-xft]|Updates the flash [`trace`][ref-163-trace] [`origin`][ref-164-origin] [`position`][ref-165-position] using a [`vector`][ref-166-vector]|
|![image][ref-xft]:`smpLocal`(![image][ref-xxx])|![image][ref-xft]|Samples the flash [`trace`][ref-320-trace] and updates the [`trace-result`][ref-321-trace-result] by base attachment [`entity`][ref-322-entity] local axis|
|![image][ref-xft]:`smpLocal`(![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-227-trace] and updates the [`trace-result`][ref-228-trace-result] by base [`position`][ref-229-position], [`angle`][ref-230-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e])|![image][ref-xft]|Samples the flash [`trace`][ref-315-trace] and updates the [`trace-result`][ref-316-trace-result] by [`entity`][ref-317-entity] [`position`][ref-318-position] and forward [`vectors`][ref-319-vectors]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-169-trace] and updates the [`trace-result`][ref-170-trace-result] by [`entity`][ref-171-entity] [`position`][ref-172-position], [`angle`][ref-173-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-83-trace] and updates the [`trace-result`][ref-84-trace-result] by [`position`][ref-85-position], [`entity`][ref-86-entity] [`angle`][ref-87-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-286-trace] and updates the [`trace-result`][ref-287-trace-result] by [`position`][ref-288-position], base [`angle`][ref-289-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-311-trace] and updates the [`trace-result`][ref-312-trace-result] by [`position`][ref-313-position], [`angle`][ref-314-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-xxx])|![image][ref-xft]|Samples the flash [`trace`][ref-309-trace] and updates the [`trace-result`][ref-310-trace-result] by the world axis|
|![image][ref-xft]:`smpWorld`(![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-299-trace] and updates the [`trace-result`][ref-300-trace-result] by [`entity`][ref-301-entity] [`position`][ref-302-position] and [`angle`][ref-303-angle] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-e])|![image][ref-xft]|Samples the flash [`trace`][ref-280-trace] and updates the [`trace-result`][ref-281-trace-result] by [`entity`][ref-282-entity] [`position`][ref-283-position] and forward [`vectors`][ref-284-vectors]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-273-trace] and updates the [`trace-result`][ref-274-trace-result] by [`entity`][ref-275-entity] [`position`][ref-276-position], [`angle`][ref-277-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-268-trace] and updates the [`trace-result`][ref-269-trace-result] by [`position`][ref-270-position], [`entity`][ref-271-entity] [`angle`][ref-272-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-263-trace] and updates the [`trace-result`][ref-264-trace-result] by [`position`][ref-265-position] [`vector`][ref-266-vector] and [`entity`][ref-267-entity] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-256-trace] and updates the [`trace-result`][ref-257-trace-result] by [`position`][ref-258-position], [`angle`][ref-259-angle]|
|![image][ref-xft]:`updEarSZ`(![image][ref-xxx])|![image][ref-xft]|Performs flash [`trace`][ref-51-trace] [`entity`][ref-52-entity] [`array`][ref-53-array] list refresh|

|    General functions    | Out | Description |
|:------------------------|:---:|:------------|
|![image][ref-e]:`setFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-175-trace] relative to the [`entity`][ref-176-entity] by zero [`origin`][ref-177-origin] [`position`][ref-178-position], up [`direction`][ref-179-direction] [`vector`][ref-180-vector] and [`direction`][ref-181-direction] [`length`][ref-182-length] [`distance`][ref-183-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-141-trace] relative to the [`entity`][ref-142-entity] by zero [`origin`][ref-143-origin] [`position`][ref-144-position], up [`direction`][ref-145-direction] [`vector`][ref-146-vector] and [`length`][ref-147-length] [`distance`][ref-148-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-358-trace] relative to the [`entity`][ref-359-entity] by [`origin`][ref-360-origin] [`position`][ref-361-position], up [`direction`][ref-362-direction] [`vector`][ref-363-vector] and [`direction`][ref-364-direction] [`length`][ref-365-length] [`distance`][ref-366-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-27-trace] relative to the [`entity`][ref-28-entity] by [`origin`][ref-29-origin] [`position`][ref-30-position], up [`direction`][ref-31-direction] [`vector`][ref-32-vector] and [`length`][ref-33-length] [`distance`][ref-34-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-337-trace] relative to the [`entity`][ref-338-entity] by [`origin`][ref-339-origin] [`position`][ref-340-position], [`direction`][ref-341-direction] [`vector`][ref-342-vector] and [`direction`][ref-343-direction] [`length`][ref-344-length] [`distance`][ref-345-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-395-trace] relative to the [`entity`][ref-396-entity] by [`origin`][ref-397-origin] [`position`][ref-398-position], [`direction`][ref-399-direction] [`vector`][ref-400-vector], [`length`][ref-401-length] [`distance`][ref-402-distance]|

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
[ref-8-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-9-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-10-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-11-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-12-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-13-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-14-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-15-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-16-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-17-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-18-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-19-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-20-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-21-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-22-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-23-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-24-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-25-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-26-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-27-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-28-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-29-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-30-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-31-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-32-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-33-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-34-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-35-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-36-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-37-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-38-COLLISION_GROUP]: https://wiki.facepunch.com/gmod/Enums/COLLISION_GROUP
[ref-39-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-40-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-41-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-42-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-43-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-44-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-45-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-46-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-47-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-48-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-49-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-50-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-51-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-52-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-53-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-54-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-55-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-56-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-57-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-58-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-59-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-60-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-61-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-62-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-63-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-64-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-65-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-66-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-67-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-68-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-69-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-70-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-71-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-72-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-73-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-74-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-75-trace-line]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-76-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-77-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-78-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-79-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-80-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-81-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-82-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-83-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-84-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-85-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-86-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-87-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-88-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-89-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-90-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-91-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-92-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-93-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-94-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-95-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-96-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-97-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-98-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-99-trace-line]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-100-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-101-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-102-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-103-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-104-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-105-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-106-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-107-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-108-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-109-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-110-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-111-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-112-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-113-mask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-114-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-115-MASK]: https://wiki.facepunch.com/gmod/Enums/MASK
[ref-116-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-117-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-118-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-119-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-120-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-121-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-122-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-123-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-124-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-125-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-126-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-127-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-128-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-129-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-130-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-131-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-132-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-133-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-134-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-135-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-136-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-137-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-138-mask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-139-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-140-MASK]: https://wiki.facepunch.com/gmod/Enums/MASK
[ref-141-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-142-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-143-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-144-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-145-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-146-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-147-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-148-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-149-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-150-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-151-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-152-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-153-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-154-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-155-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-156-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-157-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-158-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-159-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-160-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-161-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-162-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-163-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-164-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-165-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-166-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-167-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-168-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-169-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-170-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-171-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-172-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-173-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-174-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-175-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-176-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-177-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-178-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-179-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-180-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-181-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-182-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-183-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-184-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-185-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-186-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-187-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-188-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-189-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-190-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-191-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-192-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-193-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-194-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-195-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-196-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-197-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-198-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-199-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-200-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-201-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-202-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-203-COLLISION_GROUP]: https://wiki.facepunch.com/gmod/Enums/COLLISION_GROUP
[ref-204-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-205-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-206-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-207-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-208-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-209-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-210-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-211-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-212-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-213-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-214-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-215-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-216-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-217-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-218-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-219-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-220-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-221-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-222-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-223-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-224-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-225-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-226-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-227-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-228-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-229-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-230-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-231-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-232-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-233-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-234-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-235-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-236-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-237-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-238-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-239-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-240-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-241-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-242-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-243-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-244-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-245-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-246-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-247-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-248-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-249-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-250-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-251-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-252-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-253-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-254-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-255-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-256-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-257-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-258-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-259-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-260-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-261-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-262-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-263-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-264-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-265-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-266-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-267-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-268-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-269-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-270-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-271-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-272-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-273-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-274-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-275-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-276-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-277-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-278-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-279-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-280-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-281-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-282-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-283-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-284-vectors]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-285-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-286-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-287-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-288-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-289-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-290-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-291-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-292-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-293-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-294-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-295-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-296-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-297-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-298-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-299-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-300-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-301-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-302-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-303-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-304-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-305-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-306-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-307-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-308-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-309-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-310-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-311-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-312-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-313-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-314-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-315-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-316-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-317-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-318-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-319-vectors]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-320-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-321-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-322-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-323-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-324-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-325-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-326-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-327-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-328-function]: https://en.wikipedia.org/wiki/Subroutine
[ref-329-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-330-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-331-surface]: https://developer.valvesoftware.com/wiki/Material_surface_properties
[ref-332-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-333-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-334-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-335-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-336-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-337-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-338-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-339-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-340-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-341-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-342-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-343-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-344-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-345-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-346-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-347-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-348-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-349-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-350-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-351-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-352-surface]: https://developer.valvesoftware.com/wiki/Material_surface_properties
[ref-353-CONTENTS]: https://wiki.facepunch.com/gmod/Enums/CONTENTS
[ref-354-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-355-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-356-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-357-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-358-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-359-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-360-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-361-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-362-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-363-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-364-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-365-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-366-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-367-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-368-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-369-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-370-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-371-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-372-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-373-DISPSURF]: https://wiki.facepunch.com/gmod/Enums/DISPSURF
[ref-374-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-375-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-376-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-377-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-378-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-379-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-380-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-381-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-382-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-383-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-384-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-385-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-386-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-387-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-388-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-389-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-390-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-391-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-392-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-393-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-394-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-395-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-396-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-397-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-398-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-399-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-400-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-401-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-402-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-403-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-404-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-405-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-406-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-407-SURF]: https://wiki.facepunch.com/gmod/Enums/SURF
[ref-408-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-409-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-410-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-411-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-412-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-413-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-414-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-415-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-416-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-417-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-418-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-419-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-420-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-421-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-422-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-423-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-424-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-425-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-426-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-427-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-428-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-429-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-430-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-431-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-432-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-433-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-434-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-435-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-436-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-437-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-438-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-439-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-440-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-441-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-442-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-443-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-444-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-445-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-446-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-447-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-448-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-449-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-450-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-451-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-452-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-453-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-454-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-455-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-456-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-457-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-458-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-459-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-460-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-461-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-462-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-463-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-464-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-465-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-466-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-467-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-468-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-469-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-470-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-471-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-472-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-473-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-474-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-475-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-476-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-477-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-478-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-479-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-480-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-481-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-482-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-483-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-484-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-485-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-486-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-487-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-488-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-489-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-490-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-491-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-492-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-493-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-494-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-495-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-496-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-497-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
