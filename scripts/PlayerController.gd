extends KinematicBody2D

export (int) var speed = 350
var velocity = Vector2()
var hasKey = false
var enemies = []
var canFear = true
var fearCooldown

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		$PlayerSprite.play("right")
		velocity.x += 1
	if Input.is_action_pressed('left'):
		$PlayerSprite.play("left")
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	if Input.is_action_pressed('fear'):
		if canFear:
			fear()
			canFear = false
			var fear_timer_cooldown
			var fear_cooldown = 10
			fear_timer_cooldown = Timer.new()
			fear_timer_cooldown.set_one_shot(true)
			fear_timer_cooldown.set_wait_time(fear_cooldown)
			fear_timer_cooldown.connect("timeout", self, "_on_timer_timeout")
			add_child(fear_timer_cooldown)
			fear_timer_cooldown.start()

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func fear():
	for e in range(enemies.size()):
		enemies[e].feared = true

func _on_SpellRadius_body_entered(body):
	if body.is_in_group("Enemies"):
		enemies.push_back(body)


func _on_SpellRadius_body_exited(body):
	if body.is_in_group("Enemies"):
		enemies.remove(enemies.find(body))

func pick_up_key():
	hasKey = true
	
func _on_timer_timeout():
	canFear = true
	print("Can Fear")
