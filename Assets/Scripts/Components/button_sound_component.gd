extends Node
class_name ButtonSoundComponent

@onready var button: TextureButton = get_parent()

func _ready() -> void:
	button.mouse_entered.connect(play_hover_sound)
	button.pressed.connect(play_click_sound)

func play_hover_sound() -> void:
	if not button.disabled:
		AudioManager.play_button_hover_sound()

func play_click_sound() -> void:
	if not button.disabled:
		AudioManager.play_button_click_sound()
