extends Area2D

@onready var timer: Timer = $Timer

# Think about whether to call game manager at all here.
@onready var game_manager: Node = $"../../../GameManager"
# Makes sure the timer is not reset over and over if a killzone is re-entered faster than the timer can end.
# This can happen if one mob walks over the dead player over and over or when many mobs are walking over the dead player.
var one_timer = false

func _on_timer_timeout() -> void:
	one_timer = false
	game_manager.reset_scene()

func _on_body_entered(body: Node2D) -> void:
	if !one_timer:
		Engine.time_scale = 0.5

		# Make this run only when body is the player.
		# Or make it so all moveable bodies have handle_death()
		body.handle_death()
		timer.start()
		
		one_timer = true
