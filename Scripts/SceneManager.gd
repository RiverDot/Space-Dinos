extends Node2D

@export var MenuScene: PackedScene

@export var GameScene: PackedScene

enum Scene { MENU, GAME }

var current_scene = Scene.GAME # set to game to be able to change to menu

var current_scene_node: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_change_scene(Scene.MENU)

func _change_scene(scene: Scene):

	if current_scene == scene:
		return

	if current_scene_node != null:
		current_scene_node.queue_free()

	var new_scene = null

	if scene == Scene.MENU:
		new_scene = MenuScene.instantiate()
	elif scene == Scene.GAME:
		new_scene = GameScene.instantiate()

	add_child(new_scene)
	current_scene_node = new_scene

	current_scene = scene

	
