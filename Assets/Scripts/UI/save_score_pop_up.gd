extends Control

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var name_line_edit: LineEdit = $Panel/ScrollContainer/VBoxContainer/MarginContainer2/HBoxContainer/NameLineEdit
@onready var email_line_edit: LineEdit = $Panel/ScrollContainer/VBoxContainer/MarginContainer2/HBoxContainer/EmailLineEdit

@onready var margin_container: ScrollContainer = $Panel/ScrollContainer
@onready var label: Label = $Panel/Label
@onready var error_label: Label = $Panel/ScrollContainer/VBoxContainer/ErrorLabel
@onready var panel: Panel = $Panel
@onready var save_button: TextureButton = $Panel/ScrollContainer/VBoxContainer/VBoxContainer/SaveButton

var is_zoomed := false
var email: String
var pseudo: String
var original_panel_position: Vector2

func _ready() -> void:
	if OS.get_name() == "iOS" or OS.get_name() == "Android":
		email_line_edit.editing_toggled.connect(zoom_on_mail_line_edit)
		name_line_edit.editing_toggled.connect(zoom_on_mail_line_edit)
		email_line_edit.text_submitted.connect(unzoom_line_edit)
		name_line_edit.text_submitted.connect(unzoom_line_edit)
	save_button.pressed.connect(on_save_button_pressed)
	http_request.request_completed.connect(_on_request_completed)
	if SaveSystem.has_saved_player():
		email_line_edit.text = SaveSystem.player_data.get("email")
		name_line_edit.text = SaveSystem.player_data.get("pseudo")
	await get_tree().process_frame
	original_panel_position = panel.global_position

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

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		margin_container.hide()
		label.show()
		SaveSystem.save_player_on_disc(email, pseudo)
	else:
		save_button.disabled = false

func zoom_on_mail_line_edit(toggled_on: bool) -> void:
	if is_zoomed and not toggled_on:
		return
	if toggled_on:
		var tween = create_tween()
		is_zoomed = true
		var move_up = -20
		var move_center = get_viewport().size.x / 2 - panel.size.x / 2
		tween.tween_property(panel, "global_position", Vector2(move_center, move_up), 0.3)

func unzoom_line_edit(_new_text: String) -> void:
	var tween = create_tween()
	tween.tween_property(panel, "global_position", original_panel_position, 0.3)
