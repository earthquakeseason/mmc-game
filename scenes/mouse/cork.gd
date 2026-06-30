extends RigidBody2D

var grabbed: bool = false
var mouse_over_cork: bool = false

func _process(_delta: float) -> void:
	if grabbed:
		var mouse_pos = get_global_mouse_position()
		get rect here
		if get_viewport_rect().encloses($HitCollisionShape.rect):
			global_position = lerp(global_position, mouse_pos, 1.0)

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
