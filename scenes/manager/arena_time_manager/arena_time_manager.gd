extends Node
class_name ArenaTimer

@onready var timer = $Timer

func get_time_elapsed():
	return timer.wait_time - timer.time_left
