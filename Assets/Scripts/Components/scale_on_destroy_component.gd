extends Node
class_name ScaleOnDestroyComponent

@onready var target: Node = get_parent()
@export_range(0.1, 1) var scale_factor: float
@export_range(0.01, 1) var size_increase_speed: float = 0.05
@export_range(0.1, 1) var size_decrease_speed: float = 0.1

func destroy() -> void:
	var tween = create_tween()
	tween.tween_property(target, "scale", target.scale + Vector2(scale_factor, scale_factor), size_increase_speed)
	tween.tween_property(target, "scale", Vector2.ZERO, size_decrease_speed)
	tween.tween_callback(func(): target.queue_free())
