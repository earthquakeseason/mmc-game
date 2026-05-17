extends Sprite2D

const NUM_POINTS = 64
const FLAME_POINT_CLOUD: Array[Vector2i] = [Vector2i(165.0, 48.0), Vector2i(134.0, 67.0), Vector2i(134.0, 203.0),
Vector2i(133.0, 104.0), Vector2i(84.0, 192.0), Vector2i(95.0, 132.0)]
var image: Image
var canvas_texture: ImageTexture
var mouse_motions: Array[Gesture]

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
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var start_pos: Vector2i
		var end_pos: Vector2i
		var between_pos: Array[Vector2i]
		if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
			var pos = to_local(event.position)
			var impos = pos + get_rect().size / 2.0
			if Input.is_action_just_pressed("left_click"):
				paint_texture(impos, Color.BLACK)
				start_pos = impos
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
						if i < num:
							between_pos.append(impos)
						else:
							end_pos = impos
		elif event.is_released():
			print(between_pos)
			if between_pos.is_empty():
				mouse_motions.append(Gesture.new(start_pos, Vector2i(0, 0), [], true))
			else:
				mouse_motions.append(Gesture.new(start_pos, end_pos, between_pos, false))



	elif event.is_action_pressed("ui_up"):
		for mouse_motion in mouse_motions:
			var random_color = Color(randf(), randf(), randf())
			paint_texture(mouse_motion.start_pos, random_color)
			if mouse_motion.single_point == false:
				paint_texture(mouse_motion.end_pos, random_color)
		canvas_texture.update(image)

func _on_submit_pressed():
	pass
