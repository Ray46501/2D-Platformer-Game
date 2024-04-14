extends CharacterBody2D

#Importing Gravity and Making Speed and JV Accessible in INspector Menu

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Limiting Player Jumps and Introducing Wall Slide/Stick
var current_jumps = 0
var max_jumps = 2
const wall_slide_acceleration = 10
const max_wall_slide_speed = 120

func _physics_process(delta):
	# Adds Gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 1000:
			velocity.y = 1000
		
	# Handles Wall SLide and Double Jump
	if is_on_floor() || is_on_wall():
		current_jumps = 0
	
	if is_on_wall() && (Input.is_action_just_pressed("move_right") || Input.is_action_just_pressed("move_left")):
		if velocity.y >= 0:
			velocity.y = min(velocity.y + wall_slide_acceleration, max_wall_slide_speed)	
		
	# Handles Player Movement
	if Input.is_action_just_pressed("jump") && current_jumps < max_jumps:
		velocity.y = JUMP_VELOCITY
		current_jumps += 1
				
		
	if Input.is_action_just_pressed("smash"):
		velocity.y = -JUMP_VELOCITY * 10
		
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED

	move_and_slide()
	print(velocity)
