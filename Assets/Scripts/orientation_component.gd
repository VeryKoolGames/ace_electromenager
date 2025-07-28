extends Node


func _ready():
	OrientationManager.orientation_changed.connect(_on_orientation_changed)

func _on_orientation_changed(is_portrait: bool):
	if is_portrait:
		_setup_portrait_layout()
	else:
		_setup_landscape_layout()
		
func _setup_portrait_layout():
	var new_resolution = Vector2(1080, 1920)
	get_viewport().size = new_resolution
	get_window().size = new_resolution
	get_parent().custom_minimum_size = Vector2(1080, 1920)

func _setup_landscape_layout():
	get_viewport().size = Vector2(1920, 1080)
	get_parent().custom_minimum_size = Vector2(1920, 1080)
