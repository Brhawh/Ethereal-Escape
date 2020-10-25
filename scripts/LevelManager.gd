extends Node

var currentScene = null
var levelNumber = 1
var lastLevelNumber = 3

func _ready():
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	
func loadNextLevel():
	call_deferred("_loadNextLevelDeferred")
	
func _loadNextLevelDeferred():
	levelNumber += 1
	var pathToNewScene = "res://scenes/Level" + str(levelNumber) + ".tscn"
	if levelNumber > lastLevelNumber:
		pathToNewScene = "res://scenes/YouWin.tscn"
	currentScene.free()
	var newScene = ResourceLoader.load(pathToNewScene)
	currentScene = newScene.instance()
	get_tree().get_root().add_child(currentScene)
	get_tree().set_current_scene(currentScene)
