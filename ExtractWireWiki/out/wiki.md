|              Entity extensions               | Out | Description |
|----------------------------------------------|-----|-------------|
|![image][ref-e]:allPiston(![image][ref-xxx])|![image][ref-n]|Returns the count of all piston keys|
|![image][ref-e]:clrPiston(![image][ref-xxx])|![image][ref-e]|Clears the pistons from the `E2` chip|
|![image][ref-e]:cntPiston(![image][ref-xxx])|![image][ref-n]|Returns the count of integer piston keys|
|![image][ref-e]:getMark(![image][ref-xxx])|![image][ref-v]|Returns the crankshaft mark vector local to the base entity with general mark and base|
|![image][ref-e]:getMark(![image][ref-e])|![image][ref-v]|Returns the crankshaft mark vector local to the base entity with general base|
|![image][ref-e]:getMark(![image][ref-v])|![image][ref-v]|Returns the crankshaft mark vector local to the base entity with general mark|
|![image][ref-e]:getMark(![image][ref-v],![image][ref-e])|![image][ref-v]|Returns the crankshaft mark vector local to the base entity with no arguments|
|![image][ref-e]:getPiston(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns the piston bearing timing by an integer key|
|![image][ref-e]:getPiston(![image][ref-n],![image][ref-v])|![image][ref-n]|Returns the piston vector timing by an integer key|
|![image][ref-e]:getPiston(![image][ref-s],![image][ref-n])|![image][ref-n]|Returns the piston bearing timing by a string key|
|![image][ref-e]:getPiston(![image][ref-s],![image][ref-v])|![image][ref-n]|Returns the piston vector timing by a string key|
|![image][ref-e]:getPistonAxis(![image][ref-xxx])|![image][ref-v]|Returns the base prop axis local vector using x as number|
|![image][ref-e]:getPistonAxis(![image][ref-n])|![image][ref-v]|Returns the shaft rotation axis by an integer key|
|![image][ref-e]:getPistonAxis(![image][ref-s])|![image][ref-v]|Returns the shaft rotation axis by a string key|
|![image][ref-e]:getPistonBase(![image][ref-xxx])|![image][ref-e]|Returns the base prop entity using no arguments|
|![image][ref-e]:getPistonMark(![image][ref-xxx])|![image][ref-v]|Returns the base prop general rotation mark local vector using no arguments|
|![image][ref-e]:getPistonMax(![image][ref-n])|![image][ref-n]|Returns the piston number highest point parameter by an integer key|
|![image][ref-e]:getPistonMax(![image][ref-s])|![image][ref-n]|Returns the piston number highest point parameter by a string key|
|![image][ref-e]:getPistonMaxX(![image][ref-n])|![image][ref-v]|Returns the piston vector highest point parameter by an integer key|
|![image][ref-e]:getPistonMaxX(![image][ref-s])|![image][ref-v]|Returns the piston vector highest point parameter by a string key|
|![image][ref-e]:getPistonMin(![image][ref-n])|![image][ref-n]|Returns the piston number lowest point parameter by an integer key|
|![image][ref-e]:getPistonMin(![image][ref-s])|![image][ref-n]|Returns the piston number lowest point parameter by a string key|
|![image][ref-e]:getPistonMinX(![image][ref-n])|![image][ref-v]|Returns the piston vector lowest point parameter by an integer key|
|![image][ref-e]:getPistonMinX(![image][ref-s])|![image][ref-v]|Returns the piston vector lowest point parameter by a string key|
|![image][ref-e]:isPistonRamp(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`triangular`](https://en.wikipedia.org/wiki/Triangle_wave) mode by an integer key|
|![image][ref-e]:isPistonRamp(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`triangular`](https://en.wikipedia.org/wiki/Triangle_wave) mode by a string key|
|![image][ref-e]:isPistonSign(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`sign`](https://en.wikipedia.org/wiki/Sign_function) mode by an integer key|
|![image][ref-e]:isPistonSign(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`sign`](https://en.wikipedia.org/wiki/Sign_function) mode by a string key|
|![image][ref-e]:isPistonSignX(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in cross-product [`sign`](https://en.wikipedia.org/wiki/Sign_function) mode by an integer key|
|![image][ref-e]:isPistonSignX(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in cross-product [`sign`](https://en.wikipedia.org/wiki/Sign_function) mode by a string key|
|![image][ref-e]:isPistonWave(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`wave`](https://en.wikipedia.org/wiki/Sine) mode by an integer key|
|![image][ref-e]:isPistonWave(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`wave`](https://en.wikipedia.org/wiki/Sine) mode by a string key|
|![image][ref-e]:isPistonWaveX(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) wave mode by an integer key|
|![image][ref-e]:isPistonWaveX(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) wave mode by a string key|
|![image][ref-e]:remPiston(![image][ref-n])|![image][ref-e]|Removes the piston by an integer key|
|![image][ref-e]:remPiston(![image][ref-s])|![image][ref-e]|Removes the piston by a string key|
|![image][ref-e]:resPistonAxis(![image][ref-xxx])|![image][ref-e]|Clears the base prop axis local vector using no arguments|
|![image][ref-e]:resPistonBase(![image][ref-xxx])|![image][ref-e]|Clears the base prop entity using no arguments|
|![image][ref-e]:resPistonMark(![image][ref-xxx])|![image][ref-e]|Clears the base prop general rotation mark local vector using no arguments|
|![image][ref-e]:setPistonAxis(![image][ref-n])|![image][ref-e]|Stores the base prop axis local vector using x as number|
|![image][ref-e]:setPistonAxis(![image][ref-n],![image][ref-n])|![image][ref-e]|Stores the base prop axis local vector using x and y as numbers|
|![image][ref-e]:setPistonAxis(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-e]|Stores the base prop axis local vector using x, y and z numbers|
|![image][ref-e]:setPistonAxis(![image][ref-r])|![image][ref-e]|Stores the base prop axis local vector using an array|
|![image][ref-e]:setPistonAxis(![image][ref-v])|![image][ref-e]|Stores the base prop axis local vector using a vector|
|![image][ref-e]:setPistonAxis(![image][ref-xv2])|![image][ref-e]|Stores the base prop axis local vector using a `2D` vector|
|![image][ref-e]:setPistonBase(![image][ref-e])|![image][ref-e]|Stores the base prop entity using an entity|
|![image][ref-e]:setPistonMark(![image][ref-n])|![image][ref-e]|Stores the base prop general rotation mark local vector using x as number|
|![image][ref-e]:setPistonMark(![image][ref-n],![image][ref-n])|![image][ref-e]|Stores the base prop general rotation mark local vector using x and y as numbers|
|![image][ref-e]:setPistonMark(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-e]|Stores the base prop general rotation mark local vector using x, y and z numbers|
|![image][ref-e]:setPistonMark(![image][ref-r])|![image][ref-e]|Stores the base prop general rotation mark local vector using array|
|![image][ref-e]:setPistonMark(![image][ref-v])|![image][ref-e]|Stores the base prop general rotation mark local vector using vector|
|![image][ref-e]:setPistonMark(![image][ref-xv2])|![image][ref-e]|Stores the base prop general rotation mark local vector using `2D` vector|
|![image][ref-e]:setPistonRamp(![image][ref-n],![image][ref-n])|![image][ref-e]|Creates a [`triangular`](https://en.wikipedia.org/wiki/Triangle_wave) timed piston by an integer key and highest point angle in degrees|
|![image][ref-e]:setPistonRamp(![image][ref-s],![image][ref-n])|![image][ref-e]|Creates a [`triangular`](https://en.wikipedia.org/wiki/Triangle_wave) timed piston by a string key and highest point angle in degrees|
|![image][ref-e]:setPistonSign(![image][ref-n],![image][ref-n])|![image][ref-e]|Creates a [`sign`](https://en.wikipedia.org/wiki/Sign_function) timed piston by an integer key and highest point angle in degrees|
|![image][ref-e]:setPistonSign(![image][ref-s],![image][ref-n])|![image][ref-e]|Creates a [`sign`](https://en.wikipedia.org/wiki/Sign_function) timed piston by a string key and highest point angle in degrees|
|![image][ref-e]:setPistonSignX(![image][ref-n],![image][ref-v])|![image][ref-e]|Creates a cross-product timed piston with [`sign`](https://en.wikipedia.org/wiki/Sign_function) output by an integer key and highest point local vector|
|![image][ref-e]:setPistonSignX(![image][ref-n],![image][ref-v],![image][ref-v])|![image][ref-e]|Creates a cross-product timed piston with [`sign`](https://en.wikipedia.org/wiki/Sign_function) output by an integer key and highest point local vector|
|![image][ref-e]:setPistonSignX(![image][ref-s],![image][ref-v])|![image][ref-e]|Creates a cross-product timed piston with [`sign`](https://en.wikipedia.org/wiki/Sign_function) output by a string key and highest point local vector|
|![image][ref-e]:setPistonSignX(![image][ref-s],![image][ref-v],![image][ref-v])|![image][ref-e]|Creates a cross-product timed piston with [`sign`](https://en.wikipedia.org/wiki/Sign_function) output by a string key and highest point local vector|
|![image][ref-e]:setPistonWave(![image][ref-n],![image][ref-n])|![image][ref-e]|Creates a [`wave`](https://en.wikipedia.org/wiki/Sine) timed piston by an integer key and highest point angle in degrees|
|![image][ref-e]:setPistonWave(![image][ref-s],![image][ref-n])|![image][ref-e]|Creates a [`wave`](https://en.wikipedia.org/wiki/Sine) timed piston by a string key and highest point angle in degrees|
|![image][ref-e]:setPistonWaveX(![image][ref-n],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with wave output by an integer key and highest point local vector|
|![image][ref-e]:setPistonWaveX(![image][ref-n],![image][ref-v],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with wave output by an integer key and highest point local vector|
|![image][ref-e]:setPistonWaveX(![image][ref-s],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with wave output by a string key and highest point local vector|
|![image][ref-e]:setPistonWaveX(![image][ref-s],![image][ref-v],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with wave output by a string key and highest point local vector|

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

