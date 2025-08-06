extends Control

@onready var save_button: Button = $Panel/VBoxContainer/SaveButton
@onready var cancel_button: Button = $Panel/VBoxContainer/CancelButton
@onready var email_line_edit: LineEdit = $Panel/MarginContainer/VBoxContainer/HBoxContainer/EmailLineEdit
@onready var name_line_edit: LineEdit = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/NameLineEdit
@onready var http_request: HTTPRequest = $HTTPRequest

@onready var margin_container: MarginContainer = $Panel/MarginContainer
@onready var v_box_container: VBoxContainer = $Panel/VBoxContainer
@onready var label: Label = $Panel/Label
@onready var error_label: Label = $Panel/MarginContainer/VBoxContainer/ErrorLabel
@onready var already_registered_label: Label = $Panel/AlreadyRegisteredLabel

var email: String
var pseudo: String

func _ready() -> void:
	save_button.pressed.connect(on_save_button_pressed)
	cancel_button.pressed.connect(on_cancel_button_pressed)
	http_request.request_completed.connect(_on_request_completed)
	if SaveSystem.has_saved_player():
		show_already_registered_screen()

func show_already_registered_screen() -> void:
	margin_container.hide()
	already_registered_label.text = "Tu es deja enregistré en tant que " + SaveSystem.player_data.get("pseudo") + " tu peux enregistrer ton score ou créer un nouveau pseudo"
	already_registered_label.show()

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
		already_registered_label.hide()
		SaveSystem.save_player_on_disc(email, pseudo)

func on_cancel_button_pressed() -> void:
	queue_free()
