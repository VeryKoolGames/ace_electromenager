extends Control

@onready var referee: Referee = $RefChair/Control/Arbitre
@onready var referee_panel: PanelContainer = $RefereePanel
@onready var label: Label = $RefereePanel/Label
@export var congratulations_texts: ResDialogue
var is_on_cooldown := false
@export var char_delay := 0.03
@export var shake_intensity := 50.0
@export var shake_duration := 0.1

var original_panel_position: Vector2
var shake_tween: Tween

func _ready() -> void:
	Events.on_player_congratulated.connect(make_referee_congratulate_on_high_core)
	Events.on_player_aced.connect(make_referee_congratulate_on_ace)
	original_panel_position = referee_panel.position

func make_referee_congratulate_on_high_core() -> void:
	if is_on_cooldown:
		return
	start_referee_cooldown()
	var text = congratulations_texts.dialogues_lines[randi_range(0, congratulations_texts.dialogues_lines.size() - 1)]
	show_pannel_with_text(text)

func make_referee_congratulate_on_ace() -> void:
	if is_on_cooldown:
		return
	start_referee_cooldown()
	var text = "Ace !"
	show_pannel_with_text(text)

func start_referee_cooldown() -> void:
	is_on_cooldown = true
	await get_tree().create_timer(2).timeout
	is_on_cooldown = false

func show_pannel_with_text(text_to_write: String) -> void:
	var tween = create_tween()
	tween.tween_property(referee_panel, "scale", Vector2.ONE, 0.2).finished.connect(func():
		write_referee_text(text_to_write)
	)

func write_referee_text(text_to_write: String) -> void:
	referee.start_talking()
	label.text = ""
	for i in text_to_write.length():
		label.text = text_to_write.substr(0, i + 1)
		await get_tree().create_timer(char_delay).timeout
	referee.hide_mouth()
	await get_tree().create_timer(1).timeout
	referee.stop_talking()
	hide_pannel()

func stop_shake_effect() -> void:
	if shake_tween:
		shake_tween.kill()
		shake_tween = null
	
	var reset_tween = create_tween()
	reset_tween.tween_property(referee_panel, "position", original_panel_position, 0.1)

func hide_pannel() -> void:
	var tween = create_tween()
	tween.tween_property(referee_panel, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(func(): referee_panel.text = "")
