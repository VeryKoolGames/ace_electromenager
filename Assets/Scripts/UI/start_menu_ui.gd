extends Control

@onready var start_button: TextureButton = $VBoxContainer/StartButton
@onready var leaderboard_button: TextureButton = $VBoxContainer/LeaderboardButton
@onready var tutorial_container: MarginContainer = $TutorialContainer
@onready var tutorial_button: TextureButton = $TutorialContainer/TutorialButton

func _ready() -> void:
	start_button.pressed.connect(transition_to_game_scene)
	leaderboard_button.pressed.connect(transition_to_leaderboard_scene)
	tutorial_button.pressed.connect(transition_to_tutorial_scene)
	show_or_hide_tutorial_button()

func transition_to_game_scene() -> void:
	if not SaveSystem.has_saved_player():
		TransitionManager.play_transition(TransitionManager.MainScenesEnum.TUTORIAL)
	else:
		TransitionManager.play_transition(TransitionManager.MainScenesEnum.GAME)

func transition_to_leaderboard_scene() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.LEADERBOARD)

func transition_to_tutorial_scene() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.TUTORIAL)

func show_or_hide_tutorial_button() -> void:
	if SaveSystem.has_saved_player():
		tutorial_container.show()
