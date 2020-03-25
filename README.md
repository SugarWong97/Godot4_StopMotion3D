# godot_StopMotion3D
A simple implementation for 3D stop motion animations with series of .vox, .obj, etc. files within godot gdscript.

## How to set up?
1. Create a MeshInstance node within your scene
2. Create/open script for that node.
3. In the first line replace 'extends MeshInstance' with 'extends "res://path/to/StopMotion.gd"'

## Loading in model files for animations
1. Within created script for MeshInstance call **init** function where:
⋅⋅⋅**init**(_String_ 'path/to/folder', _Array_ ['animationName0', 'animationName1'], [_String_ 'vox'])
⋅⋅⋅
⋅⋅⋅This will load all objects within 'res://[path/to/folder]/[animationName0 ...n]/* .[vox]'
⋅⋅⋅and store it as animation index [0 ...n]
⋅⋅⋅
⋅⋅⋅Example:
⋅⋅⋅**init**('meshes/character1', ['stand', 'walk', 'jump', 'attack'], 'vox')
⋅⋅⋅
⋅⋅⋅Will load:

Resource | Animation ID
--- | ---:
res://meshes/character1/stand/* .vox | 0
--- | ---:
res://meshes/character1/walk/* .vox | 1
--- | ---:
res://meshes/character1/jump/* .vox | 2
--- | ---:
res://meshes/character1/attack/* .vox | 3

## Playing, pausing and stopping animations.
Once model files are loaded and stored as animation IDs. Now to play animation you can call one of
the tree methods: play, reverse, random; as follows:
1. **play**(_int_ AnimationID, _bool_ loop)
⋅⋅⋅This trigger animation 0 (which is stand) to play all loaded models within .../stand/* .vox
⋅⋅⋅in a loop.
⋅⋅⋅
⋅⋅⋅Example:
⋅⋅⋅**play**(0, true)
⋅⋅⋅
2. **reverse**(_int_ AnimationID, _bool_ loop)
⋅⋅⋅Same as play but in reverse order.
⋅⋅⋅
3. **random**(_int_ AnimationID)
⋅⋅⋅A random order animation is always played within a loop.

To stop animation call **stop()** which will reset mesh to animation0 frame0. In our case stand animation frame 0.
Pausing an animation is done by **pause()** which will keep the running animationID and its current frame.
Call **resume()** to resume paused animation.

## Animation speed.
By default animation speed is set to delay 150ms between each frame.
This can be changed by calling:
**set_delay**(_float_ Milliseconds below 1000)

For example to set animation speed to delay 100ms between each frame call:
**set_delay**(100.0)

Thanks!
