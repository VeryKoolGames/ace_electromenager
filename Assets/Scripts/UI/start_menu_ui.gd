extends Control

@onready var start_button: TextureButton = $VBoxContainer/StartButton
@onready var leaderboard_button: TextureButton = $VBoxContainer/LeaderboardButton
@onready var tutorial_button: TextureButton = $HBoxContainer/TutorialContainer/TutorialButton
@onready var tutorial_container: MarginContainer = $HBoxContainer/TutorialContainer

func _ready() -> void:
	start_button.pressed.connect(transition_to_game_scene)
	leaderboard_button.pressed.connect(transition_to_leaderboard_scene)
	tutorial_button.pressed.connect(transition_to_tutorial_scene)
	show_or_hide_tutorial_button()

func transition_to_game_scene() -> void:
	disable_buttons()
	if SaveSystem.is_playing_for_the_first_time:
		TransitionManager.play_transition(TransitionManager.MainScenesEnum.TUTORIAL)
	else:
		TransitionManager.play_transition(TransitionManager.MainScenesEnum.GAME)
		AudioManager.transition_to_game_music()

func transition_to_leaderboard_scene() -> void:
	disable_buttons()
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.LEADERBOARD)

func transition_to_tutorial_scene() -> void:
	disable_buttons()
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.TUTORIAL)

func show_or_hide_tutorial_button() -> void:
	if not SaveSystem.is_playing_for_the_first_time:
		tutorial_container.show()
	else:
		tutorial_container.hide()

func disable_buttons() -> void:
	start_button.disabled = true
	leaderboard_button.disabled = true
	tutorial_button.disabled = true
