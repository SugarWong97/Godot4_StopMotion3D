extends Spatial

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
