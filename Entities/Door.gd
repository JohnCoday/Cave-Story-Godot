extends Sprite2D

var interactable = false

@export var eventNumber = "0000"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_down") and interactable:
		Globals.MM_Event(eventNumber)

func _on_area_2d_area_entered(area):
	interactable = true


func _on_area_2d_area_exited(area):
	interactable = false
