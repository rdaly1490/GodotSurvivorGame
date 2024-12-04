extends Node

@export var sword_ability: PackedScene

const MAX_RANGE = 150

var damage = 5
var base_wait_time


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if player == null:
		return
		
	# filter out all enemies > 150px away from the player
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	# sort by closest to player
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_comonent.damage = damage
	
	var closest_enemy = enemies[0] as Node2D
	
	# attack closest enemy
	sword_instance.global_position = closest_enemy.global_position
	
	# we need to offset the sword position slighly instead of spawning it directly on the enemy, we instead spawn it
	# randomly somewhere within a circle around the enemy.  With this offset, we can have the sword rotate to face the target
	# since roatation is in radians we use TAU which is 2pi (360 degrees)
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	# in vector math, the direction you want the thing to point at should come first
	var enemey_direction = closest_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemey_direction.angle()
	
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * upgrade.percent_increase
	$Timer.wait_time = base_wait_time * (1 - percent_reduction)
	# need to restart the timer with the new wait time for it to take effect
	$Timer.start()
