extends Node

# Player data structure
var player_data = {
	"player_token": "",
	"pseudo": "",
}

var is_playing_for_the_first_time := true

const SAVE_FILE_PATH = "user://player_data.save"
const FIRST_TIME_FLAG_PATH = "user://first_time_flag.save"

func _ready():
	print(player_data)
	load_first_time_flag()
	load_player_from_disc()

func save_player_on_disc(token: String, pseudo: String):
	player_data.player_token = token
	player_data.pseudo = pseudo
	
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file == null:
		return false
	
	var json_string = JSON.stringify(player_data)
	save_file.store_string(json_string)
	save_file.close()
	
	return true

func load_player_from_disc():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("No save file found - new player")
		return false
	
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if save_file == null:
		print("Error: Could not open save file")
		return false
	
	var json_string = save_file.get_as_text()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Error: Could not parse save file")
		return false
	
	var loaded_data = json.data
	if loaded_data.has("player_token") and loaded_data.has("pseudo"):
		player_data = loaded_data
		return true
	else:
		print("Error: Invalid save file format")
		return false

func get_player_data():
	return player_data

func has_saved_player():
	return FileAccess.file_exists(SAVE_FILE_PATH) and player_data.player_token != "" and player_data.pseudo != ""

func clear_player_data():
	player_data.pseudo = ""
	player_data.player_token = ""
	
	if FileAccess.file_exists(SAVE_FILE_PATH):
		DirAccess.remove_absolute(SAVE_FILE_PATH)

func load_first_time_flag():
	if not FileAccess.file_exists(FIRST_TIME_FLAG_PATH):
		is_playing_for_the_first_time = true
		return false
	
	var save_file = FileAccess.open(FIRST_TIME_FLAG_PATH, FileAccess.READ)
	if save_file == null:
		is_playing_for_the_first_time = true
		return false
	
	var json_string = save_file.get_as_text()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		is_playing_for_the_first_time = true
		return false
	
	var loaded_data = json.data
	if loaded_data.has("is_playing_for_the_first_time"):
		is_playing_for_the_first_time = loaded_data.is_playing_for_the_first_time
		return true
	else:
		is_playing_for_the_first_time = true
		return false

func save_first_time_flag():
	var flag_data = {"is_playing_for_the_first_time": is_playing_for_the_first_time}
	
	var save_file = FileAccess.open(FIRST_TIME_FLAG_PATH, FileAccess.WRITE)
	if save_file == null:
		return false
	
	var json_string = JSON.stringify(flag_data)
	save_file.store_string(json_string)
	save_file.close()
	
	return true

func mark_as_played():
	"""Call this when the player starts playing (regardless of login status)"""
	if is_playing_for_the_first_time:
		is_playing_for_the_first_time = false
		save_first_time_flag()
