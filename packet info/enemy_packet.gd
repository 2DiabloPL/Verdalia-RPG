class_name EnemyPacket extends PacketInfo

var id
var position: Vector2
var animation_state: int
var HP
var MaxHP

static func create(id_:int, position_: Vector2, animation_state_: int, HP_:int, MaxHP_:int) -> EnemyPacket:
	var info: EnemyPacket = EnemyPacket.new()
	#print(enemy_.HP,' / ', enemy_.MaxHP)
	info.packet_type = PACKET_TYPE.ENEMY_PACKET
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.id = id_
	info.HP = HP_
	info.MaxHP =MaxHP_
	info.position = position_
	info.animation_state = animation_state_
	return info

static func create_from_data(data: PackedByteArray) -> EnemyPacket:
	var info: EnemyPacket = EnemyPacket.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(15) # 1 bajt id, 8 bajtów pozycja, 1 bajt animacja, 4 HP, 4 MaxHP
	data.encode_u8(1, id)
	data.encode_float(2, position.x)
	data.encode_float(6, position.y)
	data.encode_u8(10, animation_state)
	data.encode_u16(11, HP)
	data.encode_u16(13, MaxHP)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	position = Vector2(data.decode_float(2), data.decode_float(6))
	animation_state = data.decode_u8(10)
	HP = data.decode_u16(11)
	MaxHP = data.decode_u16(13)
