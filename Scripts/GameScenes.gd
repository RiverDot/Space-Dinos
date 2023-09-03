extends Node2D

@export var BaseScene: PackedScene

@export var FlightScene: PackedScene

enum Scene { BASE, FLIGHT }

var current_scene = Scene.FLIGHT # set to flight to be able to set base

var current_scene_node: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_change_scene(Scene.BASE)

func _change_scene(scene: Scene):

	if current_scene == scene:
		return

	if current_scene_node != null:
		current_scene_node.queue_free()

	var new_scene = null

	if scene == Scene.BASE:
		new_scene = BaseScene.instantiate()
	elif scene == Scene.FLIGHT:
		new_scene = FlightScene.instantiate()

	add_child(new_scene)
	current_scene_node = new_scene

	current_scene = scene

	get_tree().get_first_node_in_group("PauseScreen")._update_buttons(current_scene)

	
