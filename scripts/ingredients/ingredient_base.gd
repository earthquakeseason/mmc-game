class_name Ingredient
extends Resource

@export var name: String
@export_enum("CRUSH", "ESSENCE_EXTRACTION", "HEAT", "JUICED", "CUT") var primary_preperation_type
@export_enum("CRUSH", "ESSENCE_EXTRACTION", "HEAT", "JUICED", "NONE") var secondary_prepration_type
