extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score_manager: ScoreManager = $"../GameUI/ScoreManager"
@onready var score_label: RichTextLabel = $Star/ScoreLabel
@onready var replay_button: TextureButton = $VBoxContainer/MarginContainer/ReplayButton
@onready var leaderboard_button: TextureButton = $VBoxContainer/MarginContainer2/LeaderboardButton
@onready var best_score_rect: TextureRect = $Star/BestScoreRect
@onready var http_request: HTTPRequest = $HTTPRequest

func _ready() -> void:
	replay_button.pressed.connect(on_replay_button_clicked)
	leaderboard_button.pressed.connect(on_leaderboard_button_clicked)
	Events.on_game_timer_ended.connect(on_game_ended)
	http_request.request_completed.connect(_on_request_completed)

func on_game_ended() -> void:
	PlayerData.score = score_manager.current_score
	SaveSystem.mark_as_played()
	show_best_score_rect()
	animation_player.play("show_end_screen")
	await get_tree().process_frame
	show()
	await get_tree().create_timer(1.5).timeout
	score_label.text = "[b]%d[/b]\nPTS" % score_manager.current_score

func on_replay_button_clicked() -> void:
	AudioManager.transition_to_game_music()
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.GAME)

func on_leaderboard_button_clicked() -> void:
	AudioManager.transition_to_menu_music()
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.LEADERBOARD)

func show_best_score_rect() -> void:
	if not SaveSystem.has_saved_player():
		best_score_rect.hide()
		return
	
	var body = {
		"email": SaveSystem.player_data.get("email"),
		"pseudo": SaveSystem.player_data.get("pseudo"),
		"score": score_manager.current_score,
	}
	var json = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	http_request.request("https://niseko-backend.onrender.com/check_if_highest_score", headers, HTTPClient.METHOD_POST, json)

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		if data.get("is_highest"):
			best_score_rect.show()
