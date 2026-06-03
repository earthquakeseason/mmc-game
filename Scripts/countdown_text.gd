extends Control

const TIME_DISPLAYED: float = 4
const TRUE_TIME: float = 2

func _ready() -> void:
	$CountdownTimer.start(TRUE_TIME)
	print(TRUE_TIME / TIME_DISPLAYED)

func _process(delta: float) -> void:
	if $CountdownTimer.time_left > TRUE_TIME / TIME_DISPLAYED:
		$CountdownLabel.text = str((int)(TIME_DISPLAYED * (TIME_DISPLAYED / $CountdownTimer.time_left) + 1))
	else:
		$CountdownLabel.text = "Go!"
