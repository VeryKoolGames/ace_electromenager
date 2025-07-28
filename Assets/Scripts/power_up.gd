extends Node2D
class_name PowerUp


@export var res_power_up: ResPowerUp

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		Events.on_power_up_gathered.emit(res_power_up)
		queue_free()
