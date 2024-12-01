extends Node
class_name HealthComponent

signal died

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health

func damage(damageAmount: float):
	# don't let health go negative
	current_health = max(current_health - damageAmount, 0)
	# forces to wait for next idle frame before calling the function
	# since collisions may be happening on the thing we're trying to free
	Callable(check_death).call_deferred()

		
func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
	
