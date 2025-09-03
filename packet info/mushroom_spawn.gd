extends Area2D

@export var spawn_location: Marker2D
var _mushroom_scene = preload("res://scenes/Mushroom.tscn")
var spawn_radius: float = 50.0
var next_enemy_id := 1
func _ready() -> void:
	print('Spawnuje coś')
	_create_mushroom()

func _create_mushroom():
	var mushroom_to_spawn = _mushroom_scene.instantiate()
	var offset_x = randf_range(-spawn_radius, spawn_radius)
	var offset_y = randf_range(-spawn_radius, spawn_radius)
	mushroom_to_spawn.position = spawn_location.position + Vector2(offset_x, offset_y)
	mushroom_to_spawn.enemy_id = next_enemy_id
	next_enemy_id +=1
	
	
	call_deferred("add_child", mushroom_to_spawn)
	EnemyManagerGlobal.add_enemy(mushroom_to_spawn)
	EnemyPacket.create(mushroom_to_spawn.enemy_id, mushroom_to_spawn.position, 0, mushroom_to_spawn.HP, mushroom_to_spawn.MaxHP).broadcast(NetworkHandling.connection)
