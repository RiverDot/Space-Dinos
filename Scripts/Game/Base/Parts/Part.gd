extends Resource

class_name Part

@export var id: int

@export var name: String

@export var node: PackedScene

@export_flags("Core", "Hull", "Mobility", "Fuel", "Defence") var part_category: int

@export var cost: int

@export var limit: int

@export var size: Vector2