extends Node3D
class_name MeshAnimationPlayer

@export_dir var loadAnimationsPath : Array[String]
@export_enum("obj", "gltf") var animationExtension: String = "gltf"
@export_node_path("MeshInstance3D") var meshNodePath

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

var meshObj : MeshInstance3D

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

func importMeshFromFbxFile(filePath):
	# prep gltf loader
	var gltf_state: GLTFState = GLTFState.new()
	var gltf_doc: GLTFDocument = GLTFDocument.new()

	# load resource and create outline mesh
	var error : Error = gltf_doc.append_from_file(filePath, gltf_state)
	var rootNode: Node
	if error != OK:
		trace_prin(nick + "Load file error : %s" %(filePath))
		return null
	rootNode = gltf_doc.generate_scene(gltf_state)
	return rootNode.get_child(0).mesh
## FIXME : Not the final code for this Function.
func importMeshFromObjFile(filePath):
	return load(filePath)

func recordNewFrame(gotMesh, animationName, index) :
	if gotMesh :
		#trace_prin("set map animationName [" +  animationName + "] = "+ str(index))
		dictForLoadedAnimations[animationName] = index
		loadedAnimations[index].push_back(gotMesh)

func _ready() :
	# Set initial timer.
	if meshNodePath.is_empty() == false:
		meshObj = get_node(meshNodePath)
	timerForAnimation = Timer.new()
	# Set time delay configuration.
	timerForAnimation.set_one_shot(false)
	set_delayms()
	timerForAnimation.set_autostart(true)
	timerForAnimation.stop()
	timerForAnimation.connect('timeout', Callable(self, 'loopFrames'))
	# Add to scene
	add_child(timerForAnimation)

# Setting up animation.
# Example:
# @onready var mesh_animation_player: MeshAnimationPlayer = $MeshAnimationPlayer
# mesh_animation_player.init()
func init() :
	var source = ""
	var animationName = ""

	loadedAnimations.clear()
	dictForLoadedAnimations.clear()

	# Load all objects from directory.
	for i in range(loadAnimationsPath.size()):
		var pathToMesh =  loadAnimationsPath[i]
		# Check if path exists.
		var Dir = DirAccess.open(pathToMesh)
		if not Dir :
			# No path to mesh.
			trace_prin(nick + ": Invalid path to mesh '" + pathToMesh + "'")
			continue
		# Prepare animation container.
		animationName = loadAnimationsPath[i].get_file()
		loadedAnimations.append([])
		
		# Set animation source path.
		source = loadAnimationsPath[i]

		# Check if named animation exists.
		if  Dir.dir_exists(source) == false:
			trace_prin(nick +": Missing animation '"+ animationName + "'")
			return

		# Load animation.
		Dir = DirAccess.open(source)
		Dir.list_dir_begin()
		while true:
			var frameFileName = Dir.get_next()
			if(frameFileName == ''):
				break # Break loop on no file returned.
			if frameFileName.begins_with('.'):
				continue
			var fileExtension = frameFileName.get_extension()
			var frame = frameFileName.rsplit('.')
			frame = frame[0]
			var fpath = source + '/' + frame + '.' + fileExtension
			var gotMesh
			if animationExtension == 'obj' :
				gotMesh = importMeshFromObjFile(fpath)
				recordNewFrame(gotMesh, animationName, i)
			if animationExtension == 'gltf' :
				if fileExtension != "gltf" and fileExtension != "glb" :
					continue
				gotMesh = importMeshFromFbxFile(fpath)
				recordNewFrame(gotMesh, animationName, i)
		Dir.list_dir_end()

	if len(loadedAnimations) == 0 or len(loadedAnimations[0]) == 0 :
		trace_prin(nick + ": Not Animation Loaded")
		return

	# Set initial frame.
	#meshObj.mesh = loadedAnimations[0][0]
	timerForAnimation.start()

# cover Animation Name to Animation ID
# Example:
# var id  = mesh_animation_player.animationNameToId('run')
# mesh_animation_player.playWithID(id)
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
	animationIdToPlay = animation
	animationPlayOrder = method
	isAnimationLoopPlay = loop
	resume()

# Plays stop motion animation.
# Example:
# mesh_animation_player.playWithID(id, true)
func playWithID(animation: int, loop: bool = false):
	_play_control(animation, PlayOrder.PlayInOrder, loop)

# Plays stop motion animation.
# Example:
# mesh_animation_player.play('run', true)
func play(animationName: String, loop: bool = false):
	var id = animationNameToId(animationName)
	playWithID(id, loop)

# Plays stop motion in reverse.
# Example:
# mesh_animation_player.reverseWithID(id, true)
func reverseWithID(animation: int, loop: bool = false):
	_play_control(animation, PlayOrder.PlayInReverse, loop)

# Plays stop motion in reverse.
# Example:
# mesh_animation_player.reverse('run', true)
func reverse(animationName: String, loop: bool = false):
	var id = animationNameToId(animationName)
	reverseWithID(id, loop)

# Plays stop motion in random order forever
# Example:
# mesh_animation_player.randomWithID(id)
func randomWithID(animation: int):
	_play_control(animation, PlayOrder.PlayInRamodm, true)

# Plays stop motion in random order forever
# Example:
# mesh_animation_player.random('run')
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
	meshObj.mesh = loadedAnimations[0][0]
# Pauses animation at current frame.
func pause():
	timerForAnimation.set_paused(true)
# Resumes animation from current frame.
func resume():
	timerForAnimation.set_paused(false)

# Loops trough animation frames.
func loopFrames():
	# Update mesh.
	meshObj.mesh = loadedAnimations[animationIdToPlay][curAnimationFrame]

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
