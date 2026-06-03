extends Label

func show_result(result_text: String) -> void:
	text = result_text
	$ResultAnimationPlayer.play("result_label")
	#if (randi() % 2 == 0): position.x + randi_range(0, 10)
	#else: position.x - randi_range(0, 10)

func _on_result_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "result_label":
		queue_free()
