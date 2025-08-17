extends Control

@export var texture_rects: Array[TextureRect]
@export var scale_speed: float = 2.0
@export var scale_amount: float = 0.05

var t: float = 0.0
var phase_offsets: Array[float] = []

func _ready() -> void:
	randomize()
	phase_offsets.resize(texture_rects.size())
	for i in range(texture_rects.size()):
		phase_offsets[i] = randf() * TAU

func _process(delta: float) -> void:
	t += delta * scale_speed
	for i in range(texture_rects.size()):
		var tex = texture_rects[i]
		if tex:
			var pulse = 1.0 + sin(t + phase_offsets[i]) * scale_amount
			tex.scale = Vector2(pulse, pulse)
