extends Node2D

const BOTTOM_ANCHOR_Y: float = 115.0

var increment_stage: int = 0
var original_y_scale: float
var current_ingredient: Ingredient = GameInfo.get_current_ingredient()

func _ready() -> void:
	$Ingredient.texture = current_ingredient.initial_state
	original_y_scale = $Ingredient.scale.y
	GameEvents.increment_mechanical_stage.connect(_on_game_event_increment)
	update_bottom_anchor()

func _on_game_event_increment() -> void:
	increment_stage += 1
	if increment_stage >= 4:
		$Ingredient.scale.y = original_y_scale
		$Ingredient.texture = current_ingredient.final_state
	else:
		$Ingredient.scale.y -= 0.2
	update_bottom_anchor()
	var tween: Tween = create_tween()
	tween.tween_property($Pestle, "position", Vector2($Pestle.position.x, $Pestle.position.y - ($Pestle.get_rect().size.y / 2)), 1.0)

func update_bottom_anchor() -> void:
	$Ingredient.offset.y = ((BOTTOM_ANCHOR_Y - $Ingredient.position.y) / $Ingredient.scale.y) - ($Ingredient.texture.get_size().y * 0.5)
