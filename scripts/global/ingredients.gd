extends Node

var all_ingredients: Array[Ingredient]

func _ready() -> void:
	# https://docs.godotengine.org/en/stable/classes/class_diraccess.html
	var dir = DirAccess.open("res://resources/ingredients/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.split(".", false)[1] == "tres":
				all_ingredients.append(load("res://resources/ingredients/" + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
