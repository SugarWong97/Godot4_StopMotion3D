extends 'res://StopMotion3D.gd'
func _ready():
	# initializes models, imports animations by name
	init('mesh/dancer1', ['stand', 'dance'])

	# calls to play animation[1] which is 'dance'
	# in a loop until stop() is called.
	play(1, true)
	pass
