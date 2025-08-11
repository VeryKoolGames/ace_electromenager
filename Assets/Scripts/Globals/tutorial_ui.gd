extends Control

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

var tutorial_texts = {
	0: "Bienvenu sur Ace Challenge !",
}

var char_delay := 0.05

func _ready() -> void:
	Events.on_game_started.connect(show_first_pannel)

func show_first_pannel() -> void:
	var tween = create_tween()
	tween.tween_property(panel, "scale", Vector2.ONE, 0.5).finished.connect(func():
		write_tutorial_text(0)
	)

func write_tutorial_text(index: int) -> void:
	label.text = ""
	var full_text = tutorial_texts[index]
	call_deferred("_type_text", full_text)

func _type_text(text: String) -> void:
	label.text = ""
	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(char_delay).timeout
