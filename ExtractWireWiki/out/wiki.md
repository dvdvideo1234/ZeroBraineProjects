### Documentation updates

[Do **NOT** edit this documentation manually. This page is automatically generated!][ref_autogen_page]

### What does this extension do?

The [wiremod][ref_wiremod] [Lua][ref_lua] extension [`Laser`][ref_addon] is designed to be used with [`Wire Expression2`][ref_exp2]
in mind and implements general functions for retrieving various values form a dominant source entity or database entries. 
Beware of the E2 [performance][ref_perfe2] though. You can create feedback loops for controlling source beam parameters.

### What is the [wiremod][ref_wiremod] [`Laser`][ref_addon] API then?

|      Beam data parameters      | Out | Description |
|:-------------------------------|:---:|:------------|
|![image][ref-e]:`laserGetDataBounceMax`(![image][ref-n])|![image][ref-n]|Returns the maximum allowed [`laser`][ref-4-laser] [`beam`][ref-5-beam] bounces|
|![image][ref-e]:`laserGetDataBounceRest`(![image][ref-n])|![image][ref-n]|Returns the remaining [`laser`][ref-4-laser] [`beam`][ref-5-beam] bounces|
|![image][ref-e]:`laserGetDataDamage`(![image][ref-n])|![image][ref-n]|Returns the remaining [`laser`][ref-4-laser] [`beam`][ref-5-beam] damage|
|![image][ref-e]:`laserGetDataDirect`(![image][ref-n])|![image][ref-v]|Returns the last [`laser`][ref-4-laser] [`beam`][ref-5-beam] direction [`vector`][ref-6-vector]|
|![image][ref-e]:`laserGetDataForce`(![image][ref-n])|![image][ref-n]|Returns the remaining [`laser`][ref-4-laser] [`beam`][ref-5-beam] force|
|![image][ref-e]:`laserGetDataIsReflect`(![image][ref-n])|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`reflect`][ref-12-reflect] flag|
|![image][ref-e]:`laserGetDataIsRefract`(![image][ref-n])|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`refract`][ref-3-refract] flag|
|![image][ref-e]:`laserGetDataLength`(![image][ref-n])|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`beam`][ref-5-beam] length|
|![image][ref-e]:`laserGetDataLengthRest`(![image][ref-n])|![image][ref-n]|Returns the remaining [`laser`][ref-4-laser] [`beam`][ref-5-beam] length|
|![image][ref-e]:`laserGetDataOrigin`(![image][ref-n])|![image][ref-v]|Returns the last [`laser`][ref-4-laser] [`beam`][ref-5-beam] origin [`vector`][ref-6-vector]|
|![image][ref-e]:`laserGetDataPointDamage`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the [`laser`][ref-4-laser] [`beam`][ref-5-beam] node damage|
|![image][ref-e]:`laserGetDataPointForce`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the [`laser`][ref-4-laser] [`beam`][ref-5-beam] node force|
|![image][ref-e]:`laserGetDataPointIsDraw`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the [`laser`][ref-4-laser] [`beam`][ref-5-beam] node draw flag|
|![image][ref-e]:`laserGetDataPointNode`(![image][ref-n],![image][ref-n])|![image][ref-v]|Returns the [`laser`][ref-4-laser] [`beam`][ref-5-beam] node location [`vector`][ref-6-vector]|
|![image][ref-e]:`laserGetDataPointSize`(![image][ref-n])|![image][ref-n]|Returns the [`laser`][ref-4-laser] [`beam`][ref-5-beam] nodes count|
|![image][ref-e]:`laserGetDataPointWidth`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the [`laser`][ref-4-laser] [`beam`][ref-5-beam] node width|
|![image][ref-e]:`laserGetDataRange`(![image][ref-n])|![image][ref-n]|Returns the [`laser`][ref-4-laser] [`beam`][ref-5-beam] traverse range|
|![image][ref-e]:`laserGetDataSource`(![image][ref-n])|![image][ref-e]|Returns the [`laser`][ref-4-laser] [`beam`][ref-5-beam] source [`entity`][ref-11-entity]|
|![image][ref-e]:`laserGetDataWidth`(![image][ref-n])|![image][ref-n]|Returns the remaining [`laser`][ref-4-laser] [`beam`][ref-5-beam] width|

|       Beam trace parameters       | Out | Description |
|:----------------------------------|:---:|:------------|
|![image][ref-e]:`laserGetTraceAllSolid`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] all solid flag|
|![image][ref-e]:`laserGetTraceContents`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit [`surface contents enums`][ref-14-surface contents enums]|
|![image][ref-e]:`laserGetTraceDispFlags`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit [`surface displacement flag enums`][ref-10-surface displacement flag enums]|
|![image][ref-e]:`laserGetTraceEntity`(![image][ref-n])|![image][ref-e]|Returns the [`last trace`][ref-1-last trace] [`entity`][ref-11-entity]|
|![image][ref-e]:`laserGetTraceFraction`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] used hit fraction `[0-1]`|
|![image][ref-e]:`laserGetTraceFractionLS`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] fraction left solid `[0-1]`|
|![image][ref-e]:`laserGetTraceHit`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit flag|
|![image][ref-e]:`laserGetTraceHitBox`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit box `ID`|
|![image][ref-e]:`laserGetTraceHitGroup`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] [`hit group enums`][ref-2-hit group enums]|
|![image][ref-e]:`laserGetTraceHitNoDraw`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit no-draw brush|
|![image][ref-e]:`laserGetTraceHitNonWorld`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit non-world flag|
|![image][ref-e]:`laserGetTraceHitNormal`(![image][ref-n])|![image][ref-v]|Returns the [`last trace`][ref-1-last trace] hit [`normal`][ref-8-normal] [`vector`][ref-6-vector]|
|![image][ref-e]:`laserGetTraceHitPhysicsBone`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit physics bone `ID`|
|![image][ref-e]:`laserGetTraceHitPos`(![image][ref-n])|![image][ref-v]|Returns the [`last trace`][ref-1-last trace] hit position [`vector`][ref-6-vector]|
|![image][ref-e]:`laserGetTraceHitSky`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit sky flag|
|![image][ref-e]:`laserGetTraceHitTexture`(![image][ref-n])|![image][ref-s]|Returns the [`last trace`][ref-1-last trace] hit texture|
|![image][ref-e]:`laserGetTraceHitWorld`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit world flag|
|![image][ref-e]:`laserGetTraceMatType`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] [`material type enums`][ref-17-material type enums]|
|![image][ref-e]:`laserGetTraceNormal`(![image][ref-n])|![image][ref-v]|Returns the [`last trace`][ref-1-last trace] [`normal`][ref-8-normal] [`vector`][ref-6-vector]|
|![image][ref-e]:`laserGetTraceStartPos`(![image][ref-n])|![image][ref-v]|Returns the [`last trace`][ref-1-last trace] start position|
|![image][ref-e]:`laserGetTraceStartSolid`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] start solid flag|
|![image][ref-e]:`laserGetTraceSurfaceFlags`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit [`surface flags enums`][ref-15-surface flags enums]|
|![image][ref-e]:`laserGetTraceSurfacePropsID`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit surface property `ID`|
|![image][ref-e]:`laserGetTraceSurfacePropsName`(![image][ref-n])|![image][ref-s]|Returns the [`last trace`][ref-1-last trace] hit surface property name|

|  Class configurations   | Out | Description |
|:------------------------|:---:|:------------|
|![image][ref-e]:`laserGetBeamDamage`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`beam`][ref-5-beam] damage|
|![image][ref-e]:`laserGetBeamForce`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`beam`][ref-5-beam] force|
|![image][ref-e]:`laserGetBeamLength`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`beam`][ref-5-beam] length|
|![image][ref-e]:`laserGetBeamMaterial`()|![image][ref-s]|Returns the [`laser`][ref-4-laser] source [`beam`][ref-5-beam] material|
|![image][ref-e]:`laserGetBeamPower`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`beam`][ref-5-beam] power|
|![image][ref-e]:`laserGetBeamWidth`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`beam`][ref-5-beam] width|
|![image][ref-e]:`laserGetDissolveType`()|![image][ref-s]|Returns the [`laser`][ref-4-laser] source [`dissolve`][ref-13-dissolve] type name|
|![image][ref-e]:`laserGetDissolveTypeID`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`dissolve`][ref-13-dissolve] type `ID`|
|![image][ref-e]:`laserGetEndingEffect`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source ending effect flag|
|![image][ref-e]:`laserGetForceCenter`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source force in center flag|
|![image][ref-e]:`laserGetKillSound`()|![image][ref-s]|Returns the [`laser`][ref-4-laser] source kill sound|
|![image][ref-e]:`laserGetNonOverMater`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source base [`entity`][ref-11-entity] material flag|
|![image][ref-e]:`laserGetPlayer`()|![image][ref-e]|Returns the [`laser`][ref-4-laser] unit player getting the kill credit|
|![image][ref-e]:`laserGetReflectRatio`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`reflection`][ref-16-reflection] ratio flag|
|![image][ref-e]:`laserGetRefractRatio`()|![image][ref-n]|Returns the [`laser`][ref-4-laser] source [`refraction`][ref-18-refraction] ratio flag|
|![image][ref-e]:`laserGetStartSound`()|![image][ref-s]|Returns the [`laser`][ref-4-laser] source start sound|
|![image][ref-e]:`laserGetStopSound`()|![image][ref-s]|Returns the [`laser`][ref-4-laser] source stop sound|

|              Other helper functions              | Out | Description |
|:-------------------------------------------------|:---:|:------------|
|`laserGetBeamIsPower`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the flag indicating the power enabled threshold|
|`laserGetBeamPower`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the calcuated power by external width and damage|
|`laserGetReflectBeam`(![image][ref-v],![image][ref-v])|![image][ref-v]|Returns the reflected [`vector`][ref-6-vector] by external [`incident`][ref-7-incident] and [`normal`][ref-8-normal]|
|`laserGetReflectDataKey`(![image][ref-s])|![image][ref-s]|Returns the [`reflect`][ref-12-reflect] loop key database entry|
|`laserGetReflectDataRatio`(![image][ref-s])|![image][ref-n]|Returns the [`reflect`][ref-12-reflect] ratio database entry|
|`laserGetRefractBeam`(![image][ref-v],![image][ref-v],![image][ref-n],![image][ref-n])|![image][ref-v]|Returns the refracted [`vector`][ref-6-vector] by external [`incident`][ref-7-incident], [`normal`][ref-8-normal] and [`medium`][ref-9-medium] indices|
|`laserGetRefractDataIndex`(![image][ref-s])|![image][ref-n]|Returns the [`refract`][ref-3-refract] index database entry|
|`laserGetRefractDataKey`(![image][ref-s])|![image][ref-s]|Returns the [`refract`][ref-3-refract] loop key database entry|
|`laserGetRefractDataRatio`(![image][ref-s])|![image][ref-n]|Returns the [`refract`][ref-3-refract] ratio database entry|
|`laserGetRefractIsOut`()|![image][ref-n]|Returns a flag indicating the [`beam`][ref-5-beam] exiting the [`medium`][ref-9-medium] after refracting|

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
[ref_entity]: https://wiki.garrysmod.com/page/Global/Entity
[ref_lua]: https://en.wikipedia.org/wiki/Lua_(programming_language)
[ref_exp2]: https://github.com/wiremod/wire/wiki/Expression-2
[ref_perfe2]: https://github.com/wiremod/wire/wiki/Expression-2#performance
[ref_addon]: https://en.wikipedia.org/wiki/Laser
[ref_wiremod]: https://wiremod.com/
[ref_autogen_page]: https://github.com/dvdvideo1234/ZeroBraineProjects/blob/master/ExtractWireWiki/api/laserbeam.lua
[ref-1-last trace]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-2-hit group enums]: https://wiki.facepunch.com/gmod/Enums/HITGROUP
[ref-3-refract]: https://en.wikipedia.org/wiki/Refraction
[ref-4-laser]: https://en.wikipedia.org/wiki/Laser
[ref-5-beam]: https://en.wikipedia.org/wiki/Laser
[ref-6-vector]: https://wiki.facepunch.com/gmod/Vector
[ref-7-incident]: https://en.wikipedia.org/wiki/Ray_(optics)
[ref-8-normal]: https://en.wikipedia.org/wiki/Normal_(geometry)
[ref-9-medium]: https://en.wikipedia.org/wiki/Optical_medium
[ref-10-surface displacement flag enums]: https://wiki.facepunch.com/gmod/Enums/DISPSURF
[ref-11-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-12-reflect]: https://en.wikipedia.org/wiki/Reflection_(physics)
[ref-13-dissolve]: https://developer.valvesoftware.com/wiki/Env_entity_dissolver
[ref-14-surface contents enums]: https://wiki.facepunch.com/gmod/Enums/CONTENTS
[ref-15-surface flags enums]: https://wiki.facepunch.com/gmod/Enums/SURF
[ref-16-reflection]: https://en.wikipedia.org/wiki/Reflection_(physics)
[ref-17-material type enums]: https://wiki.facepunch.com/gmod/Enums/MAT
[ref-18-refraction]: https://en.wikipedia.org/wiki/Refraction
