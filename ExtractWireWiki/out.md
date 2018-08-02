|................................Instance.creator................................|.Out.|.Description.|
|--------------------------------------------------------------------------------|-----|-------------|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a])|![image][ref-e]|Duplicates the given track using the new position and angle|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a],![image][ref-n])|![image][ref-e]|Creates new track piece with position angle, mass by entity|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s])|![image][ref-e]|Creates new track piece with position angle, mass and skin code by entity|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s],![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-e]|Creates new track piece with position angle, mass, skin code and color by entity|
|![image][ref-e]:trackasmlibMakePiece(![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s],![image][ref-v])|![image][ref-e]|Creates new track piece with position angle, mass, skin code and color as numbers by entity|
|trackasmlibMakePiece(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n])|![image][ref-e]|Creates new track piece with position angle, mass by model|
|trackasmlibMakePiece(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s])|![image][ref-e]|Creates new track piece with position angle, mass and skin code by model|
|trackasmlibMakePiece(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s],![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-e]|Creates new track piece with position angle, mass, skin code and color by model|
|trackasmlibMakePiece(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-s],![image][ref-v])|![image][ref-e]|Creates new track piece with position angle, mass, skin code and color as numbers by model|

|..................................Class.methods.................................|.Out.|.Description.|
|--------------------------------------------------------------------------------|-----|-------------|
|![image][ref-e]:trackasmlibApplyPhysicalAnchor(![image][ref-e],![image][ref-n],![image][ref-n])|![image][ref-e]|Anchors the track entity to a base entity with with additional weld `0/1` and no-collide `0/1` flag options available.|
|![image][ref-e]:trackasmlibApplyPhysicalSettings(![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-s])|![image][ref-e]|Modifies track entity physical settings with phys-gun enabled, freeze, gravity toggle and surface material behavior|
|![image][ref-e]:trackasmlibAttachAdditions(![image][ref-xxx])|![image][ref-n]|Attaches the track entity additions when available|
|![image][ref-e]:trackasmlibAttachBodyGroups(![image][ref-s])|![image][ref-n]|Attaches track piece body-groups by providing selection code|
|![image][ref-e]:trackasmlibGenActivePointDSV(![image][ref-e],![image][ref-s],![image][ref-s],![image][ref-n],![image][ref-s],![image][ref-s])|![image][ref-s]|Exports the track entity as external database record|
|![image][ref-e]:trackasmlibGenActivePointINS(![image][ref-e],![image][ref-s],![image][ref-s],![image][ref-n],![image][ref-s])|![image][ref-s]|Exports the track entity as internal database record|
|![image][ref-e]:trackasmlibGetAdditionsCount(![image][ref-xxx])|![image][ref-n]|Returns record additions count by entity|
|trackasmlibGetAdditionsCount(![image][ref-s])|![image][ref-n]|Returns record additions count by model|
|![image][ref-e]:trackasmlibGetAdditionsLine(![image][ref-n])|![image][ref-r]|Returns record additions line by entity|
|trackasmlibGetAdditionsLine(![image][ref-s],![image][ref-n])|![image][ref-r]|Returns record additions lune by model|
|![image][ref-e]:trackasmlibGetName(![image][ref-xxx])|![image][ref-s]|Returns record name by entity|
|trackasmlibGetName(![image][ref-s])|![image][ref-s]|Returns record name by model|
|![image][ref-e]:trackasmlibGetOffset(![image][ref-n],![image][ref-s])|![image][ref-r]|Returns record snap offsets by entity|
|trackasmlibGetOffset(![image][ref-s],![image][ref-n],![image][ref-s])|![image][ref-r]|Returns record snap offsets by model|
|![image][ref-e]:trackasmlibGetPointsCount(![image][ref-xxx])|![image][ref-n]|Returns record points count by entity|
|trackasmlibGetPointsCount(![image][ref-s])|![image][ref-n]|Returns record points count by model|
|trackasmlibGetProperty(![image][ref-xxx])|![image][ref-r]|Returns the surface property types|
|trackasmlibGetProperty(![image][ref-s])|![image][ref-r]|Returns the surface properties available for a given type|
|![image][ref-e]:trackasmlibGetType(![image][ref-xxx])|![image][ref-s]|Returns record track type by entity|
|trackasmlibGetType(![image][ref-s])|![image][ref-s]|Returns record track type by model|
|![image][ref-e]:trackasmlibHasAdditions(![image][ref-xxx])|![image][ref-n]|Returns `1` when the record has additions and `0` otherwise by entity|
|trackasmlibHasAdditions(![image][ref-s])|![image][ref-n]|Returns `1` when the record has additions and `0` otherwise by model|
|![image][ref-e]:trackasmlibIsPiece(![image][ref-xxx])|![image][ref-n]|Returns `1` when the record is actual track and `0` otherwise by entity|
|trackasmlibIsPiece(![image][ref-s])|![image][ref-n]|Returns `1` when the record is actual track and `0` otherwise by model|
|![image][ref-e]:trackasmlibSnapEntity(![image][ref-v],![image][ref-s],![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-n],![image][ref-v],![image][ref-v])|![image][ref-r]|Returns track entity snap position and angle array by holder model, point `ID,` active radius, flatten, ignore type, position offset and angle offset|
|trackasmlibSnapNormal(![image][ref-v],![image][ref-a],![image][ref-s],![image][ref-n],![image][ref-v],![image][ref-v])|![image][ref-r]|Returns track surface snap position and angle array by position, angle, model, point `ID,` position offset and angle offset|

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
[ref-xfs]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xfs.png
[ref-xsc]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xsc.png
[ref-xxx]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xxx.png

