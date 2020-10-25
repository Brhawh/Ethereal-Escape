extends RigidBody2D

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
	
	var bodies=get_colliding_bodies()
	for bod in bodies:
		print(bod.get_name())
	
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
	if target.detectable == false:
		var idle_timer
		var idle_duration = 4
		idle_timer = Timer.new()
		idle_timer.set_one_shot(true)
		idle_timer.set_wait_time(idle_duration)
		idle_timer.connect("timeout", self, "_on_idle_timer_timeout")
		add_child(idle_timer)
		idle_timer.start()
		path = nav2d.get_simple_path(global_position, spawnPos)
	else:
		path = nav2d.get_simple_path(global_position, target.global_position)
	
	path_points = path.size()
	
	if path_points < 2:
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

func _on_idle_timer_timeout():
	pass

func _on_Enemy_body_entered(body):
	if body.name == "Player" && target.detectable == true:
		get_tree().change_scene("res://scenes/YouDied.tscn")
