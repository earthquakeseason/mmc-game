extends CanvasLayer

const DRAWING_SCREEN: PackedScene = preload("uid://dwobt7r1ywjtw")
const DRAWING = preload("uid://bil0asoipqfqw")
const KNIFE = preload("uid://vwiwro34v66g")
const COUNTDOWN_TEXT = preload("uid://c762pif0pw7e5")
const ROUND_COMPLETE_SCREEN = preload("uid://ba8w116ntbkex")
const NEXT_UP_CONTAINER_BASE = preload("uid://dmffrccp1rsgw")
const NEXT_UP_CONTAINER_CURRENT = preload("uid://cuc63iatlc1ai")
const POTION_BOTTLING = preload("uid://c47r5qe8xe2ah")

var round_time: float
var drawing_scene: Node
var typing_scene: Node
var bottling_scene: Node
var results_scene: Node
var selected_potion: Potion
@onready var demand_label: RichTextLabel = $GameDetailsContainer/VBoxContainer/DemandLabel
@onready var potion_label: Label = $GameDetailsContainer/VBoxContainer/PotionLabel
@onready var next_up_h_box: HBoxContainer = $NextUpContainer/HBoxContainer

func _ready() -> void:
	GameEvents.complete_attempt.connect(_on_complete_attempt)
	GameEvents.next_round.connect(_on_next_round)
	start_round()
	start_turn()

func _process(_delta: float) -> void:
	$RoundTimeProgress.value = 100 * ($RoundTimer.time_left / round_time)

func _on_complete_attempt(successful: bool) -> void:
	if successful:
		GameInfo.update_time_left($RoundTimer.time_left)
		# to ensure there isnt any weird carry-over stuff from previous varients of that minigame
		todo: fix what i broke here... (and make it less repetative)
		if GameInfo.get_current_minigame().minigame_type == Minigame.MinigameTypes.TYPING and typing_scene != null:
			typing_scene.queue_free()
		elif GameInfo.get_current_minigame().minigame_type == Minigame.MinigameTypes.DRAWING and drawing_scene != null:
			drawing_scene.queue_free()
		elif GameInfo.get_current_minigame().minigame_type == Minigame.MinigameTypes.BOTTLING and bottling_scene != null:
			bottling_scene.queue_free()
		GameInfo.increment_turn()
		if GameInfo.round_over:
			results_scene = ROUND_COMPLETE_SCREEN.instantiate()
			add_child(results_scene)
			$RoundTimer.stop()
		else:
			start_turn()

func _on_next_round() -> void:
	results_scene.queue_free()
	GameInfo.increment_round()
	start_turn()
	start_round()

func start_turn() -> void:
	var minigame: Minigame = GameInfo.get_current_minigame()
	var countdown = COUNTDOWN_TEXT.instantiate()
	var scene: Node
	var text: String

	match minigame.minigame_type:
		Minigame.MinigameTypes.TYPING:
			scene = minigame.scene.instantiate()
			text = "Type!"

		Minigame.MinigameTypes.DRAWING:
			scene = DRAWING_SCREEN.instantiate()
			text = "Draw!"

		Minigame.MinigameTypes.BOTTLING:
			scene = POTION_BOTTLING.instantiate()
			text = "Bottle!"

	add_child(scene)
	countdown.start_animation(text)
	add_child(countdown)

	var current_ingredient_position = GameInfo.total_ingredient_step
	# currently on round 2 onwards there is no green highlight. i dont know why this is but that should be fixed
	var current_next_box: PanelContainer = next_up_h_box.get_child(current_ingredient_position)
	current_next_box.add_theme_stylebox_override("panel", NEXT_UP_CONTAINER_CURRENT)
	if current_ingredient_position > 0:
		next_up_h_box.get_child(current_ingredient_position - 1).add_theme_stylebox_override("panel", NEXT_UP_CONTAINER_BASE)

func start_round() -> void:
	demand_label.text = str(9 - GameInfo.round_num) + " left"
	selected_potion = GameInfo.current_round_details.selected_potion
	round_time = (GameInfo.MAX_TIME * selected_potion.potion_time_modification) / (1 + (((float)(GameInfo.round_num)) / 10))
	$RoundTimer.start(round_time)
	potion_label.text = selected_potion.name
	# clean up from possible previous rounds
	# todo: make this coloured red or something for the turn the player is currently on
	for child: Node in next_up_h_box.get_children():
		child.queue_free()
	for ingredient: Ingredient in selected_potion.ingredients:
		for minigame: Minigame in ingredient.preperation_minigames:
			var next_up_container: PanelContainer = PanelContainer.new()
			next_up_container.add_theme_stylebox_override("panel", NEXT_UP_CONTAINER_BASE)
			var next_up_symbol = TextureRect.new()
			if (minigame.minigame_type == Minigame.MinigameTypes.TYPING):
				next_up_symbol.texture = KNIFE
			else:
				next_up_symbol.texture = DRAWING
			next_up_container.add_child(next_up_symbol)
			next_up_h_box.add_child(next_up_container)


func _on_round_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/lose_screen.tscn")
