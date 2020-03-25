extends MeshInstance

# Global animation container
var nick = 'StopMotion3D'
var loadedAnimations = []

# Animation playback settings.
var aToPlay = 0
var aMethod = 0
var aOfLoop = false
var aFrame = 0
var aDelay = 0.150

# Actual timer.
var aTimer = null

# Setting up animation.
# Example:
# var object = StopMotion3D.new('mesh/char', ['walk', 'jump'], 'vox')
func init(path: String, animations: Array, extension: String = 'vox'):
	# Use directory class.
	var Dir = Directory.new()
	var pathToMesh = 'res://'+ path
	
	# Check if path exists.
	if(Dir.dir_exists(pathToMesh)):
		# Load all objects from directory.
		for i in range(animations.size()):
			# Prepare animation container.
			loadedAnimations.append([]);
			
			# Set animation source path.
			var source = pathToMesh +'/'+ animations[i]
			
			# Check if named animation exists.
			if(Dir.dir_exists(source)):
				# Load animation.
				Dir.open(source)
				Dir.list_dir_begin()
				while true:
					var frame = Dir.get_next()
					if(frame == ''):
						# Break loop on no file returned.
						break
					elif not frame.begins_with('.'):
						# Load animation from source.
						frame = frame.rsplit('.')
						frame = frame[0]
						var fpath = source +'/'+ frame +'.'+ extension;

						loadedAnimations[i].push_back(load(fpath))
				Dir.list_dir_end()
			else:
				push_error(nick +": Missing animation '"+ source +"'")
		pass
	else:
		# No path to mesh.
		push_error(nick +": Invalid path to mesh '"+ pathToMesh +"'")
		
	# Set initial frame.
	self.mesh = loadedAnimations[0][0]
	
	# Set initial timer.
	aTimer = Timer.new()
	set_delay()
	
	# Set time delay configuration.
	aTimer.set_one_shot(false)
	aTimer.set_autostart(true)
	aTimer.connect('timeout', self, 'loopFrames')
	
	# Add to scene
	add_child(aTimer)
	pass

# Plays stop motion animation.
# Example:
# object.play(0, true)
# Plays walk animation in a loop.
func play(animation: int, loop: bool = false):
	# Default: 0
	aToPlay = animation
	aMethod = 0
	aOfLoop = loop
	resume()
	pass

# Plays stop motion in reverse.
# Example:
# object.reverse(0, true)
# Plays walk in reverse (aka. moonwalk) animation in a loop.
func reverse(animation: int, loop: bool = false):
	# Reverse: 
	aToPlay = animation
	aMethod = 1
	aOfLoop = loop
	resume()
	pass
	
# Plays stop motion in random order.
# Example:
# object.random('0')
# Plays walk animation frames in a random order.
func random(animation: int):
	# Random: 2
	aToPlay = animation
	aMethod = 2
	aOfLoop = true
	resume()
	pass
	
# Stops animation and resets to initial 0,0 animation.
func stop():
	# Pause delay timer.
	pause();
	aFrame = 0
	
	# Set self mesh to zero.
	self.mesh = loadedAnimations[0][0]
	pass
	
# Pauses animation at current frame.
func pause():
	aTimer.set_paused(true);
	pass
	
# Resumes animation from current frame.
func resume():
	aTimer.set_paused(false);
	pass
	
# Loops trough animation frames.
func loopFrames():
	# Update mesh.
	self.mesh = loadedAnimations[aToPlay][aFrame]
	
	# Set number of frames in animation.
	var nOfFrames = loadedAnimations[aToPlay].size() - 1
	
	if(aMethod == 0):
		if(aFrame < nOfFrames):
			aFrame += 1
		elif aOfLoop == true:
			aFrame = 0
		else:
			pause()
	if(aMethod == 1):
		if(aFrame > 0):
			aFrame -= 1
		elif aOfLoop == true:
			aFrame = nOfFrames
		else:
			pause()
	if(aMethod == 2):
		aFrame = randi()%nOfFrames
	pass
	
# Updates delay
func set_delay(delay: int = 150):
	aDelay = delay / 1000.0
	aTimer.set_wait_time(aDelay)
	pass
