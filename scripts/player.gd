extends CharacterBody2D

#Importing Gravity and Making Speed and JV Accessible in INspector Menu

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Limiting Player Jumps
var current_jumps = 0
var max_jumps = 2

func _physics_process(delta):
	# Adds Gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 1000:
			velocity.y = 1000
		
	# Handles Player Movement
	if is_on_floor():
		current_jumps = 0
	
	if Input.is_action_just_pressed("jump") && current_jumps < max_jumps:
		velocity.y = JUMP_VELOCITY
		current_jumps += 1
		
	if Input.is_action_just_pressed("smash"):
		velocity.y = -JUMP_VELOCITY	* 10
		
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED

	move_and_slide()
	print(velocity)
