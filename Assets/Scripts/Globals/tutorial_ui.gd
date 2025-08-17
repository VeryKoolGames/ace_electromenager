extends Control
@onready var panel: PanelContainer = $RefereePanel
@onready var label: Label = $RefereePanel/Label
var tutorial_texts = {}
@export var first_dialogue: ResDialogue
@export var second_dialogue: ResDialogue
@export var third_dialogue: ResDialogue
@export var forth_dialogue: ResDialogue
var current_index := 0
var current_text_index := 0
var is_writing := false
var typing_tween: Tween
var skip_typing_cooldown := false
var is_starting := true
@export var char_delay := 0.03
@export var time_between_dialogues := 1.5
@onready var scale_on_destroy_component: ScaleOnDestroyComponent = $RefereePanel/ScaleOnDestroyComponent
@export var referee: Referee

func _ready() -> void:
	tutorial_texts = {
		0: {
			"text": first_dialogue.dialogues_lines,
			"signal": owner.on_first_part_started,
		},
		1: {
			"text": second_dialogue.dialogues_lines,
			"signal": owner.on_second_part_started,
		},
		2: {
			"text": forth_dialogue.dialogues_lines,
			"signal": owner.on_fourth_part_started,
		},
		3: {
			"text": third_dialogue.dialogues_lines,
			"signal": owner.on_third_part_started,
		}
	}
	await get_tree().create_timer(3).timeout
	is_starting = false

func start_skipping_cooldown() -> void:
	skip_typing_cooldown = true
	await get_tree().create_timer(0.5).timeout
	skip_typing_cooldown = false

func _input(event: InputEvent) -> void:
	if is_starting:
		return
	if event.is_action_pressed("shoot"):
		if is_writing:
			skip_typing()
			start_skipping_cooldown()
		else:
			advance_text()

func skip_typing() -> void:
	if skip_typing_cooldown:
		return
	if typing_tween:
		typing_tween.kill()
	AudioManager.stop_ref_long_talk()
	is_writing = false
	var current_texts = tutorial_texts[current_index]["text"]
	if current_text_index < current_texts.size():
		label.text = current_texts[current_text_index]
	referee.hide_mouth()

func advance_text() -> void:
	current_text_index += 1
	var current_texts = tutorial_texts[current_index]["text"]
	
	if current_text_index > current_texts.size() + 1:
		return
	
	if current_text_index < current_texts.size():
		await type_text()
	if current_text_index == current_texts.size() - 1:
		tutorial_texts[current_index]["signal"].emit()
		GameState.set_game_mode()
		if current_index == tutorial_texts.size() - 1:
			referee.stop_talking()
			await get_tree().create_timer(2).timeout
			scale_on_destroy_component.destroy()

func show_tutorial_pannel() -> void:
	var tween = create_tween()
	tween.tween_property(panel, "scale", Vector2.ONE, 0.5).finished.connect(func():
		write_tutorial_text()
	)

func move_to_next_tutorial_step() -> void:
	GameState.set_tutorial_mode()
	current_text_index = 0
	current_index += 1
	type_text()

func write_tutorial_text() -> void:
	type_text()

func type_text() -> void:
	AudioManager.play_ref_long_talk()
	referee.start_talking()
	start_skipping_cooldown()
	if current_index >= tutorial_texts.size():
		return
		
	var current_texts = tutorial_texts[current_index]["text"]
	if current_text_index >= current_texts.size():
		return
	
	is_writing = true
	label.text = ""
	var text_to_write = current_texts[current_text_index]
	
	if typing_tween:
		typing_tween.kill()
	
	for i in text_to_write.length():
		if not is_writing:
			return
		label.text = text_to_write.substr(0, i + 1)
		await get_tree().create_timer(char_delay).timeout
	
	is_writing = false
	referee.hide_mouth()
	AudioManager.stop_ref_long_talk()
