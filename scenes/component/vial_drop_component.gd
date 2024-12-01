extends Node

@export_range(0, 1) var drop_percent: float = 0.5
@export var vial_scene: PackedScene
@export var health_component: HealthComponent

func _ready():
	health_component.died.connect(on_died)
	
func on_died():
	if randf() > drop_percent:
		return
	if vial_scene == null:
		return
	if owner is not Node2D:
		return
	
	var spawn_position = (owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	owner.get_parent().add_child(vial_instance)
	vial_instance.global_position = spawn_position
	
