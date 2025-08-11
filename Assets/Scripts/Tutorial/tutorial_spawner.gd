extends Node2D

@export var fridge_scene: PackedScene
@export var spawn_position: Node2D

func _ready() -> void:
	Events.on_game_started.connect(spawn_fridge)


func spawn_fridge() -> void:
	var fridge = fridge_scene.instantiate()
	spawn_position.add_child(fridge)
