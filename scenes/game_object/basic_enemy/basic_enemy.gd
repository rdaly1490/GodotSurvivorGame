extends CharacterBody2D

const MAX_SPEED = 40

@onready var health_component: HealthComponent = $HealthComponent


func _process(delta: float) -> void:
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()
	
	
func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		var entity_position = global_position
		return (player_node.global_position - entity_position).normalized()
	return Vector2.ZERO
