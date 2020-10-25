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

var feared = false
var spawnPos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnPos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if feared:
		var fear_timer
		var fear_duration = 4
		fear_timer = Timer.new()
		fear_timer.set_one_shot(true)
		fear_timer.set_wait_time(fear_duration)
		fear_timer.connect("timeout", self, "_on_timer_timeout")
		add_child(fear_timer)
		fear_timer.start()
		path = nav2d.get_simple_path(global_position, spawnPos)
	else:
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


func _on_timer_timeout():
	feared = false
