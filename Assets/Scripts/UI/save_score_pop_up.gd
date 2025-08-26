extends Control

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var name_line_edit: LineEdit = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/NameLineEdit
@onready var email_line_edit: LineEdit = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/EmailLineEdit

@onready var v_box_container: VBoxContainer = $Panel/VBoxContainer
@onready var score_saved_label: Label = $"Panel/ScoreEnregistré"
@onready var panel: Panel = $Panel
@onready var save_button: TextureButton = $Panel/VBoxContainer/VBoxContainer/SaveButton
@onready var animation_player: AnimationPlayer = $Panel/ScoreEnregistré/AnimationPlayer
@onready var error_label: Label = $Panel/ErrorLabel
@onready var legal_label: Label = $Panel/LegalLabel
@onready var already_saved_request: HTTPRequest = $AlreadySavedRequest
@onready var name_button: TextureButton = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/NameLineEdit/NameButton
@onready var email_button: TextureButton = $Panel/VBoxContainer/MarginContainer2/HBoxContainer/EmailLineEdit/EmailButton

var is_zoomed := false
var email: String
var pseudo: String
var original_panel_position: Vector2

const JS_MODAL := """
if (!window.gdModal) {
	window.gdModal = async ({label='', type='text', placeholder='', initial=''}) => {
		return await new Promise((resolve) => {
			const o = document.createElement('div');
			o.style = 'position:fixed;inset:0;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,.45);z-index:99999;';
			const b = document.createElement('div');
			b.style = 'width:min(92vw,440px);background:#111;border-radius:16px;padding:16px;box-shadow:0 10px 30px rgba(0,0,0,.6);color:#fff;font:16px system-ui, -apple-system, Roboto, Segoe UI, sans-serif;';
			const t = document.createElement('div');
			t.textContent = label; t.style = 'opacity:.9;margin:2px 2px 10px';
			const i = document.createElement('input');
			i.type = (type === 'password') ? 'password' : (type === 'email' ? 'email' : 'text');
			i.inputMode = (type === 'email') ? 'email' : 'text';
			i.autocomplete = (type === 'email') ? 'email' : 'off';
			i.spellcheck = false; i.autocapitalize = 'none'; i.autocorrect = 'off';
			i.value = initial; i.placeholder = placeholder;
			i.style = 'box-sizing:border-box;display:block;width:100%;max-width:100%;min-width:0;font-size:16px;padding:12px;border-radius:12px;border:1px solid #2a2a2a;background:#1a1a1a;color:#fff;outline:none;';
			const row = document.createElement('div');
			row.style = 'display:flex;gap:8px;justify-content:flex-end;margin-top:14px;';
			const cancel = document.createElement('button'); cancel.textContent = 'Annuler';
			const ok = document.createElement('button'); ok.textContent = 'OK';
			for (const btn of [cancel, ok]) btn.style = 'font-size:14px;padding:10px 14px;border-radius:12px;border:0;background:#2a2a2a;color:#fff';
			ok.style.background = '#3a66ff';
			cancel.onclick = () => { o.remove(); resolve({ok:false, text:''}); };
			ok.onclick = () => { const v = i.value || ''; o.remove(); resolve({ok:true, text:v}); };
			i.addEventListener('keydown', (e)=>{ if (e.key==='Enter') ok.click(); if (e.key==='Escape') cancel.click(); });
			b.append(t,i,row); row.append(cancel, ok); o.append(b); document.body.append(o);
			setTimeout(()=>{ i.focus(); i.select(); }, 30);
	});
	};
}
"""

func _ready() -> void:
	if OS.get_name() == "iOS" or OS.get_name() == "Android":
		email_line_edit.editing_toggled.connect(zoom_on_mail_line_edit)
		name_line_edit.editing_toggled.connect(zoom_on_mail_line_edit)
		email_line_edit.text_submitted.connect(unzoom_line_edit)
		name_line_edit.text_submitted.connect(unzoom_line_edit)
	save_button.pressed.connect(on_save_button_pressed)
	http_request.request_completed.connect(_on_request_completed)
	already_saved_request.request_completed.connect(_on_request_already_saved_completed)
	if SaveSystem.has_saved_player():
		email_line_edit.text = SaveSystem.player_data.get("email")
		name_line_edit.text = SaveSystem.player_data.get("pseudo")
	await get_tree().process_frame
	original_panel_position = panel.global_position
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		JavaScriptBridge.eval(JS_MODAL)
		name_button.pressed.connect(on_name_mouse_button_clicked)
		email_button.pressed.connect(on_mail_mouse_button_clicked)
	else:
		name_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		email_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _html_prompt(label:String, type:String, placeholder:String, initial:String):
	JavaScriptBridge.eval("(async()=>{ window.__gdRes = await window.gdModal({label:%s,type:%s,placeholder:%s,initial:%s}); })();" % [
		JSON.stringify(label), JSON.stringify(type), JSON.stringify(placeholder), JSON.stringify(initial)
	])
	while true:
		var done = JavaScriptBridge.eval("window.__gdRes ? 1 : 0")
		if int(done) == 1:
			var r = JavaScriptBridge.eval("JSON.stringify(window.__gdRes)")
			JavaScriptBridge.eval("window.__gdRes = null")
			return JSON.parse_string(str(r))
		await get_tree().process_frame

func on_name_mouse_button_clicked() -> void:
	var res = await _html_prompt("Entrez votre pseudonyme", "text", "Votre pseudo…", name_line_edit.text)
	if res.ok: name_line_edit.text = str(res.text)

func on_mail_mouse_button_clicked() -> void:
	var res = await _html_prompt("Entrez votre e-mail", "email", "you@example.com", email_line_edit.text)
	if res.ok: email_line_edit.text = str(res.text)

func on_save_button_pressed() -> void:
	email = email_line_edit.text
	pseudo = name_line_edit.text
	if not email or not pseudo:
		legal_label.hide()
		error_label.show()
		return
	elif SaveSystem.has_saved_player():
		handle_already_saved_player()
	else:
		handle_first_request()
	email_line_edit.editable = false
	name_line_edit.editable = false
	save_button.disabled = true

func handle_first_request() -> void:
	var body := {
		"email": email,
		"pseudo": pseudo,
		"score": PlayerData.score,
	}
	var json = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	http_request.request("https://niseko-backend.onrender.com/register_or_submit", headers, HTTPClient.METHOD_POST, json)

func handle_already_saved_player() -> void:
	var token = SaveSystem.player_data.get("player_token")
	pseudo = name_line_edit.text
	email = email_line_edit.text
	var body := {
		"email": email,
		"pseudo": pseudo,
		"score": PlayerData.score,
		"player_token": token,
	}
	var json = JSON.stringify(body)
	var headers = ["Content-Type: application/json"]
	already_saved_request.request("https://niseko-backend.onrender.com/submit_with_token", headers, HTTPClient.METHOD_POST, json)

func _on_request_already_saved_completed(_result, response_code, _headers, _body):
	if response_code == 200:
		SaveSystem.player_data["email"] = email
		SaveSystem.player_data["pseudo"] = pseudo
		display_on_success_request()
	else:
		save_button.disabled = false

func display_on_success_request() -> void:
	v_box_container.hide()
	legal_label.hide()
	error_label.hide()
	score_saved_label.show()
	animation_player.play("scoreEnregistré")

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		var player_token = data.get("player_token")
		pseudo = data.get("pseudo")
		email = data.get("email")
		display_on_success_request()
		SaveSystem.save_player_on_disc(player_token, pseudo, email)
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
