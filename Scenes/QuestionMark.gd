extends Node
@onready var animation_player = $AnimationPlayer

var hasStartedAnim = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation_player.is_playing() == false and hasStartedAnim == false:
		animation_player.play("Huh")
		hasStartedAnim = true



func _on_animation_player_animation_finished(anim_name):
	if hasStartedAnim == true:
		self.call_deferred("queue_free")
