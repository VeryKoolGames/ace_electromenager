extends Node

@export var particle_scene = preload("res://Assets/Particles/p_réparation.tscn")
@export var power_up_particles_scene = preload("res://Assets/Particles/p_power_up.tscn")
@onready var particles_container: Node2D = $ParticlesContainer


func _ready() -> void:
	Events.on_machine_repaired.connect(on_machine_repaired)
	Events.on_power_up_gathered.connect(on_power_up_gathered)

func on_machine_repaired(machine: Machine) -> void:
	var scene = particle_scene.instantiate() as Node2D
	scene.global_position = machine.global_position
	particles_container.add_child(scene)

func on_power_up_gathered(power_up: ResPowerUp) -> void:
	var target_position = power_up.node.global_position
	var scene = power_up_particles_scene.instantiate() as Node2D
	scene.global_position = target_position
	particles_container.add_child(scene)
