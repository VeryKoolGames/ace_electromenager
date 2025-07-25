extends Node2D
class_name PowerUp

enum PowerUpEnum {
	TRIPLE_SHOT,
	DRILL_SHOT,
}

@export var power_up_type: PowerUpEnum

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		Events.on_power_up_gathered.emit(power_up_type)
		queue_free()
