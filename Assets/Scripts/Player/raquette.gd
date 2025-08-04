extends Sprite2D
class_name Raquette

var is_facing_right := true

func _process(_delta: float) -> void:
	rotate_raquette()

func rotate_raquette() -> void:
	var mpos = get_global_mouse_position()
	var shot_direction  = (mpos - global_position)

	if shot_direction.x < 0:
		is_facing_right = false
		rotation_degrees = 40
	else:
		is_facing_right = true
		rotation_degrees = -40

func play_prepare_raquette_shoot_anim() -> void:
	var target_skew = deg_to_rad(-60) if is_facing_right else deg_to_rad(60)
	var tween = create_tween()
	tween.tween_property(self, "skew", target_skew, 0.1)

func play_raquette_shoot_anim() -> void:
	var target_skew = deg_to_rad(60) if is_facing_right else deg_to_rad(-60)
	var tween = create_tween()
	tween.tween_property(self, "skew",target_skew, 0.1)
	tween.tween_property(self, "skew", deg_to_rad(0), 0.2)
