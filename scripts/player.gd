extends CharacterBody2D


const RUN_SPEED = 120.0
const RUN_DECELERATION = 12.0
const JUMP_VELOCITY = -280.0

# Sprinting mechanic variables: rn, these are numbers that feel right.
# Idea with this mechanic is to have a dynamic/fatigue system for the sprinting.
const SPRINT_SPEED = 260.0
const COOLDOWN_SPEED = 90.0

const SPRINT_ACCELERATION = 12.0
const SPRINT_DECELERATION = 12.0
const RETURN_ACCELERATION = 2.0

@onready var sprint_attack_timer: Timer = $SprintAttackTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Bool that can block inputs for the player.
var input_block_bool = false
# Knows if we have died.
var is_game_over = false
# Lets process know that the sprint attack is active.
var sprint_attack_active = false
var sprint_attack_direction = 1

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")

	if input_block_bool == false:
		
		# Flip the sprite depending on direction.
		sprite_flip(direction)
		
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Handle animation of player.
		handle_animation(direction)
		
		# If we are moving:
		if direction:
			
			# Begin sprint attack
			if Input.is_action_just_pressed("sprint") and is_on_floor():
				sprint_attack_active = true
				block_inputs()
				sprint_attack_direction = direction
				sprint_attack_timer.start()
			# No sprint
			else:
				#velocity.x = direction * RUN_SPEED
				velocity.x = move_toward(velocity.x, RUN_SPEED*direction, RUN_DECELERATION)
				print("No sprint: ", velocity.x)
		# If we are not moving, decelerate to 0 speed.
		else:
			velocity.x = move_toward(velocity.x, 0, RUN_DECELERATION)
	# Else, the input is blocked for one of many reasons.
	else:
		if is_game_over:
			if position.y > 125:
				velocity.x = 0
		elif sprint_attack_active:
			handle_sprint_attack()

	move_and_slide()
	
func block_inputs():
	input_block_bool = true
	
func unblock_inputs():
	input_block_bool = false

func handle_death():
	block_inputs()
	is_game_over = true
	sprint_attack_active = false

# Function that handles the flipping of the sprite based on direction.
func sprite_flip(direction):
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

func handle_animation(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jumping")

func handle_sprint_attack():
	if sprint_attack_active:
		velocity.x = move_toward(velocity.x, SPRINT_SPEED * sprint_attack_direction, 
			SPRINT_ACCELERATION)
	else:
		unblock_inputs()
	print("Handle Sprint: ", velocity.x)

func _on_sprint_attack_timer_timeout() -> void:
	sprint_attack_active = false
	unblock_inputs()
	sprint_attack_timer.stop()
	print("Timer done!")
