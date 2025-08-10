extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score_manager: ScoreManager = $"../GameUI/ScoreManager"
@onready var score_label: RichTextLabel = $Star/ScoreLabel
@onready var replay_button: TextureButton = $VBoxContainer/MarginContainer/ReplayButton
@onready var leaderboard_button: TextureButton = $VBoxContainer/MarginContainer2/LeaderboardButton

func _ready() -> void:
	replay_button.pressed.connect(on_replay_button_clicked)
	leaderboard_button.pressed.connect(on_leaderboard_button_clicked)
	Events.on_game_timer_ended.connect(on_game_ended)

func on_game_ended() -> void:
	PlayerData.score = score_manager.current_score
	animation_player.play("show_end_screen")
	await get_tree().process_frame
	show()
	await get_tree().create_timer(1.5).timeout
	score_label.text = "[b]%d[/b]\nPTS" % score_manager.current_score

func on_replay_button_clicked() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.GAME)

func on_leaderboard_button_clicked() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.LEADERBOARD)
