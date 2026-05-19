extends Sprite2D

const NUM_POINTS = 64
const FLAME_POINT_CLOUD: Array[Vector2i] = [Vector2i(165.0, 48.0), Vector2i(134.0, 67.0), Vector2i(134.0, 203.0),
Vector2i(133.0, 104.0), Vector2i(84.0, 192.0), Vector2i(95.0, 132.0)]
var image: Image
var canvas_texture: ImageTexture
var points: Array[Vector2]

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
	if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
		var pos = to_local(event.position)
		var impos = pos + get_rect().size / 2.0
		if Input.is_action_just_pressed("left_click"):
			paint_texture(impos, Color.BLACK)
		else:
			paint_texture(impos, Color.WHITE)
		points.append(impos)
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
					points.append(impos)

func _on_submit_pressed() -> void:
	point_resample()
	pass

func point_resample() -> void:
	var distance_total: float = 0
	for i in points.size() - 1:
		if i == points.size() - 1: continue
		distance_total += points[i].distance_to(points[i + 1])

	var required_distance_between = distance_total / NUM_POINTS
	var distance_travelled = 0
	var temp_points: Array[Vector2]
	# should probably read up on Curve2D
	for i in NUM_POINTS:
		if i == points.size() - 1: continue
		var distance_between: float = points[i].distance_to(points[i + 1])
		var normal_position: Vector2 = (points[i + 1] - points[i]).normalized() * required_distance_between
		if normal_position.length() - distance_travelled > distance_between:
			distance_travelled += distance_between
		else:
			distance_travelled = 0
			temp_points.append(normal_position)
			paint_texture(normal_position, Color.RED)
			canvas_texture.update(image)

	for i in temp_points.size() - 1:
		if i == temp_points.size() - 1: continue
		print(temp_points[i].distance_to(temp_points[i + 1]))
	print(temp_points)
	print(required_distance_between)
