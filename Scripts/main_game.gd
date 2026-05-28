extends CanvasLayer

const DRAWING_SCREEN: PackedScene = preload("uid://dwobt7r1ywjtw")
const MAX_TIME: int = 60

var drawing_scene: Node

func _ready() -> void:
	GameEvents.recognition_attempt.connect(_on_recognition_attempt)
	$RoundTimer.start(MAX_TIME)
	drawing_scene = DRAWING_SCREEN.instantiate()
	add_child(drawing_scene)

func _process(delta: float) -> void:
	$RoundTimeProgress.value = 100 * ($RoundTimer.time_left / MAX_TIME)

func _on_recognition_attempt(successful: bool) -> void:
	if successful and drawing_scene != null:
		drawing_scene.queue_free()
		next_turn()

func next_turn() -> void:
	GameInfo.increment_turn()
	if GameInfo.round_over:
		# do stuff relating to when the round has finished
		pass
