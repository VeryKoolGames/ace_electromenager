extends Node
class_name ScaleDownOnGameEnd

@onready var target = get_parent()

func _ready() -> void:
	Events.on_game_timer_ended.connect(scale_down_parent)

func scale_down_parent() -> void:
	var tween = create_tween()
	tween.tween_property(target, "scale", Vector2.ZERO, 0.2)
