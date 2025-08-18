extends MarginContainer

@export var mute_button_activated_texture: Texture2D
@export var mute_button_activated_texture_pressed: Texture2D
@onready var mute_button: TextureButton = $MuteButton
var mute_button_deactivated_texture: Texture2D
var mute_button_deactivated_pressed_texture: Texture2D
var is_mute := false

func _ready() -> void:
	mute_button_deactivated_texture = mute_button.texture_normal
	mute_button_deactivated_pressed_texture = mute_button.texture_pressed
	mute_button.pressed.connect(on_mute_button_pressed)

func on_mute_button_pressed() -> void:
	is_mute = not is_mute
	if is_mute:
		mute_button.texture_normal = mute_button_activated_texture
		mute_button.texture_hover = mute_button_activated_texture_pressed
		mute_button.texture_pressed = mute_button_activated_texture_pressed
	else:
		mute_button.texture_normal = mute_button_deactivated_texture
		mute_button.texture_hover = mute_button_deactivated_pressed_texture
		mute_button.texture_pressed = mute_button_deactivated_pressed_texture
	AudioManager.mute_all_sounds()
