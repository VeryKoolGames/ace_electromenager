extends Control

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/MarginContainer/Label

var tutorial_texts = {}
@export var first_dialogue: ResDialogue
@export var second_dialogue: ResDialogue
@export var third_dialogue: ResDialogue

var current_index := 0

@export var char_delay := 0.03
@export var time_between_dialogues := 1.5

func _ready() -> void:
	Events.on_game_started.connect(show_tutorial_pannel)
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
			"text": third_dialogue.dialogues_lines,
			"signal": owner.on_third_part_started,
		}
	}

func show_tutorial_pannel() -> void:
	var tween = create_tween()
	tween.tween_property(panel, "scale", Vector2.ONE, 0.5).finished.connect(func():
		write_tutorial_text()
	)

func write_tutorial_text() -> void:
	label.text = ""
	var full_text = tutorial_texts[current_index]
	call_deferred("_type_text", full_text)

func _type_text(texts: Dictionary) -> void:
	label.text = ""
	for index in range(0, texts.get("text").size()):
		for i in  texts.get("text")[index].length():
			label.text += texts.get("text")[index][i]
			await get_tree().create_timer(char_delay).timeout
		await get_tree().create_timer(time_between_dialogues).timeout
		if index != texts.get("text").size() - 1:
			label.text = ""
		else:
			texts.get("signal").emit()
			GameState.set_game_mode()
			current_index += 1
	
