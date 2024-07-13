extends Node

var playerPlayable = true
var current_scene = null
var LevelNode = null
var GameRoot = null
var playerInstance = null

var fadeThing

var dan = false

func MM_Event(event_number):
	var completeScript = GameRoot.globalScript + current_scene.levelScript
	
	var i = 0
	var skip = 0
	
	var found_event = false
	var correct_event = false
	var commandGrab = false
	var extraGrab = false
	var event_id = ""
	var command = ""
	var extras = ""
	var done = false
	for n in completeScript:
		if skip <= 0:
			if n == "^" and correct_event == false:
				if event_number == event_id:
					print("				Found Event: " + event_id)
					correct_event = true
				elif found_event == false:
					event_id = ""
					found_event = true
				else:
					found_event = false
			elif n == "^" and correct_event == true:
				await HandleEvents._handle_command(command, extras)
				break
			elif command == "END":
				print("END command ran. Ending")
				break
			elif found_event == true and correct_event == false:
				event_id = event_id + n
			elif correct_event == true and n == "<" and commandGrab == false and extraGrab == false:
				commandGrab = true
			elif commandGrab == true and n != ">" and extraGrab == false:
				command = command + n
			elif commandGrab == true and n == ">":
				extraGrab = true
			elif n == "<" and commandGrab == true and extraGrab == true:
				extraGrab = false
				await HandleEvents._handle_command(command, extras)
				command = ""
				extras = ""
			elif extraGrab == true and n == "/":
				skip = 1
				extras = extras + completeScript[i + 1]
			elif extraGrab == true:
				extras = extras + n
			i = i + 1
		else:
			skip = skip - 1
	if command != "":
		await HandleEvents._handle_command(command, extras)
	
	#var i = 0
	#var found_event = false
	#var extra = ""
	#var command = ""
	#var skip = 0
	#var first = false
	#for n in completeScript:
	#	if n == "^":
	#		found_event = false
	#		var eventN = completeScript.substr(i + 1, 4)
	#		if eventN == event_number:
	#			found_event = true
	#			first = true
	#		else: 
	#			found_event = false
	#	elif n == "<" and found_event == true and first == false:
	#		await HandleEvents._handle_command(command, extra)
	#		extra = ""
	#		command = ""
	#		command = completeScript.substr(i + 1, 3)
	#		skip = 3
	#	elif n != "<" and found_event == true and first == false:
	#		if skip != 0:
	#			skip = skip - 1
	#		else:
	#			extra = extra + completeScript[i]
	#	elif first == true and n == "<":
	#		first = false
	#		command = completeScript.substr(i + 1, 3)
	#		skip = 3
	#	i = i + 1
	#	if command == "END":
	#		break
	#if command != "":
	#	await HandleEvents._handle_command(command, extra)
	print("Done")

# Called when the node enters the scene tree for the first time.
func _ready():
	var playerNode = preload("res://Entities/playerCite.tscn")
	var root = get_tree().root
	LevelNode = root.get_child(root.get_child_count() - 1).get_child(0)
	current_scene = root.get_child(root.get_child_count() - 1).get_child(0).get_child(0)
	GameRoot = root.get_child(root.get_child_count() - 1)
	playerInstance = playerNode.instantiate()
	playerInstance.position = Vector2(8.0, -8.0)
	GameRoot.add_child(playerInstance)
	#print(current_scene.levelScript)
	

func _fade():
	await fadeThing._fade()
	return true
	
func _fade_out():
	await fadeThing._fadeOut()
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func _swap_scene(scene, e, new_position, end_flip):
	var root = get_tree().root
	var levelSection = root.get_child(root.get_child_count() - 1).get_child(0)
	print(scene)
	print(new_position)
	current_scene.queue_free()
	var newLevel = load(AssetManager.scenes[str(scene)])
	var instance = newLevel.instantiate()
	levelSection.add_child(instance)
	current_scene = LevelNode.get_child(1)
	playerInstance.position = new_position
	var direction = playerInstance.currentDirection
	if end_flip == "0001": 
		direction = -1
	elif end_flip == "0002":
		direction = 1
	playerInstance.checking = false
	playerInstance.handle_animation("Idle", direction)
	MM_Event(e)
