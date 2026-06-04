class_name Typing
extends Minigame

@export var scene: PackedScene
@export var speed: float = 1.0

func _init() -> void:
	minigame_type = MinigameType.TYPING
