extends TileMap

onready var door_scene = preload("res://scenes/Door.tscn")

func _ready():
	generate_doors()

func spawn_door(tile_position: Vector2):
	var door = door_scene.instance()
	var world_pos = map_to_world(tile_position)
	door.global_position =  world_pos + Vector2(8, 24)
	print(door.global_position, world_pos)
	add_child(door)
	door.tileMap = self
	
func generate_doors() -> void:
	for tile_position in get_used_cells():
		if get_cellv(tile_position) == tile_set.find_tile_by_name("Door"):
			print("spawning door")
			spawn_door(tile_position)
