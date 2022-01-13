### What does this extension do?

The [wiremod][ref_wiremod] [Lua][ref_lua] extension [`Laser`][ref_addon] is designed to be used with [`Wire Expression2`][ref_exp2]
in mind and implements general functions for retrieving various values form a dominant source entity. 
Beware of the E2 [performance][ref_perfe2] though. You can create feebback loops for controling source beam parameters.

### What is the [wiremod][ref_wiremod] [`Laser`][ref_addon] API then?

|           Class methods           | Out | Description |
|:----------------------------------|:---:|:------------|
|![image][ref-e]:`laserGetBeamDamage`()|![image][ref-n]|Returns the laser source beam damage|
|![image][ref-e]:`laserGetBeamForce`()|![image][ref-n]|Returns the laser source beam force|
|![image][ref-e]:`laserGetBeamLength`()|![image][ref-n]|Returns the laser source beam length|
|![image][ref-e]:`laserGetBeamMaterial`()|![image][ref-s]|Returns the laser source beam material|
|![image][ref-e]:`laserGetBeamPower`()|![image][ref-n]|Returns the laser source beam power|
|![image][ref-e]:`laserGetBeamWidth`()|![image][ref-n]|Returns the laser source beam width|
|![image][ref-e]:`laserGetDataBounceMax`(![image][ref-n])|![image][ref-n]|Returns the maximum allowed laser beam bounces|
|![image][ref-e]:`laserGetDataBounceRest`(![image][ref-n])|![image][ref-n]|Returns the remaining laser beam bounces|
|![image][ref-e]:`laserGetDataDamage`(![image][ref-n])|![image][ref-n]|Returns the remaining laser beam damage|
|![image][ref-e]:`laserGetDataDirect`(![image][ref-n])|![image][ref-v]|Returns the last laser beam direction [`vector`][ref-4-vector]|
|![image][ref-e]:`laserGetDataForce`(![image][ref-n])|![image][ref-n]|Returns the remaining laser beam force|
|![image][ref-e]:`laserGetDataIsReflect`(![image][ref-n])|![image][ref-n]|Returns the laser source reflect flag|
|![image][ref-e]:`laserGetDataIsRefract`(![image][ref-n])|![image][ref-n]|Returns the laser source refract flag|
|![image][ref-e]:`laserGetDataLength`(![image][ref-n])|![image][ref-n]|Returns the laser source beam length|
|![image][ref-e]:`laserGetDataLengthRest`(![image][ref-n])|![image][ref-n]|Returns the remaining laser beam length|
|![image][ref-e]:`laserGetDataOrigin`(![image][ref-n])|![image][ref-v]|Returns the last laser beam origin [`vector`][ref-4-vector]|
|![image][ref-e]:`laserGetDataPointDamage`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the laser beam node damage|
|![image][ref-e]:`laserGetDataPointForce`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the laser beam node force|
|![image][ref-e]:`laserGetDataPointIsDraw`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the laser beam node draw flag|
|![image][ref-e]:`laserGetDataPointNode`(![image][ref-n],![image][ref-n])|![image][ref-v]|Returns the laser beam node location [`vector`][ref-4-vector]|
|![image][ref-e]:`laserGetDataPointSize`(![image][ref-n])|![image][ref-n]|Returns the laser beam nodes count|
|![image][ref-e]:`laserGetDataPointWidth`(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the laser beam node width|
|![image][ref-e]:`laserGetDataRange`(![image][ref-n])|![image][ref-n]|Returns the laser beam traverse range|
|![image][ref-e]:`laserGetDataSource`(![image][ref-n])|![image][ref-e]|Returns the laser beam source [`entity`][ref-2-entity]|
|![image][ref-e]:`laserGetDataWidth`(![image][ref-n])|![image][ref-n]|Returns the remaining laser beam width|
|![image][ref-e]:`laserGetDissolveType`()|![image][ref-s]|Returns the laser source dissolve type name|
|![image][ref-e]:`laserGetDissolveTypeID`()|![image][ref-n]|Returns the laser source dissolve type `ID`|
|![image][ref-e]:`laserGetEndingEffect`()|![image][ref-n]|Returns the laser source ending effect flag|
|![image][ref-e]:`laserGetForceCenter`()|![image][ref-n]|Returns the laser source force in center flag|
|![image][ref-e]:`laserGetKillSound`()|![image][ref-s]|Returns the laser source kill sound|
|![image][ref-e]:`laserGetNonOverMater`()|![image][ref-n]|Returns the laser source base [`entity`][ref-2-entity] material flag|
|![image][ref-e]:`laserGetPlayer`()|![image][ref-e]|Returns the laser unit player getting the kill credit|
|![image][ref-e]:`laserGetReflectRatio`()|![image][ref-n]|Returns the laser source reflection ratio flag|
|![image][ref-e]:`laserGetRefractRatio`()|![image][ref-n]|Returns the laser source refraction ratio flag|
|![image][ref-e]:`laserGetStartSound`()|![image][ref-s]|Returns the laser source start sound|
|![image][ref-e]:`laserGetStopSound`()|![image][ref-s]|Returns the laser source stop sound|
|![image][ref-e]:`laserGetTraceAllSolid`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] all solid flag|
|![image][ref-e]:`laserGetTraceContents`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit [`surface contents enums`][ref-7-surface contents enums]|
|![image][ref-e]:`laserGetTraceDispFlags`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit [`surface displacement flag enums`][ref-6-surface displacement flag enums]|
|![image][ref-e]:`laserGetTraceEntity`(![image][ref-n])|![image][ref-e]|Returns the [`last trace`][ref-1-last trace] [`entity`][ref-2-entity]|
|![image][ref-e]:`laserGetTraceFraction`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] used hit fraction `[0-1]`|
|![image][ref-e]:`laserGetTraceFractionLS`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] fraction left solid `[0-1]`|
|![image][ref-e]:`laserGetTraceHit`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit flag|
|![image][ref-e]:`laserGetTraceHitBox`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit box `ID`|
|![image][ref-e]:`laserGetTraceHitGroup`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] [`hit group enums`][ref-3-hit group enums]|
|![image][ref-e]:`laserGetTraceHitNoDraw`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit no-draw brush|
|![image][ref-e]:`laserGetTraceHitNonWorld`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit non-world flag|
|![image][ref-e]:`laserGetTraceHitNormal`(![image][ref-n])|![image][ref-v]|Returns the [`last trace`][ref-1-last trace] hit normal [`vector`][ref-4-vector]|
|![image][ref-e]:`laserGetTraceHitPhysicsBone`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit physics bone `ID`|
|![image][ref-e]:`laserGetTraceHitPos`(![image][ref-n])|![image][ref-v]|Returns the [`last trace`][ref-1-last trace] hit position [`vector`][ref-4-vector]|
|![image][ref-e]:`laserGetTraceHitSky`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit sky flag|
|![image][ref-e]:`laserGetTraceHitTexture`(![image][ref-n])|![image][ref-s]|Returns the [`last trace`][ref-1-last trace] hit texture|
|![image][ref-e]:`laserGetTraceHitWorld`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit world flag|
|![image][ref-e]:`laserGetTraceMatType`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] [`material type enums`][ref-5-material type enums]|
|![image][ref-e]:`laserGetTraceNormal`(![image][ref-n])|![image][ref-v]|Returns the [`last trace`][ref-1-last trace] normal [`vector`][ref-4-vector]|
|![image][ref-e]:`laserGetTraceStartPos`(![image][ref-n])|![image][ref-v]|Returns the [`last trace`][ref-1-last trace] start position|
|![image][ref-e]:`laserGetTraceStartSolid`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] start solid flag|
|![image][ref-e]:`laserGetTraceSurfaceFlags`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit [`surface flags enums`][ref-8-surface flags enums]|
|![image][ref-e]:`laserGetTraceSurfacePropsID`(![image][ref-n])|![image][ref-n]|Returns the [`last trace`][ref-1-last trace] hit surface property `ID`|
|![image][ref-e]:`laserGetTraceSurfacePropsName`(![image][ref-n])|![image][ref-s]|Returns the [`last trace`][ref-1-last trace] hit surface property name|

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
[ref-1-last trace]: https://wiki.facepunch.com/gmod/Structures/TraceResult
[ref-2-entity]: https://wiki.facepunch.com/gmod/Entity
[ref-3-hit group enums]: https://wiki.facepunch.com/gmod/Enums/HITGROUP
[ref-4-vector]: https://wiki.facepunch.com/gmod/Vector
[ref-5-material type enums]: https://wiki.facepunch.com/gmod/Enums/MAT
[ref-6-surface displacement flag enums]: https://wiki.facepunch.com/gmod/Enums/DISPSURF
[ref-7-surface contents enums]: https://wiki.facepunch.com/gmod/Enums/CONTENTS
[ref-8-surface flags enums]: https://wiki.facepunch.com/gmod/Enums/SURF
