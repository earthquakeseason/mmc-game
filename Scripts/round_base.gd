class_name Round
extends Resource

@export var sigil_requirements: Array[Sigil]
@export var mechanical_requirements: Array

func calculate_round_size() -> int:
	return sigil_requirements.size() + mechanical_requirements.size()
