
# Godot4 StopMotion3D

A simple implementation for 3D stop motion animations with series of  mesh files(like obj file) within godot gdscript.

## How to set up?

1. Create a `MeshInstance3D` node within your scene
2. Create a `Node3D` node, name it `MeshAnimationPlayer` and attach script `MeshAnimationPlayer.gd` for that node.
3. Config `MeshInstance` node in `Inspector`, you will see `Load Animations Path` and `Animation Extension`:
 - `Load Animations Path` is an array of model path, each path will be searched. Each last level of path will be used as the `Animation Name`.
 - `Animation Extension` means the type of model file matching, support 'gltf'(`.glb` or `.gltf`) and 'Wavefront'(`.obj`) file.
 - `Mesh Node Path` is the node path which for playing mesh animation.
4. In somewhere as you want, call the `MeshAnimationPlayer` node which loading with script `MeshAnimationPlayer.gd`, with Function `init`, `set_delayms` and `play`.

## Example

```gdscript
@onready var mesh_animation_player: MeshAnimationPlayer = $MeshAnimationPlayer

func _ready():
	# initializes models, imports animations by name
	mesh_animation_player.init()

	# Set delay for frames
	mesh_animation_player.set_delayms(150)

	mesh_animation_player.play('run', true) # play 'run'
	#var id = mesh_animation_player.animationNameToId('run')
	#mesh_animation_player.playWithID(id, true) # play 'run'

	#mesh_animation_player.reverse('run', true) # play 'run' in reverse

	#mesh_animation_player.random('run') # play 'run' randomly

	#mesh_animation_player.pause() # pause
	#mesh_animation_player.resume() # resume
	#mesh_animation_player.stop() # stop
```
### init meshes

```gdscript
# Setting up animation.
# Example:
# @onready var mesh_animation_player: MeshAnimationPlayer = $MeshAnimationPlayer
# mesh_animation_player.init()
init()
```

Suppose you have made files at `res://meshes/character1/run/*.glb` and `res://meshes/character1/walk/*.glb`, added them(`res://meshes/character1/stand/` and `res://meshes/character1/walk/`) into `Load Animations Path` and selected `glb` as `Animation Extension` in the  `Inspector` of `MeshInstance` node,

after `init()` function called you will get  `Animation Name` with `stand` and `walk`.

```gdscript
mesh_animation_player.init()
```

And it will make a simple mapping between Animation Name and ID：

> Animation ID is another way to access the Animation.

|             Resource             | Animation Name | Animation ID |
| -------------------------------- | -------------- | ------------ |
| `res://meshes/character1/stand/` | stand          | 0            |
| `res://meshes/character1/walk/`  | walk           | 1            |

### Control animations

Once model files are loaded and stored as animation IDs. 

You can play, stop and pause the animation loaded, and change the speed for frame playing.

#### play

Now to play animation you can call one of the three methods: `play`, `reverse`, `random`; as follows:

```gdscript
# Plays stop motion animation.
# Example:
# mesh_animation_player.play('run', true)
play(animationName: String, loop: bool = false)

# Plays stop motion in reverse.
# Example:
# mesh_animation_player.reverse('run', true)
reverse(animationName: String, loop: bool = false)

# Plays stop motion in random order forever
# Example:
# mesh_animation_player.random('run')
random(animationName: String)
```

If you want to play more effective, call the `animationNameToId` once, then `playWithID`, `reverseWithID`, `randomWithID`.

```gdscript
# cover Animation Name to Animation ID
# Example:
# var id  = mesh_animation_player.animationNameToId('run')
# mesh_animation_player.playWithID(id)
animationNameToId(animationName: String)

# Plays stop motion animation.
# Example:
# mesh_animation_player.playWithID(id, true)
playWithID(animation: int, loop: bool = false)

# Plays stop motion in reverse.
# Example:
# mesh_animation_player.reverseWithID(id, true)
reverseWithID(animation: int, loop: bool = false)

# Plays stop motion in random order.
# Example:
# mesh_animation_player.randomWithID(id)
randomWithID(animation: int)
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

## Thanks

https://github.com/Boyquotes/godot_StopMotion3D

