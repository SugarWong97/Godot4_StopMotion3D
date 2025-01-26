extends Node3D

@onready var mesh_instance = $MeshInstance3D

func _ready():
	# initializes models, imports animations by name
	mesh_instance.init()

	# Set delay for frames
	mesh_instance.set_delayms(50)

	mesh_instance.play('run', true) # play 'run'
	#var id = mesh_instance.animationNameToId('run')
	#mesh_instance.playWithID(id, true) # play 'run'

	#mesh_instance.reverse('run', true) # play 'run' in reverse

	#mesh_instance.random('run') # play 'run' randomly

	#mesh_instance.pause() # pause
	#mesh_instance.resume() # resume
	#mesh_instance.stop() # stop
