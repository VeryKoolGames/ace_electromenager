extends Node
var spawn_area: Rect2
var min_distance = 150.0
var grid_size = min_distance
@export var spawn_control: Control
@export var machines: Array[PackedScene]
@onready var power_up_cooldown: Timer = $PowerUpCooldown
@export var power_ups: Array[PackedScene]
var has_game_ended := false
var grid_positions: Dictionary = {}

# Power ups
var max_power_ups := 3
var current_power_ups := 0
var min_power_up_timer := 5
var max_power_up_timer := 10

func _ready() -> void:
	power_up_cooldown.start(randf_range(min_power_up_timer, max_power_up_timer))
	power_up_cooldown.timeout.connect(spawn_power_up)
	Events.on_machine_repaired.connect(replace_machine)
	Events.on_power_up_gathered.connect(remove_power_up)
	Events.on_game_timer_ended.connect(on_game_ended)
	Events.on_game_state_advanced.connect(on_game_state_advanced)
	Events.on_game_started.connect(spawn_initial_machines)
	
	# TIL the control node do not have the right position/size at the begining so we need to await a frame
	await get_tree().process_frame
	get_spawn_area()
	generate_grid()

func spawn_initial_machines() -> void:
	spawn_machines(3)

func on_game_state_advanced() -> void:
	spawn_machines(2)
	min_power_up_timer -= 2
	max_power_up_timer -= 3

func on_game_ended() -> void:
	has_game_ended = true

func get_spawn_area() -> void:
	spawn_area = spawn_control.get_global_rect()

func generate_grid():
	grid_positions.clear()
	var cols = int(spawn_area.size.x / grid_size)
	var rows = int(spawn_area.size.y / grid_size)
	
	for x in range(cols):
		for y in range(rows):
			var pos = Vector2(
				spawn_area.position.x + x * grid_size + grid_size / 2,
				spawn_area.position.y + y * grid_size + grid_size / 2
			)
			grid_positions[pos] = null

func spawn_machine() -> void:
	if has_game_ended:
		return
	var empty_positions = get_empty_positions()
	if empty_positions.is_empty():
		return
	
	var pos = empty_positions[randi() % empty_positions.size()]
	spawn_machine_at(pos)
	return

func spawn_power_up() -> void:
	if has_game_ended or current_power_ups >= max_power_ups:
		return
	var empty_positions = get_empty_positions()
	if empty_positions.is_empty():
		return
	var pos = empty_positions[randi() % empty_positions.size()]
	spawn_power_up_at(pos)
	current_power_ups += 1
	power_up_cooldown.start(randf_range(min_power_up_timer, max_power_up_timer))
	return

func spawn_machines(machine_count: int):
	var empty_positions = get_empty_positions()
	empty_positions.shuffle()
	
	for i in range(min(machine_count, empty_positions.size())):
		spawn_machine_at(empty_positions[i])

func get_empty_positions() -> Array:
	var empty = []
	for pos in grid_positions:
		if grid_positions[pos] == null:
			empty.append(pos)
	return empty

func replace_machine(machine: Node):
	await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
	spawn_machine()
	for pos in grid_positions:
		if grid_positions[pos] == machine:
			grid_positions[pos] = null
			break

func remove_power_up(power_up: ResPowerUp):
	var node_to_remove = power_up.node
	for pos in grid_positions:
		if grid_positions[pos] == node_to_remove:
			grid_positions[pos] = null
			current_power_ups -= 1
			break

func spawn_machine_at(position: Vector2):
	var obj = get_random_machine().instantiate() as Node
	obj.global_position = position
	add_child(obj)
	grid_positions[position] = obj

func spawn_power_up_at(position: Vector2):
	var obj = get_random_power_up().instantiate() as Node
	obj.global_position = position
	add_child(obj)
	grid_positions[position] = obj

func get_random_machine() -> PackedScene:
	return machines[randi_range(0, machines.size() - 1)]

func get_random_power_up() -> PackedScene:
	return power_ups[randi_range(0, power_ups.size() - 1)]
