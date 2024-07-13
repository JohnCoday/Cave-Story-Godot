extends CharacterBody2D

const MAX_SPEED = 75.0
const JUMP_VELOCITY = 140
const ACCR = 5.0
const FRICTION = 6.0

const WATER_MAX_SPEED = 40.0
const WATER_JUMP_VELOCITY = 80.0
const WATER_ACCR = 2.0

@onready var animator = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 400
var currentGravity = gravity
var jumpTime = 0.0
var allowMovement = true
var wamder = false
var checking = false
var able_to_interact = false
var hasChecked = false
var currentDirection = 0

@export var qMark: PackedScene

func _physics_process(delta):
	# Add the gravity.
	if Globals.playerPlayable == true:
		var anim = "Idle"
		velocity.y += currentGravity * delta
		var direction = Input.get_axis("ui_left", "ui_right")
		currentDirection = direction
		if not is_on_floor():
			anim = "Jump"
			jumpTime = 0.0

		# Handle jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			currentGravity = gravity / 2
			velocity.y = jump_speed()
		if Input.is_action_just_released("Jump") or velocity.y > 0:
			currentGravity = gravity

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if direction:
			if wamder == true:
				velocity.x = move_toward(velocity.x, direction * WATER_MAX_SPEED, WATER_ACCR)
			else:
				velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCR)
			if is_on_floor():
				anim = "Walk"
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION)

		move_and_slide()
		if Input.is_action_just_pressed("ui_down") and direction == 0 and is_on_floor():
			checking = true
		elif checking == true and (direction != 0 or not is_on_floor()):
			checking = false
			hasChecked = false
			
		if checking == true:
			anim = "Check"
			if able_to_interact == false and hasChecked == false:
				hasChecked = true
				var question_mark = load("res://Entities/Misc/question_mark.tscn")
				var mark = question_mark.instantiate()
				mark.position = self.position
				get_tree().root.add_child(mark)
		handle_animation(anim, direction)
	
func jump_speed():
	var speed_incr: float = 12.0
	if wamder == false:
		return -(JUMP_VELOCITY + speed_incr * int(abs(velocity.x) / 30))
	else:
		return -(WATER_JUMP_VELOCITY + speed_incr * int(abs(velocity.x) / 30))
	
func handle_animation(anim, direction):
	if direction < 0:
		animator.flip_h = true
	elif direction > 0: 
		animator.flip_h = false
	if Input.is_action_pressed("ui_up"):
		anim = anim + "LookUp"
	elif Input.is_action_pressed("ui_down"):
		if not is_on_floor():
			anim = anim + "LookDown"
	animator.play(anim)

func _on_water_detect_area_entered(area):
	wamder = true

func _on_water_detect_area_exited(area):
	wamder = false

func _on_interactable_area_entered(area):
	able_to_interact = true

func _on_interactable_area_exited(area):
	able_to_interact = false
