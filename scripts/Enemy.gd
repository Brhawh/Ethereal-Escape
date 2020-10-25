extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var health = 10
export (float) var speed

onready var target
onready var nav2d

var path = []
var path_points = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_rotation(0)
	
	path = nav2d.get_simple_path(global_position, target.global_position)
	if path.size() < path_points:
		print("no transition")
	
	path_points = path.size()
	
	if path_points < 2: 
		print("early ret")
		return
	var direction = global_position.direction_to(path[1])
	linear_velocity = direction * speed
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite.play("right")
		elif direction.x < 0: 
			$AnimatedSprite.play("left")
	else:
		if direction.y > 0:
			$AnimatedSprite.play("down")
		elif direction.y < 0:
			$AnimatedSprite.play("up")
	update()
