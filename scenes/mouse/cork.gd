extends RigidBody2D

var grabbed: bool = false
var mouse_over_cork: bool = false
var prev_safe_mouse_pos: Vector2
var scrolling_up: bool = false

func _process(_delta: float) -> void:
	if grabbed:
		var mouse_pos: Vector2 = get_global_mouse_position()
		if get_viewport_rect().has_point(mouse_pos):
			global_position = lerp(global_position, mouse_pos, 1.0)
			prev_safe_mouse_pos = global_position
			linear_velocity = Vector2(0.0, 0.0)
		else:
			global_position = prev_safe_mouse_pos

func _on_mouse_entered() -> void:
	mouse_over_cork = true

func _on_mouse_exited() -> void:
	mouse_over_cork = false

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("left_click"):
		if mouse_over_cork:
			grabbed = true
	else:
		grabbed = false

	if Input.is_action_just_pressed("scroll_up"):
		scrolling_up = true
		$CorkSprite.rotation = lerp_angle($CorkSprite.rotation, $CorkSprite.rotation - 0.17, 1.0)
	else:
		scrolling_up = false
	
	if Input.is_action_just_pressed("scroll_down"):
		$CorkSprite.rotation = lerp_angle($CorkSprite.rotation, $CorkSprite.rotation + 0.17, 1.0)
		apply_torque(2000)
