extends CharacterBody2D

# Importing Gravity and Making Speed and JV Accessible in Inspector Menu
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ap = $AnimationPlayer
@onready var sprite =  $Sprite2D

# Handling Wallslide and Limiting Player Jumps
var current_jumps = 0
var max_jumps = 2
var current_sjumps = 0
var max_sjumps = 1
var wall_jump_rebound = 100
var wall_slide_gravity = 100
var is_wall_sliding = false
var dashing = false
var DASH_SPEED = SPEED * 2.5

# Adds Physics

func _physics_process(delta):
	# Adds Gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 1000:
			velocity.y = 1000
	
	wall_slide(delta)    

	if Input.is_action_just_pressed("smash"):
		velocity.y = -JUMP_VELOCITY * 10
		
	if Input.is_action_pressed("dash"):
		dashing = true	
		$dash_timer.start()

	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		switch_direction(direction)
	if dashing:
		velocity.x = direction * DASH_SPEED
	else:	
		velocity.x = direction * SPEED   
				 
	
	

	# Handles Double and Wall Jump
	if is_on_floor():
		current_jumps = 0
		current_sjumps = 0
	
	if Input.is_action_just_pressed("jump") && (current_jumps < max_jumps || is_wall_sliding):
		if is_on_wall() && Input.is_action_pressed("move_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x += wall_jump_rebound
		elif is_on_wall() && Input.is_action_pressed("move_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x += -wall_jump_rebound
		else:
			velocity.y = JUMP_VELOCITY
		current_jumps += 1
		
	if Input.is_action_just_pressed("jump") && current_sjumps < max_sjumps && Input.is_action_pressed("dash"):
		velocity.y 	 = JUMP_VELOCITY * 1.75
		current_jumps += 1
		current_sjumps += 1
	
	update_animations(direction)			
	
func wall_slide(delta):
	if is_on_wall() && !is_on_floor():
		if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false    
	else:
		is_wall_sliding = false        
	
	if is_wall_sliding:
		current_jumps = 0
		velocity.y += (wall_slide_gravity * delta)    
		velocity.y = min(velocity.y, wall_slide_gravity)
		
	

	move_and_slide()
	print(velocity)


func _on_dash_timer_timeout():
	dashing = false

func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			ap.play("idle")
		else:
			ap.play("run")

func switch_direction(direction):
	sprite.flip_h = (direction == -1)
	sprite.position.x = direction
	
