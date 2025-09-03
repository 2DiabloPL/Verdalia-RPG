# PlayerManager.gd
extends Node
class_name PlayerManager

var players: Array = []

func add_player(player: Player) -> void:
	players.append(player)
	#print(players)
func remove_player(player: Player) -> void:
	players.erase(player)
	

func get_player_by_id(owner_id: int) -> Player:
	for p in players:
		if p.owner_id == owner_id:
			return p
	return null
	
func get_all_player():
	return players
