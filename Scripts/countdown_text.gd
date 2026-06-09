extends Control

func start_animation(countdown_text: String) -> void:
	$CountdownLabel.text = countdown_text
	$AnimationPlayer.play("text_spawn_animation")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "text_spawn_animation":
		queue_free()
