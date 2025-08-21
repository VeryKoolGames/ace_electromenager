extends Control

@onready var panel_container: PanelContainer = $PanelContainer
@onready var delete_data_button: TextureButton = $PanelContainer/DeleteDataButton
@onready var back_button: TextureButton = $PanelContainer/BackButton
@onready var confirmation_container: MarginContainer = $PanelContainer/ConfirmationContainer
@onready var confirmation_pop_up: ConfirmationPopUpUI = $ConfirmationPopUp
@onready var conf_button: TextureButton = $"../HBoxContainer/TextureButton"

func _ready() -> void:
	conf_button.pressed.connect(show_conf_menu)
	delete_data_button.pressed.connect(show_pop_up)
	back_button.pressed.connect(hide_conf_menu)

func show_conf_menu() -> void:
	display_delete_data_button()
	var tween = create_tween()
	panel_container.scale = Vector2.ZERO
	panel_container.show()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.2)

func display_delete_data_button() -> void:
	if SaveSystem.has_saved_player():
		delete_data_button.show()
	else:
		delete_data_button.hide()

func hide_conf_menu() -> void:
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(func(): panel_container.hide())

func show_pop_up() -> void:
	confirmation_pop_up.show_conf_menu()
