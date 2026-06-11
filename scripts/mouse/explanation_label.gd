extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.complete_attempt.connect(_on_complete_attempt)
	
func _on_complete_attempt(successful: bool):
	if !successful: text = "Your sigil is unrecognisable!"
