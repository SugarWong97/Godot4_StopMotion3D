extends Node3D

@onready var mesh_animation_player: MeshAnimationPlayer = $MeshAnimationPlayer

func _ready():
	# initializes models, imports animations by name
	mesh_animation_player.init()
	mesh_animation_player.animation_frame_changed.connect(_when_mesh_animation_player_frame_changed)
	mesh_animation_player.animation_finished.connect(_when_mesh_animation_player_animation_finished)

	# Set delay for frames
	#mesh_animation_player.set_default_fps(12)

	mesh_animation_player.play('run', true) # play 'run'
	#var id = mesh_animation_player.animationNameToId('run')
	#mesh_animation_player.playWithID(id, true) # play 'run'

	#mesh_animation_player.reverse('run', true) # play 'run' in reverse

	#mesh_animation_player.random('run') # play 'run' randomly

	#mesh_animation_player.pause() # pause
	#mesh_animation_player.resume() # resume
	#mesh_animation_player.stop() # stop

func _when_mesh_animation_player_frame_changed(animName : StringName, frame : int):
	print("Animation [" + animName + "] Played frame :" + str(frame))

func _when_mesh_animation_player_animation_finished(animName : StringName) :
	print("Animation [" + animName + "] finished")

func _input(event):
	if event is InputEventKey :
		if Input.is_physical_key_pressed(KEY_Z) :
			mesh_animation_player.play('run', true)
		if Input.is_physical_key_pressed(KEY_X) :
			mesh_animation_player.play('idle', false, true)
