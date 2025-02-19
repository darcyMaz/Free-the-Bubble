extends CharacterBody2D

# IF CHECKPOINT PASS AND THEN MOB DEATH THEN IT DOES NOT RESET THE MAP?

const RUN_SPEED = 120.0
const RUN_DECELERATION = 12.0
const JUMP_VELOCITY = -280.0

# Sprinting mechanic variables.
const SPRINT_SPEED = 340.0
const SPRINT_ACCELERATION = 24.0
var sprint_attack_active = false
var sprint_attack_direction = 0

@onready var lower_bound_killzone: Area2D = $"../Killzones/LowWorldBound/Killzone"
@onready var game_manager: Node = %GameManager
@onready var sprint_attack_timer: Timer = $SprintAttackTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Bool that can block inputs for the player.
var input_block_bool = false
var is_game_over = false


# Called when the node enters the scene tree for the first time.
# Important to call this as opposed to _ready because setting the
#	player's pos during the enter_tree func means we are early enough
#	for the player not to clearly move from original pos to this one.
func _enter_tree() -> void:
	if Checkpoint.last_position != null:
		global_position = Checkpoint.last_position

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
		handle_normal_animation(direction)
		
		# If we start the sprint attack.
		if Input.is_action_just_pressed("sprint"):
			sprint_attack_active = true
			block_inputs()
			sprint_attack_direction = direction
			animated_sprite.play("sprint_attack")
			sprint_attack_timer.start()
		# Else if we are moving/holding down left/right:
		elif direction:
			# Accel/decel to normal speed.
			velocity.x = move_toward(velocity.x, RUN_SPEED*direction, RUN_DECELERATION)
		# If we are not moving.
		else:
			# Decelerate to 0.
			velocity.x = move_toward(velocity.x, 0, RUN_DECELERATION)
	# Else, the input is blocked for one of many reasons.
	else:
		if is_game_over:
			# force timeout of sprint attack
			# that might be it lol
			if position.y > 125:  # put this in a variable
				velocity.x = 0
			else:
				if velocity.x != 0:
					animated_sprite.play("death")
					velocity.x = move_toward(velocity.x, 0, 1)
				else:
					animated_sprite.play("dead")
				
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
		animated_sprite.flip_h = false # right
	elif direction < 0:
		animated_sprite.flip_h = true

func handle_normal_animation(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jumping")

func handle_sprint_attack():
	if sprint_attack_active:
		if sprint_attack_direction == 0:
			# use flip_h to give a direction
			if animated_sprite.flip_h == false:
				sprint_attack_direction = 1
			else:
				sprint_attack_direction = -1
		velocity.x = move_toward(velocity.x, SPRINT_SPEED * sprint_attack_direction, 
			SPRINT_ACCELERATION)
	else:
		unblock_inputs()

func _on_sprint_attack_timer_timeout() -> void:
	sprint_attack_active = false
	unblock_inputs()
	sprint_attack_timer.stop()
