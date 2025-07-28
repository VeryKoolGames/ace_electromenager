extends Line2D

var last_position: Vector2
var max_points: int = 15
@onready var curve := Curve2D.new()
var width_curve_resource: Curve

func _ready() -> void:
	width_curve_resource = Curve.new()
	width_curve_resource.add_point(Vector2(0.0, 0.0))
	width_curve_resource.add_point(Vector2(1.0, 1.0))
	width_curve = width_curve_resource
	width = 20.0

func _process(_delta: float) -> void:
	var current_pos = get_parent().global_position
	
	var movement = current_pos - last_position
	
	for i in range(curve.point_count):
		var point = curve.get_point_position(i)
		curve.set_point_position(i, point - movement)
	
	curve.add_point(Vector2.ZERO)
	
	if curve.get_baked_points().size() > max_points:
		curve.remove_point(0)
	
	points = curve.get_baked_points()
	last_position = current_pos
