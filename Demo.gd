extends Node3D

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
