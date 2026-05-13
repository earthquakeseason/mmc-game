extends Node2D

var physical_keycode_options: Array[int] = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90]
var chosen_key: int
var score: int = 0

func _ready() -> void:
	position = get_viewport().get_visible_rect().size / 2
	$NewKeyTimer.start(4)
	get_new_key()
	$ScoreLabel.text = str(score)

func _process(_delta: float) -> void:
	$TimeLabel.text = "Press in:" + str(round_to_dec($NewKeyTimer.time_left - 1, 2))

func _input(event) -> void:
	if event is InputEventKey:
		if event.physical_keycode == chosen_key:
			var score_gained: int = (100 - 10 * $NewKeyTimer.time_left)
			score += score_gained
			print(score_gained)
			$ScoreLabel.text = str(score)
			get_new_key()
		# add code here for pressing the wrong key

func _on_new_key_timer_timeout() -> void:
	score -= 200
	if score <= 0:
		queue_free()
	$ScoreLabel.text = str(score)
	get_new_key()

func get_new_key() -> void:
	chosen_key = physical_keycode_options.pick_random()
	$PressLabel.text = OS.get_keycode_string(chosen_key)
	$NewKeyTimer.start(3)

func wrong_key_pressed() -> void

func round_to_dec(num, digit: int):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
