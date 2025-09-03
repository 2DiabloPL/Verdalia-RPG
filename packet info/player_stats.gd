class_name PlayerStatsPacket extends PacketInfo

var id: int

# HP / MP / SP
var HP: int
var MaxHP: int
var MP: int
var MaxMP: int
var SP: int
var MaxSP: int

# Poziomy i doświadczenie
var LVL: int
var expLVL: float
var LVLK: int
var expKLVL: float
var LVLD: int
var expDLVL: float
var LVLP: int

# Podstawowe statystyki
var STR: int
var INT: int
var WIS: int
var VIT: int
var DEX: int
var DEF: int
var PER: int
var SPD: int
var CRT: int
var CRTD: int
var CRV: int


static func create(player: Node) -> PlayerStatsPacket:
	var pkt := PlayerStatsPacket.new()
	pkt.packet_type = PACKET_TYPE.PLAYER_STATS
	pkt.flag = ENetPacketPeer.FLAG_UNSEQUENCED

	pkt.id = player.owner_id
	pkt.HP = player.HP
	pkt.MaxHP = player.MaxHP
	pkt.MP = player.MP
	pkt.MaxMP = player.MaxMP
	pkt.SP = player.SP
	pkt.MaxSP = player.MaxSP

	pkt.LVL = player.LVL
	pkt.expLVL = player.expLVL
	pkt.LVLK = player.LVLK
	pkt.expKLVL = player.expKLVL
	pkt.LVLD = player.LVLD
	pkt.expDLVL = player.expDLVL
	pkt.LVLP = player.LVLP

	pkt.STR = player.STR
	pkt.INT = player.INT
	pkt.WIS = player.WIS
	pkt.VIT = player.VIT
	pkt.DEX = player.DEX
	pkt.DEF = player.DEF
	pkt.PER = player.PER
	pkt.SPD = player.SPD
	pkt.CRT = player.CRT
	pkt.CRTD = player.CRTD
	pkt.CRV = player.CRV

	return pkt


static func create_from_data(data: PackedByteArray) -> PlayerStatsPacket:
	var pkt := PlayerStatsPacket.new()
	pkt.decode(data)
	return pkt


func encode() -> PackedByteArray:
	var data := super.encode()
	data.resize(50) # dostosuj rozmiar w zależności od ilości danych

	var offset := 1
	data.encode_u8(offset, id)
	offset += 1
	data.encode_u16(offset, HP)
	offset += 2
	data.encode_u16(offset, MaxHP)
	offset += 2
	data.encode_u16(offset, MP)
	offset += 2
	data.encode_u16(offset, MaxMP)
	offset += 2
	data.encode_u16(offset, SP)
	offset += 2
	data.encode_u16(offset, MaxSP)
	offset += 2

	data.encode_u8(offset, LVL)
	offset += 1
	data.encode_float(offset, expLVL)
	offset += 4
	data.encode_u8(offset, LVLK)
	offset += 1
	data.encode_float(offset, expKLVL)
	offset += 4
	data.encode_u8(offset, LVLD)
	offset += 1
	data.encode_float(offset, expDLVL)
	offset += 4
	data.encode_u8(offset, LVLP)
	offset += 1

	data.encode_u8(offset, STR)
	offset += 1
	data.encode_u8(offset, INT)
	offset += 1
	data.encode_u8(offset, WIS)
	offset += 1
	data.encode_u8(offset, VIT)
	offset += 1
	data.encode_u8(offset, DEX)
	offset += 1
	data.encode_u8(offset, DEF)
	offset += 1
	data.encode_u8(offset, PER)
	offset += 1
	data.encode_u8(offset, SPD)
	offset += 1
	data.encode_u8(offset, CRT)
	offset += 1
	data.encode_u8(offset, CRTD)
	offset += 1
	data.encode_u8(offset, CRV)
	offset += 1

	return data


func decode(data: PackedByteArray) -> void:
	var offset := 1
	id = data.decode_u8(offset)
	offset += 1
	HP = data.decode_u16(offset)
	offset += 2
	MaxHP = data.decode_u16(offset)
	offset += 2
	MP = data.decode_u16(offset)
	offset += 2
	MaxMP = data.decode_u16(offset)
	offset += 2
	SP = data.decode_u16(offset)
	offset += 2
	MaxSP = data.decode_u16(offset)
	offset += 2

	LVL = data.decode_u8(offset)
	offset += 1
	expLVL = data.decode_float(offset)
	offset += 4
	LVLK = data.decode_u8(offset)
	offset += 1
	expKLVL = data.decode_float(offset)
	offset += 4
	LVLD = data.decode_u8(offset)
	offset += 1
	expDLVL = data.decode_float(offset)
	offset += 4
	LVLP = data.decode_u8(offset)
	offset += 1

	STR = data.decode_u8(offset)
	offset += 1
	INT = data.decode_u8(offset)
	offset += 1
	WIS = data.decode_u8(offset)
	offset += 1
	VIT = data.decode_u8(offset)
	offset += 1
	DEX = data.decode_u8(offset)
	offset += 1
	DEF = data.decode_u8(offset)
	offset += 1
	PER = data.decode_u8(offset)
	offset += 1
	SPD = data.decode_u8(offset)
	offset += 1
	CRT = data.decode_u8(offset)
	offset += 1
	CRTD = data.decode_u8(offset)
	offset += 1
	CRV = data.decode_u8(offset)
	offset += 1


signal give_exp(amount)
