extends Control

@onready var start_button: TextureButton = $VBoxContainer/StartButton
@onready var leaderboard_button: TextureButton = $VBoxContainer/LeaderboardButton
@onready var tutorial_container: MarginContainer = $TutorialContainer
@onready var tutorial_button: TextureButton = $TutorialContainer/TutorialButton
@onready var mute_button: TextureButton = $Mute/MuteButton

func _ready() -> void:
	mute_button.pressed.connect(on_mute_button_pressed)
	start_button.pressed.connect(transition_to_game_scene)
	leaderboard_button.pressed.connect(transition_to_leaderboard_scene)
	tutorial_button.pressed.connect(transition_to_tutorial_scene)
	show_or_hide_tutorial_button()

func transition_to_game_scene() -> void:
	if SaveSystem.is_playing_for_the_first_time:
		TransitionManager.play_transition(TransitionManager.MainScenesEnum.TUTORIAL)
	else:
		TransitionManager.play_transition(TransitionManager.MainScenesEnum.GAME)
		AudioManager.transition_to_game_music()

func transition_to_leaderboard_scene() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.LEADERBOARD)

func transition_to_tutorial_scene() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.TUTORIAL)

func show_or_hide_tutorial_button() -> void:
	if not SaveSystem.is_playing_for_the_first_time:
		tutorial_container.show()
	else:
		tutorial_container.hide()

func on_mute_button_pressed() -> void:
	AudioManager.mute_all_sounds()
