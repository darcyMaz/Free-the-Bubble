extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	pass
	# Check if this has been passed thru before and set to hero in wind if it has.

func _on_body_entered(_body: Node2D) -> void:
	
	Checkpoint.set_last_position(global_position)
	animated_sprite.play("hero-in-wind")
