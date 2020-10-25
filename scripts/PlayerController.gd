extends KinematicBody2D

export (int) var speed = 125
var velocity = Vector2()

var numKeys = 0
var inRangeOfDoor = false

var enemies = []
var canFear = true
var fearCooldown = 10

var canPossess = true
var possessCooldown = 10
var possessDuration = 5
var detectable = true

var canPhantasmalFlight = true
var phantasmalFlightCooldown = 10
var phantasmalFlightDuration = 5

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		if detectable:
			$PlayerSprite.play("right")
		else:
			$PlayerSprite.play("possess_right")
		velocity.x += 1
	if Input.is_action_pressed('left'):
		if detectable:
			$PlayerSprite.play("left")
		else:
			$PlayerSprite.play("possess_left")
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
		if !detectable:
			$PlayerSprite.play("possess_down")
	if Input.is_action_pressed('up'):
		velocity.y -= 1
		if !detectable:
			$PlayerSprite.play("possess_up")
	velocity = velocity.normalized() * speed
	
	if Input.is_action_pressed('fear'):
		if canFear:
			fear()
			canFear = false
			var fear_timer_cooldown
			fear_timer_cooldown = Timer.new()
			fear_timer_cooldown.set_one_shot(true)
			fear_timer_cooldown.set_wait_time(fearCooldown)
			fear_timer_cooldown.connect("timeout", self, "_on_fear_timer_timeout")
			add_child(fear_timer_cooldown)
			fear_timer_cooldown.start()
	
	if Input.is_action_pressed('possess'):
		if canPossess:
			possess()
			canPossess = false
			var possess_timer_cooldown
			possess_timer_cooldown = Timer.new()
			possess_timer_cooldown.set_one_shot(true)
			possess_timer_cooldown.set_wait_time(possessCooldown)
			possess_timer_cooldown.connect("timeout", self, "_on_possess_timer_timeout")
			add_child(possess_timer_cooldown)
			possess_timer_cooldown.start()
			var possess_timer_duration
			possess_timer_duration = Timer.new()
			possess_timer_duration.set_one_shot(true)
			possess_timer_duration.set_wait_time(possessDuration)
			possess_timer_duration.connect("timeout", self, "_on_possess_timer_duration_timeout")
			add_child(possess_timer_duration)
			possess_timer_duration.start()
			
	if Input.is_action_pressed("use_door"):
		if numKeys == get_parent().numKeys and inRangeOfDoor:
			LevelManager.loadNextLevel()

	if Input.is_action_pressed('phantasmal flight'):
		if canPhantasmalFlight:
			canPhantasmalFlight = false
			var phantasmal_timer_cooldown
			phantasmal_timer_cooldown = Timer.new()
			phantasmal_timer_cooldown.set_one_shot(true)
			phantasmal_timer_cooldown.set_wait_time(phantasmalFlightCooldown)
			phantasmal_timer_cooldown.connect("timeout", self, "_on_phantasmal_timer_timeout")
			add_child(phantasmal_timer_cooldown)
			phantasmal_timer_cooldown.start()
			var phantasmal_timer_duration
			phantasmal_timer_duration = Timer.new()
			phantasmal_timer_duration.set_one_shot(true)
			phantasmal_timer_duration.set_wait_time(phantasmalFlightDuration)
			phantasmal_timer_duration.connect("timeout", self, "_on_phantasmal_timer_duration_timeout")
			add_child(phantasmal_timer_duration)
			phantasmal_timer_duration.start()
			phantasmal_flight()

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
		$PlayerSprite.play("possess_down")
		enemies[index].queue_free()
		detectable = false

func phantasmal_flight():
	set_collision_layer_bit(0, false)

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
	
func _on_possess_timer_timeout():
	canPossess = true
	
func _on_possess_timer_duration_timeout():
	$PlayerSprite.play("right")
	detectable = true
	
func _on_phantasmal_timer_timeout():
	canPhantasmalFlight = true
	
func _on_phantasmal_timer_duration_timeout():
	position = get_parent().get_node("Navigation2D").get_closest_point(position)
	set_collision_layer_bit(0, true)
