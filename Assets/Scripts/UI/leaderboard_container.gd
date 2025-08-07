extends Control

@onready var http_request: HTTPRequest = $HTTPRequest
@export var leaderboard_line_scene: PackedScene
@onready var leaderboard_line_container: VBoxContainer = $ScoreScrollSpace/LeaderboardLineContainer
@onready var no_score_label: Label = $NoScoreLabel

func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)
	_retrieve_player_scores_data()

func _process_players_data(data: Array) -> void:
	if data.is_empty():
		no_score_label.show()
	for index in range(0, data.size()):
		var line = leaderboard_line_scene.instantiate() as LeaderboardLine
		var line_data = ResLeaderboardLine.new(data[index].get("pseudo"), index + 1, data[index].get("highest_score"))
		leaderboard_line_container.add_child(line)
		line.populate_line(line_data)

func _retrieve_global_scores_data() -> void:
	http_request.request("https://niseko-backend.onrender.com/get_all_scores")

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		_process_players_data(data)

func _retrieve_player_scores_data() -> void:
	http_request.request("https://niseko-backend.onrender.com/get_all_players")
