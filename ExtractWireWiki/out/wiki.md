E2Helper.Descriptions["joystickAxisCount(e:n)"] = "Returns the player enumerator axes count"
E2Helper.Descriptions["joystickAxisData(e:)"] = "Returns the player axes data array"
E2Helper.Descriptions["joystickButtonCount(e:n)"] = "Returns the player enumerator buttons count"
E2Helper.Descriptions["joystickButtonData(e:)"] = "Returns the player buttons data array"
E2Helper.Descriptions["joystickCount(e:)"] = "Returns the player enumenators count"
E2Helper.Descriptions["joystickName(e:n)"] = "Returns the player enumerator name"
E2Helper.Descriptions["joystickPOVCount(e:n)"] = "Returns the player enumerator POV count"
E2Helper.Descriptions["joystickPOVData(e:)"] = "Returns the player POV data array"
E2Helper.Descriptions["joystickRefresh()"] = "Refreshes the player internal joystick state"
E2Helper.Descriptions["joystickSetActive(e:nn)"] = "Toggles the player enumerator active stream state"
E2Helper.Descriptions["joystickSetActive(nn)"] = "Toggles the E2 chip entity enumerator active stream state"

------------------------------------------------------------------------------------------------------------------------

### What does this extension do?

The [wiremod][ref_wiremod] [Lua][ref_lua] extension [`joystick`][ref_joy] is designed to be used with [`Wire Expression2`][ref_exp2]
in mind and implements general functions for manipulating given [player][ref_entity] [class][ref_class_oop] joystick
state as well as retrieve control data and other information. Beware of the E2 [performance][ref_perfe2] though.

### What is the [wiremod][ref_wiremod] [`Joystick`][ref_joy] API then?

|           Class methods           | Out | Description |
|:----------------------------------|:---:|:------------|
|![image][ref-e]:`joystickAxisCount`(![image][ref-n])|![image][ref-n]|Returns the player enumerator axes count|
|![image][ref-e]:`joystickAxisData`()|![image][ref-r]|Returns the player axes data array|
|![image][ref-e]:`joystickButtonCount`(![image][ref-n])|![image][ref-n]|Returns the player enumerator buttons count|
|![image][ref-e]:`joystickButtonData`()|![image][ref-r]|Returns the player buttons data array|
|![image][ref-e]:`joystickCount`()|![image][ref-n]|Returns the player enumenators count|
|![image][ref-e]:`joystickName`(![image][ref-n])|![image][ref-s]|Returns the player enumerator name|
|![image][ref-e]:`joystickPOVCount`(![image][ref-n])|![image][ref-n]|Returns the player enumerator `POV` count|
|![image][ref-e]:`joystickPOVData`()|![image][ref-r]|Returns the player `POV` data array|
|![image][ref-e]:`joystickSetActive`(![image][ref-n],![image][ref-n])||Toggles the player enumerator active stream state|

|    General functions    | Out | Description |
|:------------------------|:---:|:------------|
|`joystickRefresh`()||Refreshes the player internal joystick state|
|`joystickSetActive`(![image][ref-n],![image][ref-n])||Toggles the `E2` chip entity enumerator active stream state|

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
[ref_joy]: https://en.wikipedia.org/wiki/Joystick
[ref_wiremod]: https://wiremod.com/
