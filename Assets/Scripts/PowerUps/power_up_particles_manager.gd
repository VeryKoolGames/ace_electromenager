extends Node2D
@onready var gradient: GPUParticles2D = $Gradient
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gpu_particles_2d.emitting = true
	gradient.emitting = true
	gradient.finished.connect(func(): queue_free())
