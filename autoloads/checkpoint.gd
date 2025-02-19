extends Node

var last_position = null #Vector2(31,-22)

# Idea here is to set the last position to the checkpoint we just 
	# passed thru and then add it to positions.
# If you pass thru it again it won't set the checkpoint to that one.
# On reload, every checkpoint checks if it's in positions and automatically
	# sets itself to the red colors animation.
#const positions = {'one': 1, "two": 2}

func set_last_position(pos):
	last_position = pos
