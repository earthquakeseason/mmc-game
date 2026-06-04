extends CanvasLayer

const DRAWING_SCREEN: PackedScene = preload("uid://dwobt7r1ywjtw")
const DRAWING = preload("uid://bil0asoipqfqw")
const KNIFE = preload("uid://vwiwro34v66g")

const MAX_TIME: int = 60

var drawing_scene: Node
var typing_scene: Node

func _ready() -> void:
	GameEvents.complete_attempt.connect(_on_complete_attempt)
	$RoundTimer.start(MAX_TIME)
	start_turn()
	for minigame in GameInfo.current_round_details.minigame_requirements:
		var next_up_symbol = TextureRect.new()
		if (minigame.minigame_type == Minigame.MinigameType.TYPING):
			print("typing")
			next_up_symbol.texture = KNIFE
		else:
			print("drawing")
			next_up_symbol.texture = DRAWING
		$NextUpContainer/HBoxContainer.add_child(next_up_symbol)

func _process(_delta: float) -> void:
	$RoundTimeProgress.value = 100 * ($RoundTimer.time_left / MAX_TIME)

func _on_complete_attempt(successful: bool) -> void:
	if successful:
		if GameInfo.get_current_minigame().minigame_type == Minigame.MinigameType.TYPING:
			typing_scene.queue_free()
		else:
			drawing_scene.queue_free()
		next_turn()

func start_turn() -> void:
	var minigame_requirement_current: Minigame = GameInfo.get_current_minigame()
	if minigame_requirement_current.minigame_type == Minigame.MinigameType.TYPING:
		typing_scene = minigame_requirement_current.scene.instantiate()
		add_child(typing_scene)
	else:
		drawing_scene = DRAWING_SCREEN.instantiate()
		add_child(drawing_scene)

func next_turn() -> void:
	GameInfo.increment_turn()
	if GameInfo.round_over:
		get_tree().change_scene_to_file("res://Scenes/victory_screen.tscn")
	else:
		start_turn()
