extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.recognition_attempt.connect(_on_recognition_attempt)
	
func _on_recognition_attempt(successful: bool):
	if !successful: text = "Your sigil is unrecognisable!"
