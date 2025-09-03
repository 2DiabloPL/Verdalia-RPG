class_name PlayerAttack
extends PacketInfo

var our_id: int
var enemy_id: int
var damage: int



# Tworzenie pakietu do wysłania
static func create(attacker_id: int, target_id: int, damage: int) -> PlayerAttack:
	var attack: PlayerAttack = PlayerAttack.new()
	attack.packet_type = PACKET_TYPE.PLAYER_ATTACK
	attack.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	attack.our_id = attacker_id
	attack.enemy_id = target_id
	attack.damage = damage
	return attack

# Tworzenie pakietu z odebranych danych
static func create_from_data(data: PackedByteArray) -> PlayerAttack:
	var attack: PlayerAttack = PlayerAttack.new()
	attack.decode(data)
	return attack

# Serializacja danych
func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(5) # 1 bajt typ + 1 bajt attacker_id + 1 bajt target_id  + 2 bajty damage
	data.encode_u8(1, our_id)
	data.encode_u8(2, enemy_id)
	data.encode_u16(3, damage)
	return data

# Deserializacja danych
func decode(data: PackedByteArray) -> void:
	super.decode(data)
	our_id = data.decode_u8(1)
	enemy_id = data.decode_u8(2)
	damage = data.decode_u16(3)
