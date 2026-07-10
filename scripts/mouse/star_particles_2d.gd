extends CPUParticles2D

func _on_cork_display_stars() -> void:
	position = get_global_mouse_position()
	emitting = true
