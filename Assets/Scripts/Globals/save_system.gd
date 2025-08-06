extends Node

# Player data structure
var player_data = {
	"email": "",
	"pseudo": "",
	"save_date": ""
}

# File path for saving player data
const SAVE_FILE_PATH = "user://player_data.save"

# Called when the node enters the scene tree for the first time
func _ready():
	# Try to load existing player data when the game starts
	load_player_from_disc()

func save_player_on_disc(email: String, pseudo: String):
	player_data.email = email
	player_data.pseudo = pseudo
	player_data.save_date = Time.get_datetime_string_from_system()
	
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file == null:
		print("Error: Could not create save file")
		return false
	
	var json_string = JSON.stringify(player_data)
	save_file.store_string(json_string)
	save_file.close()
	
	print("Player data saved successfully!")
	print("Email: ", email, " | Pseudo: ", pseudo)
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
	
	# Load the data
	var loaded_data = json.data
	if loaded_data.has("email") and loaded_data.has("pseudo"):
		player_data = loaded_data
		print("Player data loaded successfully!")
		print("Email: ", player_data.email, " | Pseudo: ", player_data.pseudo)
		print("Last saved: ", player_data.get("save_date", "Unknown"))
		return true
	else:
		print("Error: Invalid save file format")
		return false

# Get current player data
func get_player_data():
	return player_data

func has_saved_player():
	return FileAccess.file_exists(SAVE_FILE_PATH) and player_data.email != "" and player_data.pseudo != ""

# Clear player data (for logout/reset)
func clear_player_data():
	player_data.email = ""
	player_data.pseudo = ""
	player_data.save_date = ""
	
	# Optionally delete the save file
	if FileAccess.file_exists(SAVE_FILE_PATH):
		DirAccess.remove_absolute(SAVE_FILE_PATH)
		print("Player data cleared")
