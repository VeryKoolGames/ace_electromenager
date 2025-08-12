extends Node2D

@export var tutorial_fridge_scene: PackedScene
@export var fridge_scene: PackedScene
@export var power_up_scene: PackedScene
@export var spawn_position: Node2D
@export var power_up_spawn_position: Node2D
@export var extra_spawn_position: Array[Node2D]
@export var spawn_control: Control

var spawn_area: Rect2
var min_distance = 150.0
var grid_size = min_distance

var grid_positions = {}

func _ready() -> void:
	owner.on_first_part_started.connect(spawn_fridge)
	owner.on_second_part_started.connect(spawn_power_up)
	Events.on_power_up_gathered.connect(spawn_more_machines)

func spawn_fridge() -> void:
	var fridge = tutorial_fridge_scene.instantiate()
	spawn_position.add_child(fridge)

func spawn_power_up() -> void:
	var power_up = power_up_scene.instantiate()
	power_up_spawn_position.add_child(power_up)

func spawn_more_machines(_power_up: ResPowerUp) -> void:
	for spawn_pos in extra_spawn_position:
		var fridge = fridge_scene.instantiate()
		spawn_pos.call_deferred("add_child", fridge)
	Events.on_tutorial_progressed.emit()
	get_spawn_area()
	generate_grid()
	Events.on_machine_repaired.connect(replace_machine)

func get_spawn_area() -> void:
	spawn_area = spawn_control.get_global_rect()

func replace_machine(machine: Node):
	await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
	spawn_machine()
	for pos in grid_positions:
		if grid_positions[pos] == machine:
			grid_positions[pos] = null
			break

func spawn_machine() -> void:
	var empty_positions = get_empty_positions()
	if empty_positions.is_empty():
		return
	
	var pos = empty_positions[randi() % empty_positions.size()]
	spawn_machine_at(pos)
	return

func spawn_machine_at(position: Vector2):
	var obj = fridge_scene.instantiate() as Node
	obj.global_position = position
	add_child(obj)
	grid_positions[position] = obj

func get_empty_positions() -> Array:
	var empty = []
	for pos in grid_positions:
		if grid_positions[pos] == null:
			empty.append(pos)
	return empty

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
