class_name Point
extends RefCounted

var x: float
var y: float
var id: int
var angle: float

func _init(px: float = 0.0, py: float = 0.0, pid: int = 0, pangle: float = 0.0):
	x = px
	y = py
	id = pid
	angle = pangle
	

func display():
	print("Point at: (", x, ", ", y, ")")
