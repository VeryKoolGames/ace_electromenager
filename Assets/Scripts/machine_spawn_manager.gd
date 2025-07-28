extends Node

var spawn_area: Rect2
var min_distance = 200.0
var grid_size = min_distance
@onready var spawn_shape = $Area2D/CollisionShape2D as CollisionShape2D
@export var machines: Array[PackedScene]

var grid_positions: Dictionary = {}

func _ready() -> void:
	Events.on_machine_repaired.connect(replace_machine)
	_get_spawn_area()
	generate_grid()
	spawn_machines(5)

func _get_spawn_area() -> void:
	var local_rect = spawn_shape.shape.get_rect()
	spawn_area = Rect2(
		$Area2D.global_position + local_rect.position,
		local_rect.size
	)

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

func spawn_machine() -> bool:
	var empty_positions = get_empty_positions()
	if empty_positions.is_empty():
		return false
	
	var pos = empty_positions[randi() % empty_positions.size()]
	spawn_machine_at(pos)
	return true

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

func replace_machine(machine: Machine):
	for pos in grid_positions:
		if grid_positions[pos] == machine:
			grid_positions[pos] = null
			break
	await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
	spawn_machine()

func spawn_machine_at(position: Vector2):
	var obj = _get_random_machine().instantiate() as Machine
	obj.global_position = position
	add_child(obj)
	grid_positions[position] = obj

func _get_random_machine() -> PackedScene:
	return machines[randi_range(0, machines.size() - 1)]
