extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var health = 10
export (float) var speed = 0.01

onready var target
onready var nav2d

var path = []
var path_points = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	path = nav2d.get_simple_path(global_position, target.global_position)
	if path.size() < path_points:
		print("no transition")
	
	path_points = path.size()
	
	if path_points < 2: 
		print("early ret")
		return

	global_position += global_position.direction_to(path[1]) * speed
	
	update()
