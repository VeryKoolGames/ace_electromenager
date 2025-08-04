extends Node

var has_scored_recently := false
var current_score := 0
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	Events.on_player_scored.connect(on_score_received)

func on_score_received(score_value: int) -> void:
	current_score += score_value
	score_label.text = str(current_score)
	
	# TODO Should equilibrate this value right now it is always 1
	var intensity = clamp(score_value / 10.0, 1.0, 2.0)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

	tween.tween_property(score_label, "scale", Vector2(1.2, 1.2) * intensity, 0.1)

	tween.tween_property(score_label, "rotation_degrees", randf_range(-10, 10) * intensity, 0.05)
	tween.tween_property(score_label, "rotation_degrees", 0, 0.05)

	tween.tween_property(score_label, "scale", Vector2.ONE, 0.1)
