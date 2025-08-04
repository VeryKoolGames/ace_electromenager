extends Resource
class_name ResLeaderboardLine

var name: String
var place: int
var score: int

func _init(_name: String, _place: int, _score: int) -> void:
	name = _name
	place = _place
	score = _score
