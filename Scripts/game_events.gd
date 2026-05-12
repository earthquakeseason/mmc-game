extends Node

signal submit_pressed

# debugger gets upset if i dont use it anywhere...
func emit_submit_pressed() -> void:
	submit_pressed.emit()
