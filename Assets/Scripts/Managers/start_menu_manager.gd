extends CanvasLayer


func _ready() -> void:
	if SaveSystem.has_saved_player():
		get_tree().change_scene_to_file("res://Assets/Scenes/Main/tutorial.tscn")
