extends Control

var is_paused: bool = false
@onready var margin_container: MarginContainer = $MarginContainer
@onready var pause_button: TextureButton = $MarginContainer/PauseButton
@onready var control: Control = $Control

func _ready() -> void:
	pause_button.pressed.connect(toggle_pause)
	Events.on_game_started.connect(func(): margin_container.show())

func _input(event):
	if not is_paused:
		return
	if event is InputEventScreenTouch and event.is_released():
		toggle_pause()
	elif event is InputEventMouseButton and event.is_released():
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	control.visible = is_paused
	get_tree().paused = is_paused
	if is_paused:
		self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		get_viewport().set_input_as_handled()
	else:
		self.process_mode = Node.PROCESS_MODE_INHERIT
