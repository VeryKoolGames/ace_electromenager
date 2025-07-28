extends Node

signal orientation_changed(is_portrait: bool)

var current_orientation: bool = false
var aspect_ratio_threshold: float = 1.0

func _ready():
	get_window().size_changed.connect(_on_viewport_size_changed)
	_check_orientation()

func _on_viewport_size_changed():
	_check_orientation()

func _check_orientation():
	var viewport_size = get_window().get_size_with_decorations()
	var aspect_ratio = viewport_size.x / viewport_size.y
	var is_portrait = aspect_ratio < aspect_ratio_threshold
	
	if is_portrait != current_orientation:
		current_orientation = is_portrait
		orientation_changed.emit(is_portrait)
