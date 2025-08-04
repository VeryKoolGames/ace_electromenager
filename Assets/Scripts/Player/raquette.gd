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
		switch_rotation(40)
	else:
		is_facing_right = true
		switch_rotation(-40)

func switch_rotation(rotation_target: float):
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", rotation_target, 0.1)

func play_prepare_raquette_shoot_anim() -> void:
	var target_skew = deg_to_rad(-60) if is_facing_right else deg_to_rad(60)
	var tween = create_tween()
	tween.tween_property(self, "skew", target_skew, 0.1)
	tween.tween_property(self, "scale", scale + Vector2(0.05, 0.0), 0.1)

func play_raquette_shoot_anim() -> void:
	var target_skew = deg_to_rad(60) if is_facing_right else deg_to_rad(-60)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.1)
	tween.tween_property(self, "skew",target_skew, 0.1)
	tween.tween_property(self, "skew", deg_to_rad(0), 0.2)
