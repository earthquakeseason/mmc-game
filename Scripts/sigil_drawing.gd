extends Sprite2D

const NUM_POINTS = 64
const FLAME_POINT_CLOUD: Array[Vector2i] = [Vector2i(165.0, 48.0), Vector2i(134.0, 67.0), Vector2i(134.0, 203.0),
Vector2i(133.0, 104.0), Vector2i(84.0, 192.0), Vector2i(95.0, 132.0)]
var image: Image
var canvas_texture: ImageTexture
var mouse_motions: Array[Vector2i]
var distances: Array[float]

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

# most inefficient code EVER, ill fix this later i promise
# not to mention this would detect a fully black screen as perfect
#
# resampling logic:
# loop through points and sum the distances between each consecutive pair.
# divide the total length by (N - 1)
# start at the first point. move along the segments of the drawing.
# every interval distance travelled drop a new point. if an interval ends between two original points. use lerp to find the exact spot.
# use acos somewhere

func _on_submit_pressed():
	var total_length: float
	for i in mouse_motions.size() - 1:
		var distance_between_dots: float = mouse_motions[i].distance_to(mouse_motions[i + 1])
		distances.append(distance_between_dots)
		total_length += distance_between_dots
	
	print(total_length)

func add_new_point(position: Vector2):
	if mouse_motions.is_empty() or mouse_motions.back().distance_to(position) > 20:
		mouse_motions.append(position)
