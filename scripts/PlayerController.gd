extends KinematicBody2D

export (int) var speed = 125
var velocity = Vector2()

var numKeys = 0
var inRangeOfDoor = false

var enemies = []
var canFear = true
var fearCooldown

var canPossess = true
var possessCooldown

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		if canPossess:
			$PlayerSprite.play("right")
		else:
			$PlayerSprite.play("possess_right")
		velocity.x += 1
	if Input.is_action_pressed('left'):
		if canPossess:
			$PlayerSprite.play("left")
		else:
			$PlayerSprite.play("possess_left")
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
		if !canPossess:
			$PlayerSprite.play("possess_down")
	if Input.is_action_pressed('up'):
		velocity.y -= 1
		if !canPossess:
			$PlayerSprite.play("possess_up")
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
			fear_timer_cooldown.connect("timeout", self, "_on_fear_timer_timeout")
			add_child(fear_timer_cooldown)
			fear_timer_cooldown.start()
	
	if Input.is_action_pressed('possess'):
		if canPossess:
			possess()
			canPossess = false
			var possess_timer_cooldown
			var possess_cooldown = 10
			possess_timer_cooldown = Timer.new()
			possess_timer_cooldown.set_one_shot(true)
			possess_timer_cooldown.set_wait_time(possess_cooldown)
			possess_timer_cooldown.connect("timeout", self, "_on_possess_timer_timeout")
			add_child(possess_timer_cooldown)
			possess_timer_cooldown.start()
			
	if Input.is_action_pressed("use_door"):
		if numKeys == get_parent().numKeys and inRangeOfDoor:
			LevelManager.loadNextLevel()

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func fear():
	for e in range(enemies.size()):
		enemies[e].feared = true

func possess():
	var closest_distance = null
	var location = Vector2()
	var index
	for e in range(enemies.size()):
		var offset = enemies[e].position - position
		var distance = offset.length()
		if closest_distance == null:
			closest_distance = distance
			location = enemies[e].position
			index = e
		if distance < closest_distance:
			closest_distance = distance
			location = enemies[e].position
			index = e
	if closest_distance != null:
		position = location
		$PlayerSprite.play("possess")
		enemies[index].queue_free()

func _on_SpellRadius_body_entered(body):
	if body.is_in_group("Enemies"):
		enemies.push_back(body)

func _on_SpellRadius_body_exited(body):
	if body.is_in_group("Enemies"):
		enemies.remove(enemies.find(body))

func pick_up_key():
	numKeys += 1
	
func _on_fear_timer_timeout():
	canFear = true
	print("Can Fear")
	
func _on_possess_timer_timeout():
	canPossess = true
	print("Can Possess")
	$PlayerSprite.play("right")
