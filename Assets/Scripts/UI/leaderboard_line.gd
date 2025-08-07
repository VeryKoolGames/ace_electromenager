extends MarginContainer
class_name LeaderboardLine

@onready var crown_texture: TextureRect = $HBoxContainer2/HBoxContainer/MarginContainer/CrownTexture
@onready var place_label: Label = $HBoxContainer2/HBoxContainer/MarginContainer2/PlaceLabel
@onready var points_label: Label = $HBoxContainer2/MarginContainer/PointsLabel
@onready var name_label: Label = $HBoxContainer2/HBoxContainer/MarginContainer3/NameLabel

@export var first_place_crown_color: Color
@export var second_place_crown_color: Color
@export var third_place_crown_color: Color


func populate_line(line_data: ResLeaderboardLine):
	set_crown_and_place(line_data)
	name_label.text = line_data.name
	points_label.text = str(line_data.score) + " pts"

func set_crown_and_place(line_data: ResLeaderboardLine) -> void:
	if line_data.place == 1:
		crown_texture.modulate = first_place_crown_color
	elif line_data.place == 2:
		crown_texture.modulate = second_place_crown_color
	elif line_data.place == 3:
		crown_texture.modulate = third_place_crown_color
	else:
		crown_texture.get_parent().hide()
		#crown_texture.modulate.a = 0.0
	var place_text = str(line_data.place)
	if line_data.place < 10:
		place_text = "0" + str(line_data.place)
	place_label.text = place_text
