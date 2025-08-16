extends Node
class_name ScaleOnSpawnComponent

@onready var target: Node = get_parent()
@export_range(0.1, 1) var scale_factor: float
@export_range(0.01, 1) var spawn_speed: float = 0.05
@export_range(0.1, 1) var size_decrease_speed: float = 0.2
@export var delay := 0.0

func _ready() -> void:
	target.scale = Vector2.ZERO
	if delay != 0:
		await get_tree().create_timer(delay).timeout
	scale_on_spawn()

func scale_on_spawn() -> void:
	var tween = create_tween()
	tween.tween_property(target, "scale", Vector2.ONE + Vector2(scale_factor, scale_factor), spawn_speed)
	tween.tween_property(target, "scale", Vector2.ONE, size_decrease_speed)
