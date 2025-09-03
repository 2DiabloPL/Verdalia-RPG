extends CharacterBody2D
class_name Enemy

@export var name_enemy: String
@export var MaxHP: int = 100
@export var anim: AnimatedSprite2D
@export var damage: int = 10
@export var speed: int 
@export var health_bar: ProgressBar
@export var detection_area: Area2D
@export var attack_cooldown: int
@export var exp_value: int
var enemy_id: int
var is_replica:bool = false
var alive = true

var player= null
var is_attacking: bool = false
var player_chase: bool = false

var anim_state:int	 #0 idle, 1 run, 2 atak, 3 hit, 4 śmierć
var przeciwnicy_w_polu:Array[Player] =  []
var przeciwnicy_w_polu_detekcji:Array[Player] =[]
func enemy():
	pass

var took_dmg_from = {}
var HP =0


#signal give_exp(amount)



func _ready() -> void:
	HP = MaxHP
	health_bar.max_value = MaxHP
	health_bar.value = HP
	anim_state = 0
	alive = true
	
var distance
func _physics_process(_delta):
	if przeciwnicy_w_polu_detekcji == []: player_chase = false
	if is_replica: return
	if is_attacking: return
	if !przeciwnicy_w_polu_detekcji.is_empty(): 
		player = przeciwnicy_w_polu_detekcji[0]
		player_chase = true
	if !player_chase: 
		anim_state = 0
		EnemyPacket.create(enemy_id,position, anim_state, HP, MaxHP).broadcast(NetworkHandling.connection)
		return
		
	if player_chase: anim_state = 1
	
	
	
	
	obroc()
	position += (player.position - position).normalized()*  speed* _delta
	
	EnemyPacket.create(enemy_id,position, anim_state, HP, MaxHP).broadcast(NetworkHandling.connection)


func _start_attack():
	if is_replica: return
	while !przeciwnicy_w_polu.is_empty():
		if HP<1: return
		obroc()
		is_attacking = true
		velocity = Vector2.ZERO
		anim_state = 2
		EnemyPacket.create(enemy_id,position, anim_state, HP, MaxHP).broadcast(NetworkHandling.connection)
		if alive:
			await get_tree().create_timer(1.1).timeout
			for p in przeciwnicy_w_polu:
				player.take_damage(damage, player)
		
		# timer na koniec animacji
		await get_tree().create_timer(1.2).timeout
		anim_state = 0
		EnemyPacket.create(enemy_id,position, anim_state, HP, MaxHP).broadcast(NetworkHandling.connection)
		await get_tree().create_timer(attack_cooldown).timeout
		is_attacking = false
		
func take_damage(amount: int, player_):
	print('obrywa')
	if is_replica: return
	if took_dmg_from.has(player_): took_dmg_from[player_] = took_dmg_from[player_] + amount
	else: took_dmg_from[player_] = amount
	
	HP -= amount
	health_bar.value = HP
	
	if HP>0: 
		anim_state = 3
		#print(HP,' ma wiecej niz 0')
		
		EnemyPacket.create(enemy_id,position, anim_state, HP, MaxHP).broadcast(NetworkHandling.connection)
		await get_tree().create_timer(0.8).timeout
	if HP < 1:
		anim.stop()
		anim_state = 4
		health_bar.visible = false
		alive=false
		giving_exp()
		await get_tree().create_timer(2.8).timeout
		
		queue_free()
 
	#print(HP, '  ogolnie')
	anim_state = 0
	EnemyPacket.create(enemy_id,position, anim_state, HP, MaxHP).broadcast(NetworkHandling.connection)
	#print(HP)
	
	


func _on_detection_area_body_entered(body: Node2D) -> void:
	przeciwnicy_w_polu_detekcji.append(body)
	player = przeciwnicy_w_polu_detekcji[0] if przeciwnicy_w_polu_detekcji[0] else null
	player_chase = true
	
	

func _on_detection_area_body_exited(body: Node2D) -> void:
	przeciwnicy_w_polu_detekcji.erase(body)
	player_chase = false
	#print('cos wyszlos')


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		przeciwnicy_w_polu.append(body)
		if !is_attacking: _start_attack()
		player_chase = false


func _on_attack_area_body_exited(body: Node2D) -> void:
	przeciwnicy_w_polu.erase(body)
	
func obroc():
	if !player: return
	if player.position.x < position.x: anim.flip_h = false      
	if player.position.x > position.x: anim.flip_h = true
	
func giving_exp():
	for osoba in took_dmg_from.keys():
		var amount = exp_value * (took_dmg_from[osoba] / MaxHP)
		#print("Amount %d, exp %d, dmg %d, Hp %d" % [amount, exp_value, took_dmg_from[osoba], maxHP])
		#stat.emit_signal("give_exp", osoba, amount)
	
