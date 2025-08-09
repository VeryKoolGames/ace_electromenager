extends Control

@onready var save_button: TextureButton = $Panel/VBoxContainer/SaveButton
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var email_line_edit: LineEdit = $Panel/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/EmailLineEdit
@onready var name_line_edit: LineEdit = $Panel/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/NameLineEdit

@onready var margin_container: MarginContainer = $Panel/MarginContainer
@onready var v_box_container: VBoxContainer = $Panel/MarginContainer/VBoxContainer
@onready var label: Label = $Panel/Label
@onready var error_label: Label = $Panel/MarginContainer/VBoxContainer/ErrorLabel
@onready var panel: Panel = $Panel

var is_zoomed := false
var email: String
var pseudo: String
var original_panel_position: Vector2

func _ready() -> void:
	email_line_edit.editing_toggled.connect(zoom_on_mail_line_edit)
	name_line_edit.editing_toggled.connect(zoom_on_mail_line_edit)
	save_button.pressed.connect(on_save_button_pressed)
	http_request.request_completed.connect(_on_request_completed)
	if SaveSystem.has_saved_player():
		email_line_edit.text = SaveSystem.player_data.get("email")
		name_line_edit.text = SaveSystem.player_data.get("pseudo")
	await get_tree().process_frame
	original_panel_position = email_line_edit.position

func on_save_button_pressed() -> void:
	email = email_line_edit.text
	pseudo = name_line_edit.text
	if SaveSystem.has_saved_player() and not email and not pseudo:
		email = SaveSystem.player_data.get("email")
		pseudo = SaveSystem.player_data.get("pseudo")
	elif not email or not pseudo:
		error_label.show()
		return
	var body := {
		"email": email,
		"pseudo": pseudo,
		"score": PlayerData.score,
	}
	email_line_edit.editable = false
	name_line_edit.editable = false
	save_button.disabled = true
	var json = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	http_request.request("https://niseko-backend.onrender.com/save_player", headers, HTTPClient.METHOD_POST, json)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		margin_container.hide()
		v_box_container.hide()
		label.show()
		SaveSystem.save_player_on_disc(email, pseudo)
	else:
		save_button.disabled = false

func zoom_on_mail_line_edit(toggled_on: bool) -> void:
	if is_zoomed and not toggled_on:
		return
	var tween = create_tween()
	if toggled_on:
		is_zoomed = true
		var move_up = 0
		var move_center = get_viewport().size.x / 2 - panel.size.x / 2
		tween.tween_property(panel, "global_position", Vector2(move_center, move_up), 0.3)
	else:
		is_zoomed = false
		tween.tween_property(panel, "position", original_panel_position, 0.3)
