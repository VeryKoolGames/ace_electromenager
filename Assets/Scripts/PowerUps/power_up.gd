extends Node2D
class_name PowerUp

@onready var scale_on_destroy_component: ScaleOnDestroyComponent = $ScaleOnDestroyComponent
@export var res_power_up: ResPowerUp

# To make sure we don't gather it twice while it scales down
var is_gathered: bool = false

func _ready() -> void:
	res_power_up.node = self

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball") and not is_gathered:
		is_gathered = true
		Events.on_power_up_gathered.emit(res_power_up)
		scale_on_destroy_component.destroy()
