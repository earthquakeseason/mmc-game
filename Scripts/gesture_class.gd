extends Resource
class_name Gesture

var start_pos: Vector2i
var end_pos: Vector2i
var between_pos: Array[Vector2i]
var single_point: bool

func _init(_start_pos: Vector2i, _end_pos: Vector2i, _between_pos: Array[Vector2i], _single_point: bool):
	start_pos = _start_pos
	end_pos = _end_pos
	between_pos = _between_pos
	single_point = _single_point
	
	if !single_point:
		var updated_between_pos: Array[Vector2i]
		for i in between_pos.size():
			if i == 0: continue
			if between_pos[i].distance_to(between_pos[i - 1]) >= 10: updated_between_pos.append(between_pos[i])
		between_pos = updated_between_pos
