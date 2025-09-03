extends Node

const PLAYER = preload("res://scenes/player.tscn")


func _ready() -> void:
	NetworkHandling.on_peer_connected.connect(spawn_player)
	ClientNetworkGlobal.handle_local_id_assignment.connect(spawn_player)
	ClientNetworkGlobal.handle_remote_id_assignment.connect(spawn_player)


func spawn_player(id: int) -> void:
	if has_node(str(id)): return
	#print('spawnuje ludka')
	var player = PLAYER.instantiate()
	player.owner_id = id
	player.name = str(id) # optional
	player.global_position = Vector2(400, 200)
	
	
	call_deferred("add_child", player)
	PlayerManagerGlobal.add_player(player)
