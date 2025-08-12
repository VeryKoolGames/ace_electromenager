extends Node2D

@export var fridge_scene: PackedScene
@export var power_up_scene: PackedScene
@export var spawn_position: Node2D
@export var power_up_spawn_position: Node2D

func _ready() -> void:
	owner.on_first_part_started.connect(spawn_fridge)
	owner.on_second_part_started.connect(spawn_power_up)

func spawn_fridge() -> void:
	var fridge = fridge_scene.instantiate()
	spawn_position.add_child(fridge)

func spawn_power_up() -> void:
	var power_up = power_up_scene.instantiate()
	power_up_spawn_position.add_child(power_up)
