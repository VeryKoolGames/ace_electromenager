extends Resource
class_name ResPowerUp

enum PowerUpEnum {
	TRIPLE_SHOT,
	REBOUND_SHOT,
	FAST_SPAWN_SHOT,
}

@export var name: String
@export var type: PowerUpEnum
@export var duration: float
@export var sprite: Texture2D

# Node to which this resource is attached
var node: Node
