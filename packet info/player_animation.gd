class_name PlayerAnimation extends PacketInfo

var id: int
var animation_state: int #0 Idle, 1 Down, 2 DownLeft, 3 DownRight, 4 Left, 5 Right, 6 Up, 7 UpLeft, 8 UpRight, 9 SlashDownLeft, 10 SlashDownRight, 11 SlashUpLeft, 12 SlashUpRight

static func create(id: int, animation_state: int) -> PlayerAnimation:
	var info: PlayerAnimation = PlayerAnimation.new()
	info.packet_type = PACKET_TYPE.PLAYER_ANIMATION
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.id = id
	info.animation_state = animation_state
	#print(info)
	return info

static func create_from_data(data: PackedByteArray) -> PlayerAnimation:
	var info: PlayerAnimation = PlayerAnimation.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(4)  # 1 bajt typ + 1 bajt id + 1 bajt animacja (dostosuj jeśli potrzebujesz więcej)
	data.encode_u8(1, id)
	data.encode_u8(2, animation_state)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	animation_state = data.decode_u8(2)
