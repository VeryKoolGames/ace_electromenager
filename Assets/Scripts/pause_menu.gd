extends Control

var is_paused: bool = false
@onready var margin_container: MarginContainer = $MarginContainer
@onready var pause_button: TextureButton = $MarginContainer/PauseButton
@onready var control: Control = $Control
@onready var quit_button: TextureButton = $Control/QuitButton
var is_mouse_on_button := false
@onready var mute_button_container: TextureButton = $Control/MuteButtonContainer/MuteButton


func _ready() -> void:
	quit_button.pressed.connect(on_quit_button_pressed)
	quit_button.mouse_entered.connect(on_mouse_on_button)
	quit_button.mouse_exited.connect(on_mouse_on_button)
	mute_button_container.mouse_entered.connect(on_mouse_on_button)
	mute_button_container.mouse_exited.connect(on_mouse_on_button)
	pause_button.pressed.connect(toggle_pause)
	Events.on_game_started.connect(func(): margin_container.show())

func on_mouse_on_button() -> void:
	is_mouse_on_button = not is_mouse_on_button

func _input(event):
	if not is_paused or is_mouse_on_button:
		return
	if event is InputEventScreenTouch and event.is_pressed():
		toggle_pause()
	elif event is InputEventMouseButton and event.is_pressed():
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	control.visible = is_paused
	get_tree().paused = is_paused
	if is_paused:
		GameState.set_pause_mode()
		self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		get_viewport().set_input_as_handled()
	else:
		GameState.set_game_mode_after_pause()
		self.process_mode = Node.PROCESS_MODE_INHERIT

func on_quit_button_pressed() -> void:
	get_tree().paused = false
	AudioManager.transition_to_menu_music()
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.START)
