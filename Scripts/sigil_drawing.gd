extends Sprite2D

const PAINT_COLOR: Color = Color.BLACK
var image: Image
var canvas_texture: ImageTexture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	image = Image.create_empty(500, 500, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	canvas_texture = ImageTexture.create_from_image(image)
	texture = canvas_texture

func paint_texture(pos: Vector2i):
	image.fill_rect(Rect2i(pos, Vector2i(1,1)).grow(3), PAINT_COLOR)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var pos = to_local(event.position)
			var impos = pos+get_rect().size/2.0
			paint_texture(impos)
			canvas_texture.update(image)
	elif event is InputEventMouseMotion:
		if Input.is_action_pressed("left_click"):
			var pos = to_local(event.position)
			var impos = pos+get_rect().size/2.0
			paint_texture(impos)
			canvas_texture.update(image)
			if event.relative.length_squared() > 0:
				var num = ceili(event.relative.length())
				var target_pos = impos - (event.relative)
				for i in num:
					impos = impos.move_toward(target_pos, 1)
					paint_texture(impos)
