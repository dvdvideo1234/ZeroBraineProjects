|ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑInstanceˑcreatorˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ|ˑOutˑ|ˑDescriptionˑ|
|--------------------------------------------------------------------------------|-----|-------------|

|ˑˑˑˑEntityˑwiremodˑextensionsˑˑˑˑ|ˑOutˑ|ˑDescriptionˑ|
|-----------------------------------|-----|-------------|
|![image][ref-e]:allPiston(![image][ref-xxx])|![image][ref-n]|Returns the count of all piston keys|
|![image][ref-e]:clrPiston(![image][ref-xxx])|![image][ref-e]|Clears all pistons from the `E2` chip|
|![image][ref-e]:cntPiston(![image][ref-xxx])|![image][ref-n]|Returns the count of integer piston keys|
|![image][ref-e]:getMaxPiston(![image][ref-n])|![image][ref-n]|Returns the piston highest point parameter by an integer key|
|![image][ref-e]:getMaxPiston(![image][ref-n])|![image][ref-v]|Returns the piston highest point parameter by an integer key|
|![image][ref-e]:getMaxPiston(![image][ref-s])|![image][ref-n]|Returns the piston highest point parameter by a string key|
|![image][ref-e]:getMaxPiston(![image][ref-s])|![image][ref-v]|Returns the piston highest point parameter by a string key|
|![image][ref-e]:getMinPiston(![image][ref-n])|![image][ref-n]|Returns the piston lowest point parameter by an integer key|
|![image][ref-e]:getMinPiston(![image][ref-n])|![image][ref-v]|Returns the piston lowest point parameter by an integer key|
|![image][ref-e]:getMinPiston(![image][ref-s])|![image][ref-n]|Returns the piston lowest point parameter by a string key|
|![image][ref-e]:getMinPiston(![image][ref-s])|![image][ref-v]|Returns the piston lowest point parameter by a string key|
|![image][ref-e]:getPiston(![image][ref-n],![image][ref-n])|![image][ref-n]|Returns piston bearing timing by an integer key|
|![image][ref-e]:getPiston(![image][ref-n],![image][ref-v])|![image][ref-n]|Returns piston vector timing by an integer key|
|![image][ref-e]:getPiston(![image][ref-s],![image][ref-n])|![image][ref-n]|Returns piston bearing timing by a string key|
|![image][ref-e]:getPiston(![image][ref-s],![image][ref-v])|![image][ref-n]|Returns piston vector timing by a string key|
|![image][ref-e]:getPistonAxis(![image][ref-n])|![image][ref-v]|Returns shaft rotation axis by an integer key|
|![image][ref-e]:getPistonAxis(![image][ref-s])|![image][ref-v]|Returns shaft rotation axis by a string key|
|![image][ref-e]:getPistonBase(![image][ref-n])|![image][ref-e]|Returns the engine base entity by an integer key|
|![image][ref-e]:getPistonBase(![image][ref-s])|![image][ref-e]|Returns the engine base entity by a string key|
|![image][ref-e]:isPistonRamp(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`triangular`](https://en.wikipedia.org/wiki/Triangle_wave) mode by an integer key|
|![image][ref-e]:isPistonRamp(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`triangular`](https://en.wikipedia.org/wiki/Triangle_wave) mode by a string key|
|![image][ref-e]:isPistonSign(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`sign`](https://en.wikipedia.org/wiki/Sign_function) mode by an integer key|
|![image][ref-e]:isPistonSign(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`sign`](https://en.wikipedia.org/wiki/Sign_function) mode by a string key|
|![image][ref-e]:isPistonSignX(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) [`sign`](https://en.wikipedia.org/wiki/Sign_function) mode by an integer key|
|![image][ref-e]:isPistonSignX(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) [`sign`](https://en.wikipedia.org/wiki/Sign_function) mode by a string key|
|![image][ref-e]:isPistonWave(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`wave`](https://en.wikipedia.org/wiki/Sine) mode by an integer key|
|![image][ref-e]:isPistonWave(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`wave`](https://en.wikipedia.org/wiki/Sine) mode by a string key|
|![image][ref-e]:isPistonWaveX(![image][ref-n])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) [`wave`](https://en.wikipedia.org/wiki/Sine) mode by an integer key|
|![image][ref-e]:isPistonWaveX(![image][ref-s])|![image][ref-n]|Returns a flag if the piston is in [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) [`wave`](https://en.wikipedia.org/wiki/Sine) mode by a string key|
|![image][ref-e]:putPistonAxis(![image][ref-xxx])|![image][ref-e]|Clears the base prop [`local-axis`](https://en.wikipedia.org/wiki/Cartesian_coordinate_system) to use with the piston [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) functions|
|![image][ref-e]:putPistonAxis(![image][ref-n])|![image][ref-e]|Stores the base prop [`local-axis`](https://en.wikipedia.org/wiki/Cartesian_coordinate_system) to use with the piston [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) functions|
|![image][ref-e]:putPistonAxis(![image][ref-n],![image][ref-n])|![image][ref-e]|Stores the base prop [`local-axis`](https://en.wikipedia.org/wiki/Cartesian_coordinate_system) to use with the piston [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) functions|
|![image][ref-e]:putPistonAxis(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-e]|Stores the base prop [`local-axis`](https://en.wikipedia.org/wiki/Cartesian_coordinate_system) to use with the piston [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) functions|
|![image][ref-e]:putPistonAxis(![image][ref-r])|![image][ref-e]|Stores the base prop [`local-axis`](https://en.wikipedia.org/wiki/Cartesian_coordinate_system) to use with the piston [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) functions|
|![image][ref-e]:putPistonAxis(![image][ref-v])|![image][ref-e]|Stores the base prop [`local-axis`](https://en.wikipedia.org/wiki/Cartesian_coordinate_system) to use with the piston [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) functions|
|![image][ref-e]:putPistonAxis(![image][ref-xv2])|![image][ref-e]|Stores the base prop [`local-axis`](https://en.wikipedia.org/wiki/Cartesian_coordinate_system) to use with the piston [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) functions|
|![image][ref-e]:putPistonBase(![image][ref-xxx])|![image][ref-e]|Clears the base prop to use with the piston [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) functions|
|![image][ref-e]:putPistonBase(![image][ref-e])|![image][ref-e]|Stores the base prop to use with the piston [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) functions|
|![image][ref-e]:remPiston(![image][ref-n])|![image][ref-e]|Removes the piston by an integer key|
|![image][ref-e]:remPiston(![image][ref-s])|![image][ref-e]|Removes the piston by a string key|
|![image][ref-e]:setPistonRamp(![image][ref-n],![image][ref-n])|![image][ref-e]|Creates a [`triangular`](https://en.wikipedia.org/wiki/Triangle_wave) timed piston by an integer key and highest point angle in degrees|
|![image][ref-e]:setPistonRamp(![image][ref-s],![image][ref-n])|![image][ref-e]|Creates a [`triangular`](https://en.wikipedia.org/wiki/Triangle_wave) timed piston by a string key and highest point angle in degrees|
|![image][ref-e]:setPistonSign(![image][ref-n],![image][ref-n])|![image][ref-e]|Creates a [`sign`](https://en.wikipedia.org/wiki/Sign_function) timed piston by an integer key and highest point angle in degrees|
|![image][ref-e]:setPistonSign(![image][ref-s],![image][ref-n])|![image][ref-e]|Creates a [`sign`](https://en.wikipedia.org/wiki/Sign_function) timed piston by a string key and highest point angle in degrees|
|![image][ref-e]:setPistonSignX(![image][ref-n],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with [`sign`](https://en.wikipedia.org/wiki/Sign_function) output by an integer key and highest point local vector|
|![image][ref-e]:setPistonSignX(![image][ref-n],![image][ref-v],![image][ref-v],![image][ref-e])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with [`sign`](https://en.wikipedia.org/wiki/Sign_function) output by an integer key and highest point local vector|
|![image][ref-e]:setPistonSignX(![image][ref-s],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with [`sign`](https://en.wikipedia.org/wiki/Sign_function) output by a string key and highest point local vector|
|![image][ref-e]:setPistonSignX(![image][ref-s],![image][ref-v],![image][ref-v],![image][ref-e])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with [`sign`](https://en.wikipedia.org/wiki/Sign_function) output by a string key and highest point local vector|
|![image][ref-e]:setPistonWave(![image][ref-n],![image][ref-n])|![image][ref-e]|Creates a [`wave`](https://en.wikipedia.org/wiki/Sine) timed piston by an integer key and highest point angle in degrees|
|![image][ref-e]:setPistonWave(![image][ref-s],![image][ref-n])|![image][ref-e]|Creates a [`wave`](https://en.wikipedia.org/wiki/Sine) timed piston by a string key and highest point angle in degrees|
|![image][ref-e]:setPistonWaveX(![image][ref-n],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with [`wave`](https://en.wikipedia.org/wiki/Sine) output by an integer key and highest point local vector|
|![image][ref-e]:setPistonWaveX(![image][ref-n],![image][ref-v],![image][ref-v],![image][ref-e])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with [`wave`](https://en.wikipedia.org/wiki/Sine) output by an integer key and highest point local vector|
|![image][ref-e]:setPistonWaveX(![image][ref-s],![image][ref-v])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with [`wave`](https://en.wikipedia.org/wiki/Sine) output by a string key and highest point local vector|
|![image][ref-e]:setPistonWaveX(![image][ref-s],![image][ref-v],![image][ref-v],![image][ref-e])|![image][ref-e]|Creates a [`cross-product`](https://en.wikipedia.org/wiki/Cross_product) timed piston with [`wave`](https://en.wikipedia.org/wiki/Sine) output by a string key and highest point local vector|

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

