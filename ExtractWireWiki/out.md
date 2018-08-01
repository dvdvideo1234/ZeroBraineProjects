|.........Instance.creator.........|.Out.|.Description.|
|----------------------------------|-----|-------------|
|propSpawn(![image][ref-e],![image][ref-a],![image][ref-n])|![image][ref-e]|Rotation, Frozen Spawns a prop with the model of the template entity and rotated to the angle given. If frozen is `0`, then it will spawn unfrozen.|
|propSpawn(![image][ref-e],![image][ref-n])|![image][ref-e]|Entity template, Frozen Spawns a prop with the model of the template entity. If frozen is `0`, then it will spawn unfrozen.|
|propSpawn(![image][ref-e],![image][ref-v],![image][ref-a],![image][ref-n])|![image][ref-e]|Position, Rotation, Frozen Spawns a prop with the model of the template entity, at the position denoted by the vector, and rotated to the angle given. If frozen is `0`, then it will spawn unfrozen.|
|propSpawn(![image][ref-e],![image][ref-v],![image][ref-n])|![image][ref-e]|Entity template, Position, Frozen Spawns a prop with the model of the template entity at the position denoted by the vector. If frozen is `0`, then it will spawn unfrozen.|
|propSpawn(![image][ref-s],![image][ref-a],![image][ref-n])|![image][ref-e]|Model path, Rotation, Frozen Spawns a prop with the model denoted by the string filepath and rotated to the angle given. If frozen is `0`, then it will spawn unfrozen.|
|propSpawn(![image][ref-s],![image][ref-n])|![image][ref-e]|Use the model string or a template entity to spawn a prop. You can set the position and/or the rotation as well. The last number indicates frozen/unfrozen.|
|propSpawn(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n])|![image][ref-e]|Model path, Position, Rotation, Frozen Spawns a prop with the model denoted by the string file path, at the position denoted by the vector, and rotated to the angle given. If frozen is `0`, then it will spawn unfrozen.|
|propSpawn(![image][ref-s],![image][ref-v],![image][ref-n])|![image][ref-e]|Model path, Position, Frozen Spawns a prop with the model denoted by the string filepath at the position denoted by the vector. If frozen is `0`, then it will spawn unfrozen.|
|propSpawnEffect(![image][ref-n])||Set to `1` to enable prop spawn effect, `0` to disable.|
|propSpawnUndo(![image][ref-n])||Set to `0` to force prop removal on `E2` shutdown, and suppress Undo entries for props.|

|..............Prop.core.function..............|.Out.|.Description.|
|----------------------------------------------|-----|-------------|
|![image][ref-e]:deparent()||Unparents an entity, so it moves freely again.|
|![image][ref-e]:parentTo()||Parents one entity to another.|
|![image][ref-e]:parentTo(![image][ref-e])||Parents one entity to another.|
|![image][ref-e]:propBreak()||Breaks/Explodes breakable/explodable props (Useful for Mines).|
|propCanCreate()|![image][ref-n]|Returns `1` when propSpawn() will successfully spawn a prop until the limit is reached.|
|![image][ref-e]:propDelete()||Deletes the specified prop.|
|![image][ref-r]:propDelete()|![image][ref-n]|Deletes all the props in the given array, returns the amount of props deleted.|
|![image][ref-t]:propDelete()|![image][ref-n]|Deletes all the props in the given table, returns the amount of props deleted.|
|propDeleteAll()||Removes all entities spawned by this `E2`|
|![image][ref-e]:propDrag(![image][ref-n])||Passing `0` makes the entity not be affected by drag|
|![image][ref-e]:propDraw(![image][ref-n])||Passing `0` disables rendering for the entity (makes it really invisible)|
|![image][ref-e]:propFreeze(![image][ref-n])||Passing `0` unfreezes the entity, everything else freezes it.|
|![image][ref-e]:propGetElasticity()|![image][ref-n]|Gets prop's elasticity coefficient|
|![image][ref-e]:propGetFriction()|![image][ref-n]|Gets prop's friction coefficient|
|![image][ref-e]:propGravity(![image][ref-n])||Passing `0` makes the entity weightless, everything else makes it weighty.|
|![image][ref-e]:propInertia(![image][ref-v])||Sets the directional inertia|
|![image][ref-e]:propMakePersistent(![image][ref-n])||Setting to `1` will make the prop persistent.|
|![image][ref-e]:propManipulate(![image][ref-v],![image][ref-a],![image][ref-n],![image][ref-n],![image][ref-n])||Allows to do any single prop core function in one term (position, rotation, freeze, gravity, notsolid)|
|![image][ref-e]:propNotSolid(![image][ref-n])||Passing `0` makes the entity solid, everything else makes it non-solid.|
|![image][ref-e]:propPhysicalMaterial()|![image][ref-s]|Returns the surface material of a prop.|
|![image][ref-e]:propPhysicalMaterial(![image][ref-s])||Changes the surface material of a prop (eg. wood, metal, `...` See [`Material_surface_properties`](https://developer.valvesoftware.com/wiki/Material_surface_properties) `).`|
|![image][ref-e]:propSetBuoyancy(![image][ref-n])||Sets the prop's buoyancy ratio from `0` to `1`|
|![image][ref-e]:propSetElasticity(![image][ref-n])||Sets prop's elasticity coefficient (default is `1`)|
|![image][ref-e]:propSetFriction(![image][ref-n])||Sets prop's friction coefficient (default is `1`)|
|![image][ref-e]:propSetVelocity(![image][ref-v])||Sets the velocity of the prop for the next iteration|
|![image][ref-e]:propSetVelocityInstant(![image][ref-v])||Sets the initial velocity of the prop|
|![image][ref-e]:propShadow(![image][ref-n])||Passing `0` disables rendering for the entity's shadow|
|![image][ref-e]:propStatic(![image][ref-n])||Sets to `1` to make the entity static (disables movement, physgun, unfreeze, drive...) or `0` to cancel.|
|![image][ref-e]:reposition(![image][ref-v])||Deprecated. Kept for backwards-compatibility.|
|![image][ref-e]:rerotate(![image][ref-a])||Deprecated. Kept for backwards-compatibility.|
|seatSpawn(![image][ref-s],![image][ref-n])|![image][ref-e]|Model path, Frozen Spawns a prop with the model denoted by the string filepath. If frozen is `0`, then it will spawn unfrozen.|
|seatSpawn(![image][ref-s],![image][ref-v],![image][ref-a],![image][ref-n])|![image][ref-e]|Model path, Frozen Spawns a prop with the model denoted by the string filepath. If frozen is `0`, then it will spawn unfrozen.|
|![image][ref-e]:setAng(![image][ref-a])||Set the rotation of an entity.|
|![image][ref-e]:setPos(![image][ref-v])||Sets the position of an entity.|
|![image][ref-e]:use()||Simulates a player pressing their use key on the entity.|

|Icon|Description|
|---|---|
|![image][ref-a]|[Angle](https://en.wikipedia.org/wiki/Euler_angles) class|
|![image][ref-b]|[Bone](https://github.com/wiremod/wire/wiki/Expression-2#Bone) class|
|![image][ref-c]|[Complex](https://en.wikipedia.org/wiki/Complex_number) number|
|![image][ref-e]|[Entity](https://en.wikipedia.org/wiki/Entity) class|
|![image][ref-xm2]|[Matrix](https://en.wikipedia.org/wiki/Matrix_(mathematics)) 2x2|
|![image][ref-m]|[Matrix](https://en.wikipedia.org/wiki/Matrix_(mathematics))|
|![image][ref-xm4]|[Matrix](https://en.wikipedia.org/wiki/Matrix_(mathematics)) 4x4|
|![image][ref-n]|[Number](https://en.wikipedia.org/wiki/Number)|
|![image][ref-q]|[Quaternion](https://en.wikipedia.org/wiki/Quaternion)|
|![image][ref-r]|[Array](https://en.wikipedia.org/wiki/Array_data_structure)|
|![image][ref-s]|[String](https://en.wikipedia.org/wiki/String_(computer_science)) class|
|![image][ref-t]|[Table](https://github.com/wiremod/wire/wiki/Expression-2#Table)|
|![image][ref-xv2]|[Vactor](https://en.wikipedia.org/wiki/Euclidean_vector) 2D class|
|![image][ref-v]|[Vector](https://en.wikipedia.org/wiki/Euclidean_vector) 3D class|
|![image][ref-xv4]|[Vactor](https://en.wikipedia.org/wiki/4D_vector) 4D class|
|![image][ref-xrd]|[Ranger](https://github.com/wiremod/wire/wiki/Expression-2#BuiltIn_Ranger) data class|
|![image][ref-xwl]|[Wire link](https://github.com/wiremod/wire/wiki/Expression-2#Wirelink) class|
|![image][ref-xfs]|[Flash sensor](https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FSensor) class|
|![image][ref-xsc]|[State controller](https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl) class|
|![image][ref-xxx]|[Void](https://en.wikipedia.org/wiki/Void_type) value|

[ref-a]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Angle.png
[ref-b]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Bone.png
[ref-c]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-ComplexNumber.png
[ref-e]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Entity.png
[ref-xm2]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Matrix2.png
[ref-m]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Matrix.png
[ref-xm4]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Matrix4.png
[ref-n]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Number.png
[ref-q]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Quaternion.png
[ref-r]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Array.png
[ref-s]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-String.png
[ref-t]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Table.png
[ref-xv2]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Vector2.png
[ref-v]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Vector.png
[ref-xv4]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-Vector4.png
[ref-xrd]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-RangerData.png
[ref-xwl]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-WireLink.png
[ref-xfs]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-.png
[ref-xsc]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-.png
[ref-xxx]: https://raw.githubusercontent.com/wiki/wiremod/wire/Type-.png

