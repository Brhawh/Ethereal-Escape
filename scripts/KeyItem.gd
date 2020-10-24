extends Area2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.pick_up_key()
		queue_free()
