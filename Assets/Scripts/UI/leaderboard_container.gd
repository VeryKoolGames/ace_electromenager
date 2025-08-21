extends Control

@onready var http_request: HTTPRequest = $HTTPRequest
@export var leaderboard_line_scene: PackedScene
@export var self_leaderboard_line_scene: PackedScene
@onready var leaderboard_line_container: VBoxContainer = $ScoreScrollSpace/LeaderboardLineContainer
@onready var no_score_label: Label = $NoScoreLabel
@onready var loading_label: Label = $LoadingLabel
@onready var error_label: Label = $ErrorLabel

func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)
	_retrieve_player_scores_data()

func _process_players_data(data: Array) -> void:
	if data.is_empty():
		no_score_label.show()
	for index in range(0, data.size()):
		var line: LeaderboardLine
		if not check_if_self(data[index]):
			line = leaderboard_line_scene.instantiate() as LeaderboardLine
		else:
			line = self_leaderboard_line_scene.instantiate() as LeaderboardLine
		var line_data = ResLeaderboardLine.new(data[index].get("pseudo"), index + 1, data[index].get("score"))
		leaderboard_line_container.add_child(line)
		line.populate_line(line_data)

func _on_request_completed(result, response_code, headers, body):
	loading_label.hide()
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		_process_players_data(data)
	else:
		error_label.show()

func _retrieve_player_scores_data() -> void:
	loading_label.show()
	var body := {}
	if SaveSystem.has_saved_player():
		body["player_token"] = SaveSystem.player_data.get("player_token")
	var json = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	http_request.request("https://niseko-backend.onrender.com/get_leaderboard", headers, HTTPClient.METHOD_POST, json)

func check_if_self(data: Dictionary) -> bool:
	return data.get("is_self") == true
