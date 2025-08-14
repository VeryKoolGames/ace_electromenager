extends Control

@export var power_up_line_scene: PackedScene
@onready var power_up_container: VBoxContainer = $PowerUpContainer

func _ready() -> void:
	Events.on_power_up_gathered.connect(add_or_update_power_up)

func add_or_update_power_up(power_up: ResPowerUp) -> void:
	if not GameState.is_in_game_mode() and not GameState.is_in_tutorial_mode():
		return
	var line = check_if_power_up_exists(power_up.type)
	if line:
		line.reset_progress_duration()
	else:
		var new_line = power_up_line_scene.instantiate() as PowerUpLine
		new_line.init(power_up)
		power_up_container.add_child(new_line)

func check_if_power_up_exists(type: ResPowerUp.PowerUpEnum) -> PowerUpLine:
	for child in power_up_container.get_children():
		if child is PowerUpLine and child.is_active and child.type == type:
			return child
	return null
