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
|![image][ref-e]:`laserGetDissolveType`()|![image][ref-s]|Returns the laser source dissolve type name|
|![image][ref-e]:`laserGetDissolveTypeID`()|![image][ref-n]|Returns the laser source dissolve type `ID`|
|![image][ref-e]:`laserGetEndingEffect`()|![image][ref-n]|Returns the laser source ending effect flag|
|![image][ref-e]:`laserGetForceCenter`()|![image][ref-n]|Returns the laser source force in center flag|
|![image][ref-e]:`laserGetKillSound`()|![image][ref-s]|Returns the laser source kill sound|
|![image][ref-e]:`laserGetNonOverMater`()|![image][ref-n]|Returns the laser source base entity material flag|
|![image][ref-e]:`laserGetPlayer`()|![image][ref-e]|Returns the laser unit player getting the kill credit|
|![image][ref-e]:`laserGetReflectRatio`()|![image][ref-n]|Returns the laser source reflection ratio flag|
|![image][ref-e]:`laserGetRefractRatio`()|![image][ref-n]|Returns the laser source refraction ratio flag|
|![image][ref-e]:`laserGetStartSound`()|![image][ref-s]|Returns the laser source start sound|
|![image][ref-e]:`laserGetStopSound`()|![image][ref-s]|Returns the laser source stop sound|

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
