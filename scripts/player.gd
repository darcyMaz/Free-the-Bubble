extends CharacterBody2D


const RUN_SPEED = 120.0
const RUN_DECELERATION = 10.0
const JUMP_VELOCITY = -280.0

# Sprinting mechanic variables: rn, these are numbers that feel right.
# Idea with this mechanic is to have a dynamic/fatigue system for the sprinting.
const SPRINT_SPEED = 200.0
const COOLDOWN_SPEED = 90.0

const SPRINT_ACCELERATION = 12.0
const SPRINT_DECELERATION = 12.0
const RETURN_ACCELERATION = 2.0

const SPRINT_DURATION = 1.0
const COOLDOWN_DURATION = 1.5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Bool that can block inputs for the player.
# True on when player dies.
var input_block_bool = false

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")

	# If false, then the player has not died.
	if input_block_bool == false:
		
		# Flip the sprite depending on direction.
		sprite_flip(direction)
		
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		
			

		
		# Handle animation of player.
		handle_animation(direction)
		
		# I need to change this so it refers to current speed not set speed.
		# This will keep the speed that same thing.
		if direction:
			# Begins sprint
			if Input.is_action_pressed("sprint") and is_on_floor():
				handle_sprint(direction)
			# Ends sprint
			elif Input.is_action_just_released("sprint"):
				handle_slowdown(direction)
			# No sprint
			else:
				velocity.x = direction * RUN_SPEED
				print("No sprint: ", velocity.x)
		else:
			velocity.x = move_toward(velocity.x, 0, SPRINT_DECELERATION)
	else:
		if position.y > 125:
			velocity.x = 0

	move_and_slide()
	
func block_inputs():
	input_block_bool = true

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

func handle_sprint(direction):
	velocity.x = move_toward(velocity.x, SPRINT_SPEED * direction, SPRINT_ACCELERATION * direction)
	print("Handle Sprint: ", velocity.x)
	
func handle_slowdown(direction):
	velocity.x = move_toward(velocity.x, COOLDOWN_SPEED * direction, SPRINT_DECELERATION * direction)
	velocity.x = move_toward(velocity.x, RUN_SPEED * direction, RETURN_ACCELERATION * direction)
	print("Release sprint")
