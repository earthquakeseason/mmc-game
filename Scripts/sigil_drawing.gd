extends Sprite2D

var image: Image
var canvas_texture: ImageTexture
var mouse_motions: Array[Vector2]

func _ready() -> void:
	GameEvents.submit_pressed.connect(_on_submit_pressed)
	image = Image.create_empty(250, 250, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	canvas_texture = ImageTexture.create_from_image(image)
	texture = canvas_texture
	position = get_viewport().get_visible_rect().size / 2

func paint_texture(pos: Vector2i, paint_color: Color) -> void:
	image.fill_rect(Rect2i(pos, Vector2i(1,1)).grow(3), paint_color)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
			var pos = to_local(event.position)
			var impos = pos + get_rect().size / 2.0
			if Input.is_action_just_pressed("left_click"):
				paint_texture(impos, Color.BLACK)
				add_new_point(impos)
			else:
				paint_texture(impos, Color.WHITE)
			canvas_texture.update(image)
	elif event is InputEventMouseMotion:
		if Input.is_action_pressed("left_click") or Input.is_action_pressed("right_click"):
			var chosen_color: Color
			var pos: Vector2 = to_local(event.position)
			var impos: Vector2 = pos + get_rect().size / 2.0
			if Input.is_action_pressed("left_click"):
				chosen_color = Color.BLACK
				add_new_point(impos)
			else:
				chosen_color = Color.WHITE
			paint_texture(impos, chosen_color)
			canvas_texture.update(image)
			if event.relative.length_squared() > 0:
				var num = ceili(event.relative.length())
				var target_pos = impos - (event.relative)
				for i in num:
					impos = impos.move_toward(target_pos, 1)
					paint_texture(impos, chosen_color)
	elif event.is_action("ui_up"):
		for mouse_motion in mouse_motions:
			paint_texture(mouse_motion, Color.RED)
		canvas_texture.update(image)

func _on_submit_pressed():
	print("pressed")
	
func add_new_point(position: Vector2):
	if mouse_motions.is_empty() or mouse_motions.back().distance_to(position) > 20:
		mouse_motions.append(position)
