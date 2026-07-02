extends RigidBody2D

const ROTATE_AMOUNT: float = deg_to_rad(10.0)

var grabbed: bool = false
var mouse_over_cork: bool = false
var prev_safe_mouse_pos: Vector2
var target_position: Vector2
var target_rotation: float = 0.0
var pending_lock: bool = false
var final_lock: bool = false

signal display_stars

func _process(delta: float) -> void:
	if grabbed and not freeze:
		var mouse_pos: Vector2 = get_global_mouse_position()
		if get_viewport_rect().has_point(mouse_pos):
			global_position = lerp(global_position, mouse_pos, 1.0)
			prev_safe_mouse_pos = global_position
		else:
			global_position = prev_safe_mouse_pos
		linear_velocity = Vector2(0.0, 0.0)
		rotation = lerp_angle(rotation, target_rotation, delta * 15)
	if final_lock:
		global_position = lerp(global_position, target_position, 0.3)

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

	if grabbed:
		if event.is_action_pressed("scroll_up"):
			target_rotation -= ROTATE_AMOUNT
		elif event.is_action_pressed("scroll_down"):
			target_rotation += ROTATE_AMOUNT

	if event is InputEventMouseButton:
		if freeze and event.double_click and not final_lock:
			final_lock = true
			print("double")
			target_position = Vector2(position.x, position.y + 20)
			display_stars.emit()

func _on_potion_opening_body_entered(body: Node2D) -> void:
	if body == self:
		pending_lock = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if pending_lock:
		state.transform.origin = Vector2(584.0, 245.0)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0

		pending_lock = false
		call_deferred("_finish_lock")

func _finish_lock() -> void:
	freeze = true
	global_position = Vector2(584.0, 245.0)
	global_rotation = 0
