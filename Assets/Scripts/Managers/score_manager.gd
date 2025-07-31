extends Node

var has_scored_recently := false
var current_score := 0
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	Events.on_player_scored.connect(on_score_received)

func on_score_received(score_value: int) -> void:
	current_score += score_value
	score_label.text = str(current_score)
