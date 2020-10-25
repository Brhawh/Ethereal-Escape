extends Area2D

var tileMap

func _on_DoorInteractionArea2D_body_entered(body):
	if body.name == "Player":
		tileMap.set_cellv(tileMap.world_to_map((global_position / tileMap.scale) - Vector2(0, tileMap.cell_size.y)), tileMap.get_tileset().find_tile_by_name("DoorSelected"))
		body.inRangeOfDoor = true

func _on_DoorInteractionArea2D_body_exited(body):
	if body.name == "Player":
		tileMap.set_cellv(tileMap.world_to_map((global_position / tileMap.scale) - Vector2(0, tileMap.cell_size.y)), tileMap.get_tileset().find_tile_by_name("Door"))
		body.inRangeOfDoor = false
