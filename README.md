
# Godot StopMotion3D

A simple implementation for 3D stop motion animations with series of  mesh files(like obj file) within godot gdscript.

## How to set up?

1. Create a `MeshInstance` node within your scene
2. Create/open script `StopMotion3D.gd` for that node.
3. In somewhere, call the `MeshInstance` node which loading with script `StopMotion3D.gd` , with Function `init`, `set_delayms` and `play`.

## Example

```gdscript
onready var mesh_instance = $MeshInstance

func _ready():
	# initializes models, imports animations by name
	mesh_instance.init('meshes/character1', ['run'], 'obj')
	mesh_instance.set_delayms(50)
	# calls to play animation[1] which is 'stand'
	# in a loop until stop() is called.
	mesh_instance.play(0, true) # play 'run'
	mesh_instance.reverse(0, true) # play 'run' in reverse
	mesh_instance.random(0) # play 'run' randomly

```
### init meshes

```gdscript
mesh_instance.init('meshes/character1', ['run', 'walk'], 'obj')
```

Make sure  path in `init` exists.

| Resource                              | Animation ID |
| :------------------------------------ | -----------: |
| `res://meshes/character1/stand/*.obj` |            0 |
| `res://meshes/character1/walk/*.obj`  |            1 |

### Control animations

Once model files are loaded and stored as animation IDs. 

#### play

Now to play animation you can call one of the three methods: `play`, `reverse`, `random`; as follows:

```gdscript
# Plays stop motion animation.
# Example:
# object.play(0, true)
# Plays walk animation in a loop.
play(animation: int, loop: bool = false)

# Plays stop motion in reverse.
# Example:
# object.reverse(0, true)
# Plays walk in reverse (aka. moonwalk) animation in a loop.
reverse(animation: int, loop: bool = false)

# Plays stop motion in random order.
# Example:
# object.random('0')
# Plays walk animation frames in a random order.
random(animation: int)
```

#### stop & pause

```gdscript
# Stops animation and resets to initial 0,0 animation.
stop()

# Pauses animation at current frame.
pause()

# Resumes animation from current frame.
resume()
```

To stop animation call `stop()` which will reset mesh to animation0 frame0. In our case stand animation frame 0.

Pausing an animation is done by `pause()` which will keep the running animationID and its current frame.

Call `resume()` to resume paused animation.

#### Animation speed

> By default animation speed is set to delay 150ms between each frame.

This can be changed by calling:

```gdscript
set_delayms(delay_ms: int = 150)
```

For example to set animation speed to delay 100ms between each frame call:
```gdscript
set_delayms(100)
```

## Thanks

https://github.com/Boyquotes/godot_StopMotion3D
