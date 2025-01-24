extends MeshInstance3D

enum PlayOrder
{
	PlayInOrder = 0,
	PlayInReverse,
	PlayInRamodm
}


# Global animation container
var nick = 'StopMotion3D'
var loadedAnimations = []
var dictForLoadedAnimations = {}

# Animation playback settings.
var animationIdToPlay = 0
var animationPlayOrder = PlayOrder.PlayInOrder
var isAnimationLoopPlay = false
var curAnimationFrame = 0
var frameDelay = 0

# Actual timer.
var timerForAnimation = null

func trace_prin(info_str):
	push_error(info_str)
	print(info_str)

# Setting up animation.
# Example:
# @onready var mesh_instance = $MeshInstance3D
# mesh_instance.init('meshes/character1', ['walk', 'jump'], 'obj')
func init(path: String, animations: Array, extension: String = 'obj') :
	# Use directory class.
	var pathToMesh = 'res://'+ path
	var source = ""
	var Dir = DirAccess.open(pathToMesh)
	# Set initial timer.
	timerForAnimation = Timer.new()
	# Check if path exists.
	if not Dir :
		# No path to mesh.
		trace_prin(nick +": Invalid path to mesh '"+ pathToMesh +"'")
		return

	# Load all objects from directory.
	for i in range(animations.size()):
		# Prepare animation container.
		loadedAnimations.append([])
		
		# Set animation source path.
		source = pathToMesh +'/'+ animations[i]
		
		# Check if named animation exists.
		if  Dir.dir_exists(source) == false:
			trace_prin(nick +": Missing animation '"+ source +"'")
			return

		# Load animation.
		Dir = DirAccess.open(source)
		Dir.list_dir_begin()
		while true:
			var frame = Dir.get_next()
			if(frame == ''): 
				break # Break loop on no file returned.
			if frame.begins_with('.'):
				continue
			# Load animation from source.
			frame = frame.rsplit('.')
			frame = frame[0]
			var fpath = source +'/'+ frame +'.'+ extension
			dictForLoadedAnimations[animations[i]] = i
			loadedAnimations[i].push_back(load(fpath))
		Dir.list_dir_end()

	if len(loadedAnimations) == 0 or len(loadedAnimations[0]) == 0 :
		trace_prin(nick +": Invalid path to mesh '"+ pathToMesh +"'")
		return

	# Set initial frame.
	self.mesh = loadedAnimations[0][0]

	set_delayms()
	
	# Set time delay configuration.
	timerForAnimation.set_one_shot(false)
	timerForAnimation.set_autostart(true)
	timerForAnimation.connect('timeout', Callable(self, 'loopFrames'))

	# Add to scene
	add_child(timerForAnimation)

# cover Animation Name to Animation ID
# Example:
# var id  = mesh_instance.animationNameToId('run')
# mesh_instance.playWithID(id)
func animationNameToId(animationName: String):
	for aname in dictForLoadedAnimations:
		if animationName == aname:
			return dictForLoadedAnimations[aname]
	return -1


func _play_control(animation: int, method : int, loop: bool = false):
	if animation < 0 :
		trace_prin(nick + ": Can not Play Animation, id not found")
		pause()
		return
	# Default: 0
	animationIdToPlay = animation
	animationPlayOrder = method
	isAnimationLoopPlay = loop
	resume()

# Plays stop motion animation.
# Example:
# mesh_instance.playWithID(id, true)
func playWithID(animation: int, loop: bool = false):
	_play_control(animation, PlayOrder.PlayInOrder, loop)

# Plays stop motion animation.
# Example:
# mesh_instance.play('run', true)
func play(animationName: String, loop: bool = false):
	var id = animationNameToId(animationName)
	playWithID(id, loop)

# Plays stop motion in reverse.
# Example:
# mesh_instance.reverseWithID(id, true)
func reverseWithID(animation: int, loop: bool = false):
	_play_control(animation, PlayOrder.PlayInReverse, loop)

# Plays stop motion in reverse.
# Example:
# mesh_instance.reverse('run', true)
func reverse(animationName: String, loop: bool = false):
	var id = animationNameToId(animationName)
	reverseWithID(id, loop)

# Plays stop motion in random order forever
# Example:
# mesh_instance.randomWithID(id)
func randomWithID(animation: int):
	_play_control(animation, PlayOrder.PlayInRamodm, true)

# Plays stop motion in random order forever
# Example:
# mesh_instance.random('run')
func random(animationName: String):
	var id = animationNameToId(animationName)
	randomWithID(id)

# Stops animation and resets to initial 0,0 animation.
func stop():
	# Pause delay timer.
	pause()
	curAnimationFrame = 0
	if len(loadedAnimations) == 0 or len(loadedAnimations[0]) == 0 :
		trace_prin(nick + ": Stop, But nothing loaded")
		return
	# Set self mesh to zero.
	self.mesh = loadedAnimations[0][0]
# Pauses animation at current frame.
func pause():
	timerForAnimation.set_paused(true)
# Resumes animation from current frame.
func resume():
	timerForAnimation.set_paused(false)

# Loops trough animation frames.
func loopFrames():
	# Update mesh.
	self.mesh = loadedAnimations[animationIdToPlay][curAnimationFrame]

	# Set number of frames in animation.
	var nOfFrames = loadedAnimations[animationIdToPlay].size() - 1

	if animationPlayOrder == PlayOrder.PlayInOrder :
		if curAnimationFrame < nOfFrames:
			curAnimationFrame += 1
		elif isAnimationLoopPlay == true:
			curAnimationFrame = 0
		else:
			pause()
	if animationPlayOrder == PlayOrder.PlayInReverse :
		if curAnimationFrame > 0:
			curAnimationFrame -= 1
		elif isAnimationLoopPlay == true:
			curAnimationFrame = nOfFrames
		else:
			pause()
	if animationPlayOrder == PlayOrder.PlayInRamodm:
		curAnimationFrame = randi() % nOfFrames

# Updates delay
func set_delayms(delay_ms: int = 150):
	frameDelay = delay_ms / 1000.0
	timerForAnimation.set_wait_time(frameDelay)
