extends Node

signal handle_player_position(peer_id:int, player_position: PlayerPosition)
signal handle_player_animation(peer_id: int, player_animation: PlayerAnimation)
signal handle_player_attack(peer_id: int, player_attack: PlayerAttack )
signal handle_player_stats(peer_id:int, player_stats: PlayerStatsPacket)
signal handle_enemy_packet(peer_id: int, enemy_packet: EnemyPacket)


var peer_ids: Array[int]

func _ready() -> void:
	NetworkHandling.on_peer_connected.connect(on_peer_connected)
	NetworkHandling.on_peer_disconnected.connect(on_peer_disconnected)
	NetworkHandling.on_server_packet.connect(on_server_packet)

func on_peer_connected(peer_id:int)-> void:
	peer_ids.append(peer_id)
	
	IDAssignment.create(peer_id, peer_ids).broadcast(NetworkHandling.connection)
	
func on_peer_disconnected(peer_id:int)-> void:
	peer_ids.erase(peer_id)
	PlayerManagerGlobal.remove_player(instance_from_id(peer_id))

func on_server_packet(peer_id:int, data: PackedByteArray)-> void:
	var packet_type: int = data.decode_u8(0)
	#print("📦 Otrzymano pakiet od:", peer_id, " typ:", packet_type, " raw:", data)
	match packet_type:
		PacketInfo.PACKET_TYPE.PLAYER_POSITION:
			handle_player_position.emit(peer_id, PlayerPosition.create_from_data(data))
		
		PacketInfo.PACKET_TYPE.PLAYER_ANIMATION:
			handle_player_animation.emit(peer_id, PlayerAnimation.create_from_data(data))
		
		PacketInfo.PACKET_TYPE.PLAYER_ATTACK:
			handle_player_attack.emit(peer_id, PlayerAttack.create_from_data(data))
			
		PacketInfo.PACKET_TYPE.PLAYER_STATS:
			handle_player_stats.emit(peer_id, PlayerStatsPacket.create_from_data(data))
		
		PacketInfo.PACKET_TYPE.ENEMY_PACKET:
			handle_enemy_packet.emit(peer_id, EnemyPacket.create_from_data(data))
			
		
		
		_:
			push_error('Packet type with index ', data[0], ' unhandled!')
