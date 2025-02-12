extends Area2D

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1.0
	# Func that toggles bool that unblocks input

func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.5
	
	# Body refers to the player in this case.
	# Remove the collider so it looks cool I guess.
	body.get_node("CollisionShape2D").queue_free()
	
	body.block_inputs()
	timer.start()
