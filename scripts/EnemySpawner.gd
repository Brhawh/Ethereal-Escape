extends Node2D

export (int) var spawn_cool_down = 3
export (PackedScene) var spawn_scene

onready var spawn_pos = get_node("Position2D")
var spawn_timer
var should_spawn = true
export (NodePath) var nav2dPath
export (NodePath) var targetPath

var target
var nav2d

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.set_one_shot(false)
	spawn_timer.set_wait_time(spawn_cool_down)
	spawn_timer.connect("timeout", self, "_on_timer_timeout")
	add_child(spawn_timer)
	spawn_timer.start()
	target = get_node(targetPath)
	nav2d = get_node(nav2dPath)
	print(nav2d)
	
	
func _on_timer_timeout():
	var spawnedNode = spawn_scene.instance()
	spawnedNode.global_position = spawn_pos.global_position
	spawnedNode.nav2d = nav2d
	spawnedNode.speed = 100
	spawnedNode.target = target
	get_parent().add_child(spawnedNode)
