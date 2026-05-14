extends Node2D

var physical_keycode_options: Array[int] = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90]
var chosen_key: int
var score: int = 0

func _ready() -> void:
	position = get_viewport().get_visible_rect().size / 2
	$NewKeyTimer.start(4)
	get_new_key()
	$ProgressBar.value = score

func _process(_delta: float) -> void:
	$TimeLabel.text = "Press in:" + str(round_to_dec($NewKeyTimer.time_left - 1, 1)) + "s"

func _input(event) -> void:
	if event is InputEventKey:
		# because inputeventkey triggers when keys are released and pressed
		if not event.echo and not event.is_released():
			if event.physical_keycode == chosen_key:
				# later make this more exponentially increasing as time approachs 0
				var score_gained: int = (100 - 10 * ($NewKeyTimer.time_left - 1))
				score += score_gained
				print(score_gained)
				$ProgressBar.value = score
				if $ProgressBar.value < $ProgressBar.max_value:
					get_new_key()
				else:
					get_tree().change_scene_to_file("res://Scenes/victory_screen.tscn")
			else:
				print("pressed wrong key: " + OS.get_keycode_string(event.physical_keycode))
				key_fail()

func _on_new_key_timer_timeout() -> void:
	print("timeout triggered")
	key_fail()

func get_new_key() -> void:
	chosen_key = physical_keycode_options.pick_random()
	$PressLabel.text = OS.get_keycode_string(chosen_key)
	$NewKeyTimer.start(3)

func key_fail() -> void:
	print("key fail triggered")
	score -= 200
	if score <= 0:
		queue_free()
	$ProgressBar.value = score
	get_new_key()

func round_to_dec(num, digit: int):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
