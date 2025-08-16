extends Node

@export var particle_scene = preload("res://Assets/Particles/p_réparation.tscn")
@onready var particles_container: Node2D = $ParticlesContainer


func _ready() -> void:
	Events.on_machine_repaired.connect(on_machine_repaired)

func on_machine_repaired(machine: Machine) -> void:
	var scene = particle_scene.instantiate() as Node2D
	scene.global_position = machine.global_position
	particles_container.add_child(scene)
	var particles = scene.get_node("GPUParticles2D") as GPUParticles2D
	particles.emitting = true
	particles.finished.connect(func(): scene.queue_free())
