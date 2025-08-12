extends Node2D

@onready var countdown_start_ui: Control = $ResponsiveLayer/CountdownStartUI
@onready var tutorial_ui: Control = $ResponsiveLayer/TutorialUI

signal on_first_part_started
signal on_second_part_started
signal on_third_part_started

func _ready() -> void:
	Events.on_tutorial_progressed.connect(on_tutorial_progressed)
	countdown_start_ui.play_start_animation()
	await get_tree().create_timer(2).timeout
	start_game()

func start_game() -> void:
	GameState.set_tutorial_mode()
	tutorial_ui.show_tutorial_pannel()

func on_tutorial_progressed() -> void:
	tutorial_ui.write_tutorial_text()
