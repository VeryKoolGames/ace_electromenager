extends Control

@onready var label: Label = $Label

func show_score(score_value: int) -> void:
	label.text = "+" + str(score_value)
	scale_on_spawn()

func scale_on_spawn() -> void:
	scale = Vector2.ZERO
	show()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)
