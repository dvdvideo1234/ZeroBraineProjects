E2Helper.Descriptions["joystickAxisCount(e:enum)"] = ""
E2Helper.Descriptions["joystickAxisData(e:)"] = ""
E2Helper.Descriptions["joystickButtonCount(e:enum)"] = ""
E2Helper.Descriptions["joystickButtonData(e:)"] = ""
E2Helper.Descriptions["joystickCount(e:)"] = ""
E2Helper.Descriptions["joystickName(e:enum)"] = ""
E2Helper.Descriptions["joystickPOVCount(e:enum)"] = ""
E2Helper.Descriptions["joystickPOVData(e:)"] = ""
E2Helper.Descriptions["joystickRefresh()"] = ""
E2Helper.Descriptions["joystickSetActive(e:enum on)"] = ""
E2Helper.Descriptions["joystickSetActive(enum on)"] = ""

------------------------------------------------------------------------------------------------------------------------

void joystickRefresh() = {}
void joystickRefresh()[1] = "xxx"
void joystickRefresh()[2] = ""
void joystickRefresh()[3] = "[Void] data type"
void joystickRefresh()[4] = "void"
void joystickRefresh()[5] = "https://en.wikipedia.org/wiki/Void_type"
void joystickSetActive(enum, on) = {}
void joystickSetActive(enum, on)[1] = "xxx"
void joystickSetActive(enum, on)[2] = ""
void joystickSetActive(enum, on)[3] = "[Void] data type"
void joystickSetActive(enum, on)[4] = "void"
void joystickSetActive(enum, on)[5] = "https://en.wikipedia.org/wiki/Void_type"
void entity:joystickSetActive(enum, on) = {}
void entity:joystickSetActive(enum, on)[1] = "xxx"
void entity:joystickSetActive(enum, on)[2] = ""
void entity:joystickSetActive(enum, on)[3] = "[Void] data type"
void entity:joystickSetActive(enum, on)[4] = "void"
void entity:joystickSetActive(enum, on)[5] = "https://en.wikipedia.org/wiki/Void_type"
number entity:joystickCount() = {}
number entity:joystickCount()[1] = "n"
number entity:joystickCount()[2] = "Number"
number entity:joystickCount()[3] = "[Number]"
number entity:joystickCount()[4] = "number"
number entity:joystickCount()[5] = "https://en.wikipedia.org/wiki/Number"
string entity:joystickName(enum) = {}
string entity:joystickName(enum)[1] = "s"
string entity:joystickName(enum)[2] = "String"
string entity:joystickName(enum)[3] = "[String] class"
string entity:joystickName(enum)[4] = "string"
string entity:joystickName(enum)[5] = "https://en.wikipedia.org/wiki/String_(computer_science)"
number entity:joystickAxisCount(enum) = {}
number entity:joystickAxisCount(enum)[1] = "n"
number entity:joystickAxisCount(enum)[2] = "Number"
number entity:joystickAxisCount(enum)[3] = "[Number]"
number entity:joystickAxisCount(enum)[4] = "number"
number entity:joystickAxisCount(enum)[5] = "https://en.wikipedia.org/wiki/Number"
number entity:joystickButtonCount(enum) = {}
number entity:joystickButtonCount(enum)[1] = "n"
number entity:joystickButtonCount(enum)[2] = "Number"
number entity:joystickButtonCount(enum)[3] = "[Number]"
number entity:joystickButtonCount(enum)[4] = "number"
number entity:joystickButtonCount(enum)[5] = "https://en.wikipedia.org/wiki/Number"
number entity:joystickPOVCount(enum) = {}
number entity:joystickPOVCount(enum)[1] = "n"
number entity:joystickPOVCount(enum)[2] = "Number"
number entity:joystickPOVCount(enum)[3] = "[Number]"
number entity:joystickPOVCount(enum)[4] = "number"
number entity:joystickPOVCount(enum)[5] = "https://en.wikipedia.org/wiki/Number"
array entity:joystickAxisData() = {}
array entity:joystickAxisData()[1] = "r"
array entity:joystickAxisData()[2] = "Array"
array entity:joystickAxisData()[3] = "[Array]"
array entity:joystickAxisData()[4] = "array"
array entity:joystickAxisData()[5] = "https://en.wikipedia.org/wiki/Array_data_structure"
array entity:joystickButtonData() = {}
array entity:joystickButtonData()[1] = "r"
array entity:joystickButtonData()[2] = "Array"
array entity:joystickButtonData()[3] = "[Array]"
array entity:joystickButtonData()[4] = "array"
array entity:joystickButtonData()[5] = "https://en.wikipedia.org/wiki/Array_data_structure"
array entity:joystickPOVData() = {}
array entity:joystickPOVData()[1] = "r"
array entity:joystickPOVData()[2] = "Array"
array entity:joystickPOVData()[3] = "[Array]"
array entity:joystickPOVData()[4] = "array"
array entity:joystickPOVData()[5] = "https://en.wikipedia.org/wiki/Array_data_structure"
### What does this extension include?
Tracers with [hit][ref_trace] and [ray][ref_ray] configuration. The difference with [wire rangers][ref_wranger]
is that this is a [dedicated class][ref_class_oop] being initialized once and used as many
times as it is needed, not creating an [instance][ref_oopinst] on every [E2][ref_exp2] [tick][ref_timere2] and later
wipe that [instance][ref_oopinst] out. It can extract every aspect of the [trace result structure][ref_trace] returned and
it can be sampled [locally][ref_localcrd] ( [`origin`][ref_position] and [`direction`][ref_orient] relative to
[`entity`][ref_entity] or `pos`/`dir`/`ang` ) or globally ( [`entity`][ref_entity] is not available and `pos`/`dir`/`ang`
are treated world-space data ). Also, it has better [performance][ref_perfe2] than the [regular wire rangers][ref_wranger].


|    General functions    | Out | Description |
|:------------------------|:---:|:------------|
|![image][ref-e]:`joystickAxisCount`(![image][ref-e],![image][ref-n],![image][ref-u],![image][ref-m])|![image][ref-n]||
|![image][ref-e]:`joystickAxisData`(![image][ref-xxx])|![image][ref-r]||
|![image][ref-e]:`joystickButtonCount`(![image][ref-e],![image][ref-n],![image][ref-u],![image][ref-m])|![image][ref-n]||
|![image][ref-e]:`joystickButtonData`(![image][ref-xxx])|![image][ref-r]||
|![image][ref-e]:`joystickCount`(![image][ref-xxx])|![image][ref-n]||
|![image][ref-e]:`joystickName`(![image][ref-e],![image][ref-n],![image][ref-u],![image][ref-m])|![image][ref-s]||
|![image][ref-e]:`joystickPOVCount`(![image][ref-e],![image][ref-n],![image][ref-u],![image][ref-m])|![image][ref-n]||
|![image][ref-e]:`joystickPOVData`(![image][ref-xxx])|![image][ref-r]||
|`joystickRefresh`(![image][ref-xxx])|![image][ref-xxx]||
|![image][ref-e]:`joystickSetActive`(![image][ref-e],![image][ref-n],![image][ref-u],![image][ref-m],![image][ref- ],![image][ref-o],![image][ref-n])|![image][ref-xxx]||
|`joystickSetActive`(![image][ref-e],![image][ref-n],![image][ref-u],![image][ref-m],![image][ref- ],![image][ref-o],![image][ref-n])|![image][ref-xxx]||

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
[ref_example]: https://github.com/dvdvideo1234/ControlSystemsE2/blob/master/data/Expression2/e2_code_test_ftrace.txt
[ref_trace]: https://wiki.garrysmod.com/page/Structures/TraceResult
[ref_class_con]: https://en.wikipedia.org/wiki/Constructor_(object-oriented_programming)
[ref_entity]: https://wiki.garrysmod.com/page/Global/Entity
[ref_orient]: https://en.wikipedia.org/wiki/Orientation_(geometry)
[ref_vec_norm]: https://en.wikipedia.org/wiki/Euclidean_vector#Length
[ref_lua]: https://en.wikipedia.org/wiki/Lua_(programming_language)
[ref_exp2]: https://github.com/wiremod/wire/wiki/Expression-2
[ref_ray]: https://en.wikipedia.org/wiki/Line_(geometry)#Ray
[ref_wranger]: https://github.com/wiremod/wire/wiki/Expression-2#built-in-ranger
[ref_oopinst]: https://en.wikipedia.org/wiki/Instance_(computer_science)
[ref_perfe2]: https://github.com/wiremod/wire/wiki/Expression-2#performance
[ref_localcrd]: https://en.wikipedia.org/wiki/Local_coordinates
[ref_position]: https://en.wikipedia.org/wiki/Position_(geometry)
[ref_timere2]: https://github.com/wiremod/wire/wiki/Expression-2#timer
[ref_awaree2]: https://github.com/wiremod/wire/wiki/Expression-2#self-aware
