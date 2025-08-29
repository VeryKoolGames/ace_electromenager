extends Control

var landscape_ratio_threshold := 1.05
var has_been_shown = false
@onready var phone_rotation_rect: TextureRect = $PhoneRotationRect

func _ready() -> void:
	if not SaveSystem.is_launching_for_the_first_time:
		queue_free()
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		show_orientatino_hint()
		rotate_phone_icon()
	else:
		queue_free()

func show_orientatino_hint() -> void:
	show()
	await get_tree().create_timer(10).timeout
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.tween_callback(func(): self.queue_free())

func rotate_phone_icon() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(phone_rotation_rect, "rotation", deg_to_rad(90), 2)
	tween.tween_property(phone_rotation_rect, "rotation", deg_to_rad(30), 2).set_delay(0.3)
