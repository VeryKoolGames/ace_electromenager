extends Node2D

@onready var countdown_start_ui: Control = $ResponsiveLayer/CountdownStartUI

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	countdown_start_ui.play_start_animation()
	await get_tree().create_timer(2).timeout
	start_game()

func start_game() -> void:
	GameState.set_game_mode()
	Events.on_game_started.emit()
