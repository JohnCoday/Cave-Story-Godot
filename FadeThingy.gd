extends Camera2D
var canFade = true
var rowsStarded = 0
var faded = false

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.fadeThing = self

func _fade():
	var rows = get_children()
	var first = true
	for row in rows:
		if first == true:
			first = false
		else:
			for spr in row.get_children():
				spr.speed_scale = 1
				spr.play("default")
			timer.start(0.025)
			await(timer.timeout)
	timer.start(1)
	await(timer.timeout)
	faded = true
	return true
	
func _fadeOut():
	faded = false
	var rows = get_children()
	var first = true
	for row in rows:
		if first == true:
			first = false
		else:
			for spr in row.get_children():
				spr.speed_scale = -1
				spr.play("default", true)
			timer.start(0.025)
			await(timer.timeout)
	timer.start(1)
	await(timer.timeout)
	Globals.playerPlayable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
