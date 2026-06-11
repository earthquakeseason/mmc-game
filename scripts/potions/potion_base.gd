class_name Potion
extends Resource

@export var name: String
@export var ingredients: Array[Ingredient]
@export_enum("HOT", "COLD", "NONE") var final_conditions: String
