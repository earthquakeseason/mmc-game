extends Node

var round_num: int
var current_round_turn: int
var current_round_details: Round
var round_over: bool

func set_base_info() -> void:
	current_round_turn = 0
	round_num = 0
	current_round_details = Round.new()
	current_round_details.mechanical_requirements.append(1)
	current_round_details.sigil_requirements.append(Sigils.flame_sigil)

func increment_turn() -> void:
	current_round_turn += 1
	if current_round_details.calculate_round_size() - 1 <= current_round_turn:
		round_over = true

func _ready() -> void:
	set_base_info()
