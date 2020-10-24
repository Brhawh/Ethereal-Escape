extends KinematicBody2D

export (int) var speed = 350
var velocity = Vector2()
var hasKey = false
var enemies = []

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
		fear()

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	print(enemies.size())

func fear():
	pass

func _on_SpellRadius_body_entered(body):
	if body.is_in_group("Enemies"):
		enemies.push_back(body)


func _on_SpellRadius_body_exited(body):
	if body.is_in_group("Enemies"):
		enemies.remove(enemies.find(body))

func pick_up_key():
	hasKey = true
