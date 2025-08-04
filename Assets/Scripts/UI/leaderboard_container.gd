extends Control

@onready var http_request: HTTPRequest = $HTTPRequest

func _process_players_data(data: Array) -> void:
	pass

func _retrieve_global_scores_data() -> void:
	http_request.request("https://niseko-backend.onrender.com/get_all_scores")

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		_process_players_data(data)

func _retrieve_player_scores_data() -> void:
	http_request.request("https://niseko-backend.onrender.com/get_all_characters")
