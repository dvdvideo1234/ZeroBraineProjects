|................................Instance.creator................................|.Out.|.Description.|
|--------------------------------------------------------------------------------|-----|-------------|

|........Entity.wiremod.extensions........|.Out.|.Description.|
|-----------------------------------------|-----|-------------|
|![image][ref-e]:allPiston(![image][ref-xxx])|![image][ref-n]|Returns the count of all piston keys|
|![image][ref-e]:clrPiston(![image][ref-xxx])|![image][ref-e]|Clears all pistons from the `E2` chip|
|![image][ref-e]:cntPiston(![image][ref-xxx])|![image][ref-n]|Returns the count of integer piston keys|
|![image][ref-e]:getPiston(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns piston bearing timing by an integer key|
|![image][ref-e]:getPiston(![image][ref-n],![image][ref-v])|![image][ref-n]|Returns piston vector timing by an integer key|
|![image][ref-e]:getPiston(![image][ref-s],![image][ref-n])|![image][ref-n]|Returns piston bearing timing by a string key|
|![image][ref-e]:getPiston(![image][ref-s],![image][ref-v])|![image][ref-n]|Returns piston vector timing by a string key|
|![image][ref-e]:getPistonBase(![image][ref-s])|![image][ref-e]|Returns the base entity of the engine|
|![image][ref-e]:higPiston(![image][ref-n])|![image][ref-n]|Returns the piston highest point angle in degrees by an integer key|
|![image][ref-e]:higPiston(![image][ref-n])|![image][ref-v]|Returns the piston highest point angle in degrees by an integer key|
|![image][ref-e]:higPiston(![image][ref-s])|![image][ref-n]|Returns the piston highest point angle in degrees by a string key|
|![image][ref-e]:higPiston(![image][ref-s])|![image][ref-v]|Returns the piston highest point angle in degrees by a string key|
|![image][ref-e]:isPistonCrossSign(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`]https://en.wikipedia.org/wiki/Cross_product [`sign`]https://en.wikipedia.org/wiki/Sign_function mode by an integer key|
|![image][ref-e]:isPistonCrossSign(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`]https://en.wikipedia.org/wiki/Cross_product [`sign`]https://en.wikipedia.org/wiki/Sign_function mode by a string key|
|![image][ref-e]:isPistonCrossWave(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`]https://en.wikipedia.org/wiki/Cross_product [`wave`]https://en.wikipedia.org/wiki/Sine mode by an integer key|
|![image][ref-e]:isPistonCrossWave(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`]https://en.wikipedia.org/wiki/Cross_product [`wave`]https://en.wikipedia.org/wiki/Sine mode by a string key|
|![image][ref-e]:isPistonSign(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`sign`]https://en.wikipedia.org/wiki/Sign_function mode by an integer key|
|![image][ref-e]:isPistonSign(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`sign`]https://en.wikipedia.org/wiki/Sign_function mode by a string key|
|![image][ref-e]:isPistonWave(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`wave`]https://en.wikipedia.org/wiki/Sine mode by an integer key|
|![image][ref-e]:isPistonWave(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`wave`]https://en.wikipedia.org/wiki/Sine mode by a string key|
|![image][ref-e]:lowPiston(![image][ref-n])|![image][ref-n]|Returns the piston lowest point angle in degrees by an integer key|
|![image][ref-e]:lowPiston(![image][ref-n])|![image][ref-v]|Returns the piston lowest point angle in degrees by an integer key|
|![image][ref-e]:lowPiston(![image][ref-s])|![image][ref-n]|Returns the piston lowest point angle in degrees by a string key|
|![image][ref-e]:lowPiston(![image][ref-s])|![image][ref-v]|Returns the piston lowest point angle in degrees by a string key|
|![image][ref-e]:remPiston(![image][ref-n])|![image][ref-e]|Removes the piston by an integer key|
|![image][ref-e]:remPiston(![image][ref-s])|![image][ref-e]|Removes the piston by a string key|
|![image][ref-e]:setPistonCrossSign(![image][ref-n],![image][ref-v],![image][ref-e],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`]https://en.wikipedia.org/wiki/Cross_product timed piston with [`sign`]https://en.wikipedia.org/wiki/Sign_function output by an integer key and highest point local vector|
|![image][ref-e]:setPistonCrossSign(![image][ref-s],![image][ref-v],![image][ref-e],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`]https://en.wikipedia.org/wiki/Cross_product timed piston with [`sign`]https://en.wikipedia.org/wiki/Sign_function output by a string key and highest point local vector|
|![image][ref-e]:setPistonCrossWave(![image][ref-n],![image][ref-v],![image][ref-e],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`]https://en.wikipedia.org/wiki/Cross_product timed piston with [`wave`]https://en.wikipedia.org/wiki/Sine output by an integer key and highest point local vector|
|![image][ref-e]:setPistonCrossWave(![image][ref-s],![image][ref-v],![image][ref-e],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`]https://en.wikipedia.org/wiki/Cross_product timed piston with [`wave`]https://en.wikipedia.org/wiki/Sine output by a string key and highest point local vector|
|![image][ref-e]:setPistonSign(![image][ref-n],![image][ref-n])|![image][ref-e]|Creates a [`sign`]https://en.wikipedia.org/wiki/Sign_function timed piston by an integer key and highest point angle in degrees|
|![image][ref-e]:setPistonSign(![image][ref-s],![image][ref-n])|![image][ref-e]|Creates a [`sign`]https://en.wikipedia.org/wiki/Sign_function timed piston by a string key and highest point angle in degrees|
|![image][ref-e]:setPistonWave(![image][ref-n],![image][ref-n])|![image][ref-e]|Creates a [`wave`]https://en.wikipedia.org/wiki/Sine timed piston by an integer key and highest point angle in degrees|
|![image][ref-e]:setPistonWave(![image][ref-s],![image][ref-n])|![image][ref-e]|Creates a [`wave`]https://en.wikipedia.org/wiki/Sine timed piston by a string key and highest point angle in degrees|

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
|![image][ref-xv2]|[`Vactor`](https://en.wikipedia.org/wiki/Euclidean_vector) 2D class|
|![image][ref-v]|[`Vector`](https://en.wikipedia.org/wiki/Euclidean_vector) 3D class|
|![image][ref-xv4]|[`Vactor`](https://en.wikipedia.org/wiki/4D_vector) 4D class|
|![image][ref-xrd]|[`Ranger data`](https://github.com/wiremod/wire/wiki/Expression-2#BuiltIn_Ranger) class|
|![image][ref-xwl]|[`Wire link`](https://github.com/wiremod/wire/wiki/Expression-2#Wirelink) class|
|![image][ref-xfs]|[`Flash sensor`](https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FSensor) class|
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
[ref-xfs]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xfs.png
[ref-xsc]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xsc.png
[ref-xxx]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xxx.png

