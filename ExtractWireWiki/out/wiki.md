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
|`newFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-416-trace] relative to the world by zero [`origin`][ref-417-origin] [`position`][ref-418-position], up [`direction`][ref-419-direction] [`vector`][ref-420-vector] and [`length`][ref-421-length] [`distance`][ref-422-distance]|
|`newFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-423-trace] relative to the world by [`origin`][ref-424-origin] [`position`][ref-425-position], up [`direction`][ref-426-direction] [`vector`][ref-427-vector] and [`direction`][ref-428-direction] [`length`][ref-429-length] [`distance`][ref-430-distance]|
|`newFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-7-trace] relative to the world by [`origin`][ref-8-origin] [`position`][ref-9-position], up [`direction`][ref-10-direction] [`vector`][ref-11-vector] and [`length`][ref-12-length] [`distance`][ref-13-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-152-trace] relative to the world by [`origin`][ref-153-origin] [`position`][ref-154-position], [`direction`][ref-155-direction] [`vector`][ref-156-vector] and [`direction`][ref-157-direction] [`length`][ref-158-length] [`distance`][ref-159-distance]|
|`newFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-433-trace] relative to the world by [`origin`][ref-434-origin] [`position`][ref-435-position], [`direction`][ref-436-direction] [`vector`][ref-437-vector], [`length`][ref-438-length] [`distance`][ref-439-distance]|
|`noFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns invalid flash [`trace`][ref-194-trace] object|

|           Class methods           | Out | Description |
|:----------------------------------|:---:|:------------|
|![image][ref-xft]:`dumpItem`(![image][ref-n])|![image][ref-xft]|Dumps the flash [`trace`][ref-5-trace] to the chat area by [`number`][ref-6-number] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s])|![image][ref-xft]|Dumps the flash [`trace`][ref-78-trace] to the chat area by [`string`][ref-79-string] identifier|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Dumps the flash [`trace`][ref-500-trace] by [`number`][ref-501-number] identifier in the specified area by first argument|
|![image][ref-xft]:`dumpItem`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Dumps the flash [`trace`][ref-491-trace] by [`string`][ref-492-string] identifier in the specified area by first argument|
|![image][ref-xft]:`getBase`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-218-trace] base attachment [`entity`][ref-219-entity] if available|
|![image][ref-xft]:`getChip`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-367-trace] auto-assigned expression chip [`entity`][ref-368-entity]|
|![image][ref-xft]:`getCollideGroup`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-35-trace] [`trace`][ref-36-trace] collision group [`enums`][ref-37-enums] [`COLLISION_GROUP`][ref-38-COLLISION_GROUP]|
|![image][ref-xft]:`getCopy`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-190-trace] copy instance of the current object|
|![image][ref-xft]:`getCopy`(![image][ref-e])|![image][ref-xft]|Returns flash [`trace`][ref-284-trace] copy instance of the current object with other [`entity`][ref-285-entity]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-251-trace] copy instance of the current object with other [`entity`][ref-252-entity] and [`length`][ref-253-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-118-trace] copy instance of the current object with other [`entity`][ref-119-entity] and [`origin`][ref-120-origin]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-496-trace] copy instance of the current object with other [`entity`][ref-497-entity], [`origin`][ref-498-origin] and [`length`][ref-499-length]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-186-trace] copy instance of the current object with other [`entity`][ref-187-entity], [`origin`][ref-188-origin] and [`direction`][ref-189-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-e],![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-102-trace] copy instance of the current object with other [`entity`][ref-103-entity], [`origin`][ref-104-origin], [`direction`][ref-105-direction] and [`length`][ref-106-length]|
|![image][ref-xft]:`getCopy`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-49-trace] copy instance of the current object with other [`length`][ref-50-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-220-trace] copy instance of the current object with other [`origin`][ref-221-origin]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-125-trace] copy instance of the current object with other [`origin`][ref-126-origin] and [`length`][ref-127-length]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-364-trace] copy instance of the current object with other [`origin`][ref-365-origin] and [`direction`][ref-366-direction]|
|![image][ref-xft]:`getCopy`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-412-trace] copy instance of the current object with other [`origin`][ref-413-origin], [`direction`][ref-414-direction] and [`length`][ref-415-length]|
|![image][ref-xft]:`getDir`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-395-trace] [`direction`][ref-396-direction] [`vector`][ref-397-vector]|
|![image][ref-xft]:`getDirLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-473-trace] world [`direction`][ref-474-direction] [`vector`][ref-475-vector] converted to base attachment [`entity`][ref-476-entity] local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-380-trace] world [`direction`][ref-381-direction] [`vector`][ref-382-vector] converted to [`angle`][ref-383-angle] local axis|
|![image][ref-xft]:`getDirLocal`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-209-trace] world [`direction`][ref-210-direction] [`vector`][ref-211-vector] converted to [`entity`][ref-212-entity] local axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-128-trace] local [`direction`][ref-129-direction] [`vector`][ref-130-vector] converted to base attachment [`entity`][ref-131-entity] world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-451-trace] local [`direction`][ref-452-direction] [`vector`][ref-453-vector] converted to [`angle`][ref-454-angle] world axis|
|![image][ref-xft]:`getDirWorld`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-1-trace] local [`direction`][ref-2-direction] [`vector`][ref-3-vector] converted to [`entity`][ref-4-entity] world axis|
|![image][ref-xft]:`getDisplaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-376-trace] [`trace-result`][ref-377-trace-result] `DispFlags` [`DISPSURF`][ref-378-DISPSURF] [`bitmask`][ref-379-bitmask]|
|![image][ref-xft]:`getEar`(![image][ref-xxx])|![image][ref-r]|Returns the configuration used by the [`entity`][ref-216-entity] [`array`][ref-217-array] filter|
|![image][ref-xft]:`getEarID`(![image][ref-xxx])|![image][ref-r]|Returns the configuration used by the [`entity`][ref-468-entity] [`array`][ref-469-array] filter as `ID` indexes|
|![image][ref-xft]:`getEarSZ`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-334-trace] [`entity`][ref-335-entity] filter [`array`][ref-336-array] size|
|![image][ref-xft]:`getEntity`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-196-trace] [`trace-result`][ref-197-trace-result] `Entity` [`entity`][ref-198-entity]|
|![image][ref-xft]:`getFilterMode`(![image][ref-xxx])|![image][ref-s]|Returns flash tracer filter working mode|
|![image][ref-xft]:`getFraction`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-244-trace] [`trace-result`][ref-245-trace-result] `Fraction` in the interval `[0-1]` [`number`][ref-246-number]|
|![image][ref-xft]:`getFractionLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-132-trace] [`trace-result`][ref-133-trace-result] `FractionLeftSolid` in the interval `[0-1]` [`number`][ref-134-number]|
|![image][ref-xft]:`getFractionLen`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-390-trace] [`trace-result`][ref-391-trace-result] `Fraction` multiplied by its [`length`][ref-392-length] [`distance`][ref-393-distance] [`number`][ref-394-number]|
|![image][ref-xft]:`getFractionLenLS`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-67-trace] [`trace-result`][ref-68-trace-result] `FractionLeftSolid` multiplied by its [`length`][ref-69-length] [`distance`][ref-70-distance] [`number`][ref-71-number]|
|![image][ref-xft]:`getHitBox`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-464-trace] [`trace-result`][ref-465-trace-result] `HitBox` [`number`][ref-466-number]|
|![image][ref-xft]:`getHitContents`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-455-trace] [`trace-result`][ref-456-trace-result] hit [`surface`][ref-457-surface] `Contents` [`CONTENTS`][ref-458-CONTENTS] [`bitmask`][ref-459-bitmask]|
|![image][ref-xft]:`getHitGroup`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-443-trace] [`trace-result`][ref-444-trace-result] `HitGroup` group `ID` [`number`][ref-445-number]|
|![image][ref-xft]:`getHitNormal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-460-trace] [`trace-result`][ref-461-trace-result] [`surface`][ref-462-surface] `HitNormal` [`vector`][ref-463-vector]|
|![image][ref-xft]:`getHitPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-43-trace] [`trace-result`][ref-44-trace-result] `HitPos` location [`vector`][ref-45-vector]|
|![image][ref-xft]:`getHitTexture`(![image][ref-xxx])|![image][ref-s]|Returns the flash [`trace`][ref-488-trace] [`trace-result`][ref-489-trace-result] `HitTexture` [`string`][ref-490-string]|
|![image][ref-xft]:`getLen`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-331-trace] [`length`][ref-332-length] [`distance`][ref-333-distance]|
|![image][ref-xft]:`getMask`(![image][ref-xxx])|![image][ref-n]|Returns flash [`trace`][ref-135-trace] [`trace`][ref-136-trace] hit [`mask`][ref-137-mask] [`enums`][ref-138-enums] [`MASK`][ref-139-MASK]|
|![image][ref-xft]:`getMatType`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-191-trace] [`trace-result`][ref-192-trace-result] `MatType` material type [`number`][ref-193-number]|
|![image][ref-xft]:`getNormal`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-46-trace] [`trace-result`][ref-47-trace-result] `Normal` aim [`vector`][ref-48-vector]|
|![image][ref-xft]:`getPhysicsBoneID`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-213-trace] [`trace-result`][ref-214-trace-result] `PhysicsBone` `ID` [`number`][ref-215-number]|
|![image][ref-xft]:`getPlayer`(![image][ref-xxx])|![image][ref-e]|Returns the flash [`trace`][ref-487-trace] auto-assigned expression chip player|
|![image][ref-xft]:`getPos`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-300-trace] [`origin`][ref-301-origin] [`position`][ref-302-position]|
|![image][ref-xft]:`getPosLocal`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-355-trace] world [`origin`][ref-356-origin] [`position`][ref-357-position] converted to base attachment [`entity`][ref-358-entity] local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-296-trace] world [`origin`][ref-297-origin] [`position`][ref-298-position] converted to [`entity`][ref-299-entity] local axis|
|![image][ref-xft]:`getPosLocal`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-62-trace] world [`origin`][ref-63-origin] [`position`][ref-64-position] converted to [`position`][ref-65-position]/[`angle`][ref-66-angle] local axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-238-trace] local [`origin`][ref-239-origin] [`position`][ref-240-position] converted to base attachment [`entity`][ref-241-entity] world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-e])|![image][ref-v]|Returns flash [`trace`][ref-481-trace] local [`origin`][ref-482-origin] [`position`][ref-483-position] converted to [`entity`][ref-484-entity] world axis|
|![image][ref-xft]:`getPosWorld`(![image][ref-v],![image][ref-a])|![image][ref-v]|Returns flash [`trace`][ref-359-trace] local [`origin`][ref-360-origin] [`position`][ref-361-position] converted to [`position`][ref-362-position]/[`angle`][ref-363-angle] world axis|
|![image][ref-xft]:`getStart`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-72-trace] [`trace`][ref-73-trace] start [`position`][ref-74-position] sent to [`trace-line`][ref-75-trace-line]|
|![image][ref-xft]:`getStartPos`(![image][ref-xxx])|![image][ref-v]|Returns the flash [`trace`][ref-148-trace] [`trace-result`][ref-149-trace-result] `StartPos` [`vector`][ref-150-vector]|
|![image][ref-xft]:`getStop`(![image][ref-xxx])|![image][ref-v]|Returns flash [`trace`][ref-95-trace] [`trace`][ref-96-trace] stop [`position`][ref-97-position] sent to [`trace-line`][ref-98-trace-line]|
|![image][ref-xft]:`getSurfPropsID`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-440-trace] [`trace-result`][ref-441-trace-result] `SurfaceProps` `ID` type [`number`][ref-442-number]|
|![image][ref-xft]:`getSurfPropsName`(![image][ref-xxx])|![image][ref-s]|Returns the flash [`trace`][ref-115-trace] [`trace-result`][ref-116-trace-result] `SurfaceProps` `ID` type name [`string`][ref-117-string]|
|![image][ref-xft]:`getSurfaceFlags`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-408-trace] [`trace-result`][ref-409-trace-result] `SurfaceFlags` [`SURF`][ref-410-SURF] [`bitmask`][ref-411-bitmask]|
|![image][ref-xft]:`insEar`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-222-entity] in the filter list|
|![image][ref-xft]:`insEar`(![image][ref-r])|![image][ref-xft]|Inserts the [`entities`][ref-369-entities] from the [`array`][ref-370-array] in the filter list|
|![image][ref-xft]:`insEar`(![image][ref-t])|![image][ref-xft]|Inserts the [`entities`][ref-268-entities] from the table in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-n])|![image][ref-xft]|Inserts the [`entity`][ref-55-entity] `ID` in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-r])|![image][ref-xft]|Inserts the [`entity`][ref-160-entity] `ID` from the [`array`][ref-161-array] in the filter list|
|![image][ref-xft]:`insEarID`(![image][ref-t])|![image][ref-xft]|Inserts the [`entity`][ref-467-entity] `ID` from the table in the filter list|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-54-trace] internal hit only list|
|![image][ref-xft]:`insFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-311-trace] internal hit only list|
|![image][ref-xft]:`insFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-123-entity] to the flash [`trace`][ref-124-trace] internal only hit list|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-227-trace] internal ignore hit list|
|![image][ref-xft]:`insFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Inserts the option to the flash [`trace`][ref-291-trace] internal ignore hit list|
|![image][ref-xft]:`insFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Inserts the [`entity`][ref-431-entity] to the flash [`trace`][ref-432-trace] internal ignore hit list|
|![image][ref-xft]:`isAllSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-303-trace] [`trace-result`][ref-304-trace-result] `AllSolid` flag|
|![image][ref-xft]:`isHit`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-479-trace] [`trace-result`][ref-480-trace-result] `Hit` flag|
|![image][ref-xft]:`isHitNoDraw`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-203-trace] [`trace-result`][ref-204-trace-result] `HitNoDraw` flag|
|![image][ref-xft]:`isHitNonWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-14-trace] [`trace-result`][ref-15-trace-result] `HitNonWorld` flag|
|![image][ref-xft]:`isHitSky`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-232-trace] [`trace-result`][ref-233-trace-result] `HitSky` flag|
|![image][ref-xft]:`isHitWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-406-trace] [`trace-result`][ref-407-trace-result] `HitWorld` flag|
|![image][ref-xft]:`isIgnoreWorld`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-485-trace] [`trace`][ref-486-trace] `IgnoreWorld` flag|
|![image][ref-xft]:`isStartSolid`(![image][ref-xxx])|![image][ref-n]|Returns the flash [`trace`][ref-449-trace] [`trace-result`][ref-450-trace-result] `StartSolid` flag|
|![image][ref-xft]:`rayAim`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Aims the flash [`trace`][ref-99-trace] ray at a given [`position`][ref-100-position] using three [`numbers`][ref-101-numbers]|
|![image][ref-xft]:`rayAim`(![image][ref-v])|![image][ref-xft]|Aims the flash [`trace`][ref-446-trace] ray at a given [`position`][ref-447-position] using a [`vector`][ref-448-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Amends the flash [`trace`][ref-87-trace] ray [`direction`][ref-88-direction] using three [`numbers`][ref-89-numbers]|
|![image][ref-xft]:`rayAmend`(![image][ref-v])|![image][ref-xft]|Amends the flash [`trace`][ref-183-trace] ray [`direction`][ref-184-direction] using a [`vector`][ref-185-vector]|
|![image][ref-xft]:`rayAmend`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Amends the flash [`trace`][ref-247-trace] ray [`direction`][ref-248-direction] using [`vector`][ref-249-vector] and [`magnitude`][ref-250-magnitude]|
|![image][ref-xft]:`rayDiv`(![image][ref-n])|![image][ref-xft]|Contracts the flash [`trace`][ref-266-trace] ray with a [`number`][ref-267-number]|
|![image][ref-xft]:`rayDiv`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Contracts the flash [`trace`][ref-477-trace] ray each component individually using three [`numbers`][ref-478-numbers]|
|![image][ref-xft]:`rayDiv`(![image][ref-v])|![image][ref-xft]|Contracts the flash [`trace`][ref-121-trace] ray each component individually using a [`vector`][ref-122-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-xxx])|![image][ref-xft]|Moves the flash [`trace`][ref-307-trace] ray with its own [`direction`][ref-308-direction] and [`magnitude`][ref-309-magnitude]|
|![image][ref-xft]:`rayMove`(![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-205-trace] ray with its own [`direction`][ref-206-direction] and [`magnitude`][ref-207-magnitude] [`length`][ref-208-length]|
|![image][ref-xft]:`rayMove`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-388-trace] ray with displacement as three [`numbers`][ref-389-numbers]|
|![image][ref-xft]:`rayMove`(![image][ref-v])|![image][ref-xft]|Moves the flash [`trace`][ref-384-trace] ray with displacement [`vector`][ref-385-vector]|
|![image][ref-xft]:`rayMove`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Moves the flash [`trace`][ref-371-trace] ray with [`direction`][ref-372-direction] [`vector`][ref-373-vector], [`magnitude`][ref-374-magnitude] [`length`][ref-375-length]|
|![image][ref-xft]:`rayMul`(![image][ref-n])|![image][ref-xft]|Expands the flash [`trace`][ref-225-trace] ray with a [`number`][ref-226-number]|
|![image][ref-xft]:`rayMul`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Expands the flash [`trace`][ref-166-trace] ray each component individually using three [`numbers`][ref-167-numbers]|
|![image][ref-xft]:`rayMul`(![image][ref-v])|![image][ref-xft]|Expands the flash [`trace`][ref-93-trace] ray each component individually using a [`vector`][ref-94-vector]|
|![image][ref-xft]:`remBase`(![image][ref-xxx])|![image][ref-xft]|Removes the base attachment [`entity`][ref-242-entity] of the flash [`trace`][ref-243-trace]|
|![image][ref-xft]:`remEar`(![image][ref-xxx])|![image][ref-xft]|Removes all [`entities`][ref-195-entities] from the filter list|
|![image][ref-xft]:`remEar`(![image][ref-e])|![image][ref-xft]|Removes the specified [`entity`][ref-151-entity] from the filter list|
|![image][ref-xft]:`remEarID`(![image][ref-n])|![image][ref-xft]|Removes the specified [`entity`][ref-92-entity] by `ID` from the filter list|
|![image][ref-xft]:`remEarN`(![image][ref-n])|![image][ref-xft]|Removes an [`entity`][ref-471-entity] using the specified sequential [`number`][ref-472-number]|
|![image][ref-xft]:`remFilter`(![image][ref-xxx])|![image][ref-xft]|Removes the filter from the [`trace`][ref-59-trace] configuration|
|![image][ref-xft]:`remFnc`(![image][ref-xxx])|![image][ref-xft]|Removes all the options from the flash [`trace`][ref-26-trace] internal hit preferences|
|![image][ref-xft]:`remFnc`(![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-310-trace] internal hit preferences|
|![image][ref-xft]:`remFncEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-327-entities] from the flash [`trace`][ref-328-trace] internal hit list|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-81-trace] internal only hit list|
|![image][ref-xft]:`remFncOnly`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-80-trace] internal only hit list|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-255-entities] from the flash [`trace`][ref-256-trace] internal only hit list|
|![image][ref-xft]:`remFncOnlyEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-90-entity] from the flash [`trace`][ref-91-trace] internal only hit list|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-n])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-470-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkip`(![image][ref-s],![image][ref-s])|![image][ref-xft]|Removes the option from the flash [`trace`][ref-254-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-xxx])|![image][ref-xft]|Removes all the [`entities`][ref-386-entities] from the flash [`trace`][ref-387-trace] internal ignore hit list|
|![image][ref-xft]:`remFncSkipEnt`(![image][ref-e])|![image][ref-xft]|Removes the [`entity`][ref-76-entity] from the flash [`trace`][ref-77-trace] internal ignore hit list|
|![image][ref-xft]:`setBase`(![image][ref-e])|![image][ref-xft]|Updates the flash [`trace`][ref-223-trace] base attachment [`entity`][ref-224-entity]|
|![image][ref-xft]:`setCollideGroup`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-199-trace] [`trace`][ref-200-trace] collision group [`enums`][ref-201-enums] [`COLLISION_GROUP`][ref-202-COLLISION_GROUP]|
|![image][ref-xft]:`setDir`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-56-trace] [`direction`][ref-57-direction] using three [`numbers`][ref-58-numbers]|
|![image][ref-xft]:`setDir`(![image][ref-r])|![image][ref-xft]|Updates the flash [`trace`][ref-107-trace] [`direction`][ref-108-direction] using an [`array`][ref-109-array]|
|![image][ref-xft]:`setDir`(![image][ref-v])|![image][ref-xft]|Updates the flash [`trace`][ref-493-trace] [`direction`][ref-494-direction] using a [`vector`][ref-495-vector]|
|![image][ref-xft]:`setFilterEar`(![image][ref-xxx])|![image][ref-xft]|Changes the filtering mode to [`entity`][ref-60-entity] [`array`][ref-61-array]|
|![image][ref-xft]:`setFilterEnt`(![image][ref-e])|![image][ref-xft]|Changes the filtering mode to [`entity`][ref-330-entity] object|
|![image][ref-xft]:`setFilterFnc`(![image][ref-xxx])|![image][ref-xft]|Changes the filtering mode to [`function`][ref-329-function] routine|
|![image][ref-xft]:`setIsIgnoreWorld`(![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-16-trace] [`trace`][ref-17-trace] `IgnoreWorld` flag|
|![image][ref-xft]:`setLen`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-324-trace] [`length`][ref-325-length] [`distance`][ref-326-distance]|
|![image][ref-xft]:`setMask`(![image][ref-n])|![image][ref-xft]|Updates flash [`trace`][ref-110-trace] [`trace`][ref-111-trace] hit [`mask`][ref-112-mask] [`enums`][ref-113-enums] [`MASK`][ref-114-MASK]|
|![image][ref-xft]:`setPos`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xft]|Updates the flash [`trace`][ref-39-trace] [`origin`][ref-40-origin] [`position`][ref-41-position] using three [`numbers`][ref-42-numbers]|
|![image][ref-xft]:`setPos`(![image][ref-r])|![image][ref-xft]|Updates the flash [`trace`][ref-234-trace] [`origin`][ref-235-origin] [`position`][ref-236-position] using an [`array`][ref-237-array]|
|![image][ref-xft]:`setPos`(![image][ref-v])|![image][ref-xft]|Updates the flash [`trace`][ref-162-trace] [`origin`][ref-163-origin] [`position`][ref-164-position] using a [`vector`][ref-165-vector]|
|![image][ref-xft]:`smpLocal`(![image][ref-xxx])|![image][ref-xft]|Samples the flash [`trace`][ref-321-trace] and updates the [`trace-result`][ref-322-trace-result] by base attachment [`entity`][ref-323-entity] local axis|
|![image][ref-xft]:`smpLocal`(![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-228-trace] and updates the [`trace-result`][ref-229-trace-result] by base [`position`][ref-230-position], [`angle`][ref-231-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e])|![image][ref-xft]|Samples the flash [`trace`][ref-316-trace] and updates the [`trace-result`][ref-317-trace-result] by [`entity`][ref-318-entity] [`position`][ref-319-position] and forward [`vectors`][ref-320-vectors]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-168-trace] and updates the [`trace-result`][ref-169-trace-result] by [`entity`][ref-170-entity] [`position`][ref-171-position], [`angle`][ref-172-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-82-trace] and updates the [`trace-result`][ref-83-trace-result] by [`position`][ref-84-position], [`entity`][ref-85-entity] [`angle`][ref-86-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-292-trace] and updates the [`trace-result`][ref-293-trace-result] by [`position`][ref-294-position], base [`angle`][ref-295-angle]|
|![image][ref-xft]:`smpLocal`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-312-trace] and updates the [`trace-result`][ref-313-trace-result] by [`position`][ref-314-position], [`angle`][ref-315-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-xxx])|![image][ref-xft]|Samples the flash [`trace`][ref-305-trace] and updates the [`trace-result`][ref-306-trace-result] by the world axis|
|![image][ref-xft]:`smpWorld`(![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-286-trace] and updates the [`trace-result`][ref-287-trace-result] by [`entity`][ref-288-entity] [`position`][ref-289-position] and [`angle`][ref-290-angle] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-e])|![image][ref-xft]|Samples the flash [`trace`][ref-279-trace] and updates the [`trace-result`][ref-280-trace-result] by [`entity`][ref-281-entity] [`position`][ref-282-position] and forward [`vectors`][ref-283-vectors]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-274-trace] and updates the [`trace-result`][ref-275-trace-result] by [`entity`][ref-276-entity] [`position`][ref-277-position], [`angle`][ref-278-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-e],![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-269-trace] and updates the [`trace-result`][ref-270-trace-result] by [`position`][ref-271-position], [`entity`][ref-272-entity] [`angle`][ref-273-angle]|
|![image][ref-xft]:`smpWorld`(![image][ref-v])|![image][ref-xft]|Samples the flash [`trace`][ref-261-trace] and updates the [`trace-result`][ref-262-trace-result] by [`position`][ref-263-position] [`vector`][ref-264-vector] and [`entity`][ref-265-entity] forward|
|![image][ref-xft]:`smpWorld`(![image][ref-v],![image][ref-a])|![image][ref-xft]|Samples the flash [`trace`][ref-257-trace] and updates the [`trace-result`][ref-258-trace-result] by [`position`][ref-259-position], [`angle`][ref-260-angle]|
|![image][ref-xft]:`updEarSZ`(![image][ref-xxx])|![image][ref-xft]|Performs flash [`trace`][ref-51-trace] [`entity`][ref-52-entity] [`array`][ref-53-array] filter list refresh|

|    General functions    | Out | Description |
|:------------------------|:---:|:------------|
|![image][ref-e]:`setFTrace`(![image][ref-xxx])|![image][ref-xft]|Returns flash [`trace`][ref-174-trace] relative to the [`entity`][ref-175-entity] by zero [`origin`][ref-176-origin] [`position`][ref-177-position], up [`direction`][ref-178-direction] [`vector`][ref-179-vector] and [`direction`][ref-180-direction] [`length`][ref-181-length] [`distance`][ref-182-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-140-trace] relative to the [`entity`][ref-141-entity] by zero [`origin`][ref-142-origin] [`position`][ref-143-position], up [`direction`][ref-144-direction] [`vector`][ref-145-vector] and [`length`][ref-146-length] [`distance`][ref-147-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-346-trace] relative to the [`entity`][ref-347-entity] by [`origin`][ref-348-origin] [`position`][ref-349-position], up [`direction`][ref-350-direction] [`vector`][ref-351-vector] and [`direction`][ref-352-direction] [`length`][ref-353-length] [`distance`][ref-354-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-27-trace] relative to the [`entity`][ref-28-entity] by [`origin`][ref-29-origin] [`position`][ref-30-position], up [`direction`][ref-31-direction] [`vector`][ref-32-vector] and [`length`][ref-33-length] [`distance`][ref-34-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v])|![image][ref-xft]|Returns flash [`trace`][ref-337-trace] relative to the [`entity`][ref-338-entity] by [`origin`][ref-339-origin] [`position`][ref-340-position], [`direction`][ref-341-direction] [`vector`][ref-342-vector] and [`direction`][ref-343-direction] [`length`][ref-344-length] [`distance`][ref-345-distance]|
|![image][ref-e]:`setFTrace`(![image][ref-v],![image][ref-v],![image][ref-n])|![image][ref-xft]|Returns flash [`trace`][ref-398-trace] relative to the [`entity`][ref-399-entity] by [`origin`][ref-400-origin] [`position`][ref-401-position], [`direction`][ref-402-direction] [`vector`][ref-403-vector], [`length`][ref-404-length] [`distance`][ref-405-distance]|

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
[ref-81-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-82-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-83-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-84-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-85-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-86-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-87-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-88-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-89-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-90-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-91-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-92-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-93-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-94-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-95-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-96-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-97-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-98-trace-line]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-99-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-100-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-101-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-102-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-103-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-104-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-105-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-106-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-107-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-108-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-109-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-110-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-111-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-112-mask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-113-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-114-MASK]: https://wiki.facepunch.com/gmod/Enums/MASK
[ref-115-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-116-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-117-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-118-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-119-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-120-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-121-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-122-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-123-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-124-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-125-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-126-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-127-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-128-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-129-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-130-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-131-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-132-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-133-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-134-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-135-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-136-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-137-mask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-138-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-139-MASK]: https://wiki.facepunch.com/gmod/Enums/MASK
[ref-140-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-141-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-142-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-143-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-144-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-145-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-146-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-147-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-148-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-149-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-150-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-151-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-152-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-153-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-154-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-155-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-156-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-157-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-158-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-159-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-160-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-161-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-162-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-163-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-164-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-165-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-166-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-167-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-168-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-169-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-170-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-171-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-172-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-173-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-174-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-175-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-176-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-177-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-178-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-179-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-180-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-181-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-182-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-183-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-184-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-185-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-186-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-187-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-188-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-189-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-190-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-191-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-192-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-193-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-194-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-195-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-196-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-197-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-198-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-199-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-200-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-201-enums]: https://en.wikipedia.org/wiki/Enumerated_type
[ref-202-COLLISION_GROUP]: https://wiki.facepunch.com/gmod/Enums/COLLISION_GROUP
[ref-203-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-204-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-205-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-206-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-207-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-208-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-209-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-210-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-211-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-212-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-213-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-214-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-215-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-216-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-217-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-218-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-219-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-220-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-221-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-222-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-223-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-224-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-225-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-226-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-227-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-228-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-229-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-230-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-231-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-232-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-233-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-234-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-235-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-236-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-237-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-238-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-239-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-240-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-241-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-242-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-243-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-244-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-245-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-246-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-247-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-248-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-249-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-250-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-251-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-252-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-253-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-254-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-255-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-256-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-257-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-258-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-259-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-260-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-261-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-262-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-263-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-264-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-265-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-266-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-267-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-268-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-269-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-270-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-271-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-272-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-273-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-274-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-275-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-276-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-277-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-278-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-279-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-280-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-281-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-282-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-283-vectors]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-284-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-285-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-286-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-287-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-288-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-289-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-290-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-291-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-292-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-293-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-294-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-295-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-296-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-297-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-298-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-299-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-300-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-301-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-302-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-303-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-304-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-305-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-306-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-307-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-308-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-309-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-310-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-311-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-312-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-313-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-314-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-315-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-316-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-317-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-318-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-319-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-320-vectors]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-321-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-322-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-323-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-324-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-325-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-326-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-327-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-328-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-329-function]: https://en.wikipedia.org/wiki/Subroutine
[ref-330-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-331-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-332-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-333-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
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
[ref-347-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-348-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-349-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-350-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-351-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-352-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-353-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-354-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-355-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-356-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-357-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-358-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-359-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-360-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-361-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-362-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-363-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-364-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-365-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-366-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-367-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-368-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-369-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-370-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-371-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-372-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-373-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-374-magnitude]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-375-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-376-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-377-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-378-DISPSURF]: https://wiki.facepunch.com/gmod/Enums/DISPSURF
[ref-379-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-380-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-381-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-382-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-383-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-384-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-385-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-386-entities]: https://wiki.facepunch.com/gmod/Entity
[ref-387-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-388-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-389-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-390-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-391-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-392-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-393-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-394-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-395-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-396-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-397-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-398-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-399-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-400-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-401-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-402-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-403-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-404-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-405-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-406-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-407-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-408-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-409-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-410-SURF]: https://wiki.facepunch.com/gmod/Enums/SURF
[ref-411-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-412-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-413-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-414-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-415-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-416-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-417-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-418-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-419-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-420-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-421-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-422-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-423-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-424-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-425-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-426-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-427-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-428-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-429-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-430-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-431-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-432-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-433-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-434-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-435-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-436-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-437-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-438-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-439-distance]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-440-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-441-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-442-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-443-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-444-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-445-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-446-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-447-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-448-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-449-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-450-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-451-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-452-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-453-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-454-angle]: https://en.wikipedia.org/wiki/Euler_angles
[ref-455-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-456-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-457-surface]: https://developer.valvesoftware.com/wiki/Material_surface_properties
[ref-458-CONTENTS]: https://wiki.facepunch.com/gmod/Enums/CONTENTS
[ref-459-bitmask]: https://en.wikipedia.org/wiki/Mask_(computing)
[ref-460-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-461-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-462-surface]: https://developer.valvesoftware.com/wiki/Material_surface_properties
[ref-463-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-464-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-465-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-466-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-467-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-468-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-469-array]: https://en.wikipedia.org/wiki/Array_data_type
[ref-470-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-471-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-472-number]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-473-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-474-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-475-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-476-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-477-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-478-numbers]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-479-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-480-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-481-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-482-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-483-position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref-484-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-485-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-486-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-487-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-488-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-489-trace-result]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-490-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-491-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-492-string]: https://en.wikipedia.org/wiki/String_(computer_science)
[ref-493-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-494-direction]: https://en.wikipedia.org/wiki/Unit_vector
[ref-495-vector]: https://en.wikipedia.org/wiki/Euclidean_vector
[ref-496-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-497-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-498-origin]: https://en.wikipedia.org/wiki/Origin_(mathematics)
[ref-499-length]: https://en.wikipedia.org/wiki/Euclidean_distance
[ref-500-trace]: https://wiki.facepunch.com/gmod/util.TraceLine
[ref-501-number]: https://en.wikipedia.org/wiki/Euclidean_distance
