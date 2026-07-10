extends Sprite2D

func _ready() -> void:
	material.set_shader_parameter("potion_color", GameInfo.current_round_details.selected_potion.potion_color)
