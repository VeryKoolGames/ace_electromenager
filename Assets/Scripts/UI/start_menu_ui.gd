extends Control

@onready var start_button: TextureButton = $VBoxContainer/StartButton
@onready var leaderboard_button: TextureButton = $VBoxContainer/LeaderboardButton

func _ready() -> void:
	start_button.pressed.connect(transition_to_game_scene)
	leaderboard_button.pressed.connect(transition_to_leaderboard_scene)

func transition_to_game_scene() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.GAME)

func transition_to_leaderboard_scene() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.LEADERBOARD)
