### Description
The [`Track assembly tool`][ref-ta-tool] [`Expression 2`][ref-exp2] API is used for a wrapper of the library functions, which handle the track piece
snapping, so you can call them inside an [`E2`][ref-exp2] and thus create your own automatically generated layouts. This also can be
used when you need to implement track switchers, where you just `snap` desired track piece to the track end you wish to use.
You can then apply your desired properties, like `disable physgun` [`no-collide`][ref-no-collide] and [`weld`][ref-weld] to make
sure the piece is not going anywhere and it is not generating server collisions.
 
### Data types
This list is derived from the Wiremod types wiki [located here][ref-e2-data].
Here are all the icons for the data types of this addon summarized in the table below:

### API functions list
For every table, there is a wrapper function that reads the desired data you want:

|                            Class methods                             | Out | Description |
|----------------------------------------------------------------------|-----|-------------|
|![image][ref-e]:trackasmlibApplyPhysicalAnchor(![image][ref-e],![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-e]|Anchors the track entity to a base entity with weld `0/1` and no-collide `0/1` no-collide-world `0/1` and force limit.|
|![image][ref-e]:trackasmlibApplyPhysicalSettings(![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-s])|![image][ref-e]|Modifies track entity physical settings with phys-gun enabled, freeze, gravity toggle and surface material behavior|
|![image][ref-e]:trackasmlibAttachAdditions(![image][ref-xxx])|![image][ref-n]|Attaches the track entity additions when available|
|![image][ref-e]:trackasmlibAttachBodyGroups(![image][ref-s])|![image][ref-n]|Attaches track piece body-groups by providing selection code|
|![image][ref-e]:trackasmlibGenActivePointDSV(![image][ref-e],![image][ref-s],![image][ref-s],![image][ref-n],![image][ref-s])|![image][ref-s]|Exports the track entity as external database record|
|![image][ref-e]:trackasmlibGenActivePointINS(![image][ref-e],![image][ref-s],![image][ref-s],![image][ref-n],![image][ref-s])|![image][ref-s]|Exports the track entity as internal database record|
|![image][ref-e]:trackasmlibGetAdditionsCount(![image][ref-xxx])|![image][ref-n]|Returns record additions count by entity|
|![image][ref-e]:trackasmlibGetAdditionsLine(![image][ref-n])|![image][ref-r]|Returns record additions line by entity|
|![image][ref-e]:trackasmlibGetBodyGroups(![image][ref-xxx])|![image][ref-s]|Returns the track bodygoup selection list|
|![image][ref-e]:trackasmlibGetName(![image][ref-xxx])|![image][ref-s]|Returns record name by entity|
|![image][ref-e]:trackasmlibGetOffset(![image][ref-n],![image][ref-s])|![image][ref-r]|Returns record snap offsets by entity|
|![image][ref-e]:trackasmlibGetPointsCount(![image][ref-xxx])|![image][ref-n]|Returns record points count by entity|
|![image][ref-e]:trackasmlibGetSkin(![image][ref-xxx])|![image][ref-s]|Returns the track skin selection list|
|![image][ref-e]:trackasmlibGetType(![image][ref-xxx])|![image][ref-s]|Returns record track type by entity|
|![image][ref-e]:trackasmlibHasAdditions(![image][ref-xxx])|![image][ref-n]|Returns `1` when the record has additions and `0` otherwise by entity|
|![image][ref-e]:trackasmlibIsPiece(![image][ref-xxx])|![image][ref-n]|Returns `1` when the record is actual track and `0` otherwise by entity|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a])|![image][ref-e]|Duplicates the given track using the new position and angle|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a],![image][ref-n])|![image][ref-e]|Creates new track piece with position angle, mass by entity|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s])|![image][ref-e]|Creates new track piece with position angle, mass and skin code by entity|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s],![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-e]|Creates new track piece with position angle, mass, skin code, color and alpha as numbers by entity|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s],![image][ref-v])|![image][ref-e]|Creates new track piece with position angle, mass, skin code and color as vector alpha is `255` by entity|
|![image][ref-e]:trackasmlibSnapEntity(![image][ref-v],![image][ref-s],![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-v],![image][ref-a])|![image][ref-r]|Returns track entity snap position and angle array by holder model, point `ID`, active radius, flatten, ignore type, position offset and angle offset|

|                          General functions                           | Out | Description |
|----------------------------------------------------------------------|-----|-------------|
|trackasmlibGetAdditionsCount(![image][ref-s])|![image][ref-n]|Returns record additions count by model|
|trackasmlibGetAdditionsLine(![image][ref-s],![image][ref-n])|![image][ref-r]|Returns record additions line by model|
|trackasmlibGetName(![image][ref-s])|![image][ref-s]|Returns record name by model|
|trackasmlibGetOffset(![image][ref-s],![image][ref-n],![image][ref-s])|![image][ref-r]|Returns record snap offsets by model|
|trackasmlibGetPointsCount(![image][ref-s])|![image][ref-n]|Returns record points count by model|
|trackasmlibGetProperty(![image][ref-xxx])|![image][ref-r]|Returns the surface property types|
|trackasmlibGetProperty(![image][ref-s])|![image][ref-r]|Returns the surface properties available for a given type|
|trackasmlibGetType(![image][ref-s])|![image][ref-s]|Returns record track type by model|
|trackasmlibHasAdditions(![image][ref-s])|![image][ref-n]|Returns `1` when the record has additions and `0` otherwise by model|
|trackasmlibIsPiece(![image][ref-s])|![image][ref-n]|Returns `1` when the record is actual track and `0` otherwise by model|
|trackasmlibMakePiece(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n])|![image][ref-e]|Creates new track piece with position angle, mass by model|
|trackasmlibMakePiece(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s])|![image][ref-e]|Creates new track piece with position angle, mass and skin code by model|
|trackasmlibMakePiece(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s],![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-e]|Creates new track piece with position angle, mass, skin code and color and aplha as numbers by model|
|trackasmlibMakePiece(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s],![image][ref-v])|![image][ref-e]|Creates new track piece with position angle, mass, skin code and color as vector alpha is `255` by model|
|trackasmlibSnapNormal(![image][ref-v],![image][ref-a],![image][ref-s],![image][ref-n],![image][ref-v],![image][ref-a])|![image][ref-r]|Returns track surface snap position and angle array by position, angle, model, point `ID`, position offset and angle offset|

|Icon|Description|
|---|---|
|![image][ref-a]|[`Angle`](https://en.wikipedia.org/wiki/Euler_angles) class|
|![image][ref-b]|[`Bone`](https://github.com/wiremod/wire/wiki/Expression-2#Bone) class|
|![image][ref-c]|[`Complex`](https://en.wikipedia.org/wiki/Complex_number) number|
|![image][ref-e]|[`Entity`](https://en.wikipedia.org/wiki/Entity) class|
|![image][ref-xm2]|[`Matrix`](https://en.wikipedia.org/wiki/Matrix_(mathematics)) 2x2|
|![image][ref-m]|[`Matrix`](https://en.wikipedia.org/wiki/Matrix_(mathematics)) 3x3|
|![image][ref-xm4]|[`Matrix`](https://en.wikipedia.org/wiki/Matrix_(mathematics)) 4x4|
|![image][ref-n]|[`Number`](https://en.wikipedia.org/wiki/Number)|
|![image][ref-q]|[`Quaternion`](https://en.wikipedia.org/wiki/Quaternion)|
|![image][ref-r]|[`Array`](https://en.wikipedia.org/wiki/Array_data_structure)|
|![image][ref-s]|[`String`](https://en.wikipedia.org/wiki/String_(computer_science)) class|
|![image][ref-t]|[`Table`](https://github.com/wiremod/wire/wiki/Expression-2#Table)|
|![image][ref-xv2]|[`Vector`](https://en.wikipedia.org/wiki/Euclidean_vector) 2D class|
|![image][ref-v]|[`Vector`](https://en.wikipedia.org/wiki/Euclidean_vector) 3D class|
|![image][ref-xv4]|[`Vactor`](https://en.wikipedia.org/wiki/4D_vector) 4D class|
|![image][ref-xrd]|[`Ranger data`](https://github.com/wiremod/wire/wiki/Expression-2#BuiltIn_Ranger) class|
|![image][ref-xwl]|[`Wire link`](https://github.com/wiremod/wire/wiki/Expression-2#Wirelink) class|
|![image][ref-xft]|[`Flash tracer`](https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FTracer) class|
|![image][ref-xsc]|[`State controller`](https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl) class|
|![image][ref-xxx]|[`Void`](https://en.wikipedia.org/wiki/Void_type) data type|

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

[ref-e2-data]: https://github.com/wiremod/wire/wiki/Expression-2#Datatypes
[ref-ta-tool]: https://github.com/dvdvideo1234/TrackAssemblyTool
[ref-gmod]: https://en.wikipedia.org/wiki/Garry%27s_Mod
[ref-exp2]: https://github.com/wiremod/wire/wiki/Expression-2
[ref-convar]: https://developer.valvesoftware.com/wiki/ConVar
[ref-weld]: https://gmod.fandom.com/wiki/Weld_Tool
[ref-no-collide]: https://gmod.fandom.com/wiki/No_Collide
