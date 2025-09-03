# PlayerManager.gd
extends Node
class_name EnemyManager

var enemies: Array = []

func add_enemy(enemy: Enemy) -> void:
	enemies.append(enemy)
	#print(players)
func remove_enemy(enemy: Enemy) -> void:
	enemies.erase(enemy)
	

func get_enemy_by_id(enemy_id: int) -> Enemy:
	for e in enemies:
		if e.enemy_id == enemy_id:
			return e
	return null
	
func get_all_enemies():
	return enemies
