extends Control
class_name ConfirmationPopUpUI

@onready var panel_container: PanelContainer = $PanelContainer
@onready var yes_button: TextureButton = $PanelContainer/VBoxContainer/HBoxContainer/YesButton
@onready var no_button: TextureButton = $PanelContainer/VBoxContainer/HBoxContainer/NoButton
@onready var color_rect: ColorRect = $ColorRect
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var confirmation_container: MarginContainer = $"../PanelContainer/ConfirmationContainer"
@onready var delete_data_button: TextureButton = $"../PanelContainer/DeleteDataButton"

func _ready() -> void:
	no_button.pressed.connect(hide_conf_menu)
	http_request.request_completed.connect(_on_request_completed)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		hide_conf_menu()
		delete_data_button.hide()
		confirmation_container.show()
		var data = JSON.parse_string(body.get_string_from_utf8())

func show_conf_menu() -> void:
	color_rect.show()
	var tween = create_tween()
	panel_container.scale = Vector2.ZERO
	panel_container.show()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.2)

func hide_conf_menu() -> void:
	color_rect.hide()
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(func(): panel_container.hide())

func delete_player_data() -> void:
	yes_button.disabled = true
	var token = SaveSystem.player_data.get("player_token")
	var body := {
		"player_token": token,
	}
	var json = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	http_request.request("https://niseko-backend.onrender.com/delete_me", headers, HTTPClient.METHOD_POST, json)
