extends Control

var landscape_ratio_threshold := 1.05
var has_been_shown = false

func _ready() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		show_orientatino_hint()
	else:
		queue_free()

func show_orientatino_hint() -> void:
	show()
	await get_tree().create_timer(10).timeout
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.tween_callback(func(): self.queue_free())
