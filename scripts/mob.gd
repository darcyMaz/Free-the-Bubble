extends Node2D

# PROBLEM IS:
#	killzone script is below the mob and mob2 objects.
#	so they'll never be at the same level
#	unless i make the lowerbound its own object with a killzone as an extension

const SPEED = 60
const GRAVITY = 120
var direction_x = -1
@onready var ray_cast_right: RayCast2D = $Killzone/RayCastRight
@onready var ray_cast_left: RayCast2D = $Killzone/RayCastLeft
@onready var ray_cast_down: RayCast2D = $Killzone/RayCastDown
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# print(position.x, " ", position.y)
	# print("Left ray: ", ray_cast_left.is_colliding(), " - Right ray: ", ray_cast_right.is_colliding())
	
	if ray_cast_right.is_colliding():
		direction_x = -1
		anim_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction_x = 1
		anim_sprite.flip_h = false
		
	if ! ray_cast_down.is_colliding():
		position.y += GRAVITY * delta
		direction_x = 0
	else:
		# if not left or right choose a direction
		if !( (direction_x == 1) or (direction_x == -1) ): # not 1 | direction_x not -1:
			direction_x = -1
	
	position.x += SPEED * delta * direction_x
