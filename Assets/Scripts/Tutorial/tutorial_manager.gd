extends Node2D
class_name Tutorial

@onready var countdown_start_ui: Control = $ResponsiveLayer/CountdownStartUI
@onready var tutorial_ui: Control = $ResponsiveLayer/TutorialUI
@onready var back_button: TextureButton = $ResponsiveLayer/TutorialUI/BackButtonContainer/BackButton
@onready var back_button_container: MarginContainer = $ResponsiveLayer/TutorialUI/BackButtonContainer

signal on_first_part_started
signal on_second_part_started
signal on_third_part_started
signal on_fourth_part_started

var is_tutorial = true

func _ready() -> void:
	Events.on_tutorial_progressed.connect(on_tutorial_progressed)
	on_third_part_started.connect(on_tutorial_ended)
	back_button.pressed.connect(on_back_button_pressed)
	await get_tree().create_timer(2).timeout
	countdown_start_ui.play_start_animation()
	await get_tree().create_timer(0.9).timeout
	AudioManager.play_whistle_sound()
	await get_tree().create_timer(2).timeout
	start_game()
	SaveSystem.mark_as_played()

func start_game() -> void:
	GameState.set_tutorial_mode()
	Events.on_game_started.emit()
	tutorial_ui.show_tutorial_pannel()

func on_tutorial_progressed() -> void:
	tutorial_ui.move_to_next_tutorial_step()

func on_tutorial_ended() -> void:
	var tween = create_tween()
	back_button_container.scale = Vector2.ZERO
	back_button_container.show()
	tween.tween_property(back_button_container, "scale", Vector2.ONE, 0.2)

func on_back_button_pressed() -> void:
	AudioManager.stop_ref_long_talk()
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.START)
