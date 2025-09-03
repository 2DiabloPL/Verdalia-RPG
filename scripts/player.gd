extends CharacterBody2D
class_name Player
@onready var health_bar: ProgressBar = $Bary/HealthBar
@onready var stamina_bar: ProgressBar = $Bary/StaminaBar
@onready var mana_bar: ProgressBar = $Bary/ManaBar
@onready var enemy_health_bar: ProgressBar = $Bary/EnemyHealthBar

var _stat_tick := 0
@onready var stats: Control = $Stats
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var alive = true
@onready var mieczyk: AnimatedSprite2D = $AnimatedSprite2D2

var enemies_in_attack_range: Array =[]
var atakuje = false
var owner_id:int
var direction: Vector2 
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
var SPD: int = 100
var CRT: int
var CRTD: int
var CRV: int

func player():
	pass

var is_authority:bool:
	get: return !NetworkHandling.is_server && owner_id == ClientNetworkGlobal.id

func _enter_tree() -> void:
	
	ServerNetworkGlobal.handle_player_attack.connect(server_handle_player_attack)
	ServerNetworkGlobal.handle_player_position.connect(server_handle_player_position)
	ServerNetworkGlobal.handle_player_animation.connect(server_handle_player_animation)
	ServerNetworkGlobal.handle_player_stats.connect(server_handle_player_stats)
	ServerNetworkGlobal.handle_enemy_packet.connect(server_handle_enemy_packet)
	
	ClientNetworkGlobal.handle_player_attack.connect(client_handle_player_attack)
	ClientNetworkGlobal.handle_player_position.connect(client_handle_player_position)
	ClientNetworkGlobal.handle_player_animation.connect(client_handle_player_animation)
	ClientNetworkGlobal.handle_player_stats.connect(client_handle_player_stats)
	ClientNetworkGlobal.handle_enemy_packet.connect(client_handle_enemy_packet)

func _exit_tree() -> void:
	ServerNetworkGlobal.handle_player_attack.disconnect(server_handle_player_attack)
	ServerNetworkGlobal.handle_player_position.disconnect(server_handle_player_position)
	ServerNetworkGlobal.handle_player_animation.disconnect(server_handle_player_animation)
	ServerNetworkGlobal.handle_player_stats.disconnect(server_handle_player_stats)
	ServerNetworkGlobal.handle_enemy_packet.disconnect(server_handle_enemy_packet)
	
	ClientNetworkGlobal.handle_player_attack.disconnect(client_handle_player_attack)
	ClientNetworkGlobal.handle_player_position.disconnect(client_handle_player_position)
	ClientNetworkGlobal.handle_player_animation.disconnect(client_handle_player_animation)
	ClientNetworkGlobal.handle_player_stats.disconnect(client_handle_player_stats)
	ClientNetworkGlobal.handle_enemy_packet.disconnect(client_handle_enemy_packet)

#############################################################################
#SERVER
#############################################################################
func server_handle_player_position(peer_id:int, player_position: PlayerPosition) -> void:
	if owner_id != peer_id:return
	global_position = player_position.position
	PlayerPosition.create(owner_id, global_position).broadcast(NetworkHandling.connection)

func server_handle_player_animation(peer_id:int , player_animation: PlayerAnimation) -> void:
	if owner_id != peer_id: return
	#print(direction)
	#print(animation_typ(direction),' ', direction)
	PlayerAnimation.create(owner_id, player_animation.animation_state).broadcast(NetworkHandling.connection)

func server_handle_player_attack(peer_id: int, player_attack:PlayerAttack) -> void:
	if owner_id != peer_id: return
	var enemy = PlayerManagerGlobal.get_player_by_id(player_attack.enemy_id)
	if enemy:
		enemy.take_damage(player_attack.damage, self)
		#update_enemy_health_bar(enemy)
		PlayerAttack.create(owner_id, player_attack.enemy_id, player_attack.damage).broadcast(NetworkHandling.connection)

func server_handle_player_stats(peer_id:int, player_stats:PlayerStatsPacket)-> void:
	if owner_id != peer_id: return
	
	PlayerStatsPacket.create(self).broadcast(NetworkHandling.connection)
	#print('wysyła staty')

func server_handle_enemy_packet(_peer_id: int, _enemy): pass

#############################################################################
#CLIENT
#############################################################################
	
func client_handle_player_position(player_position:PlayerPosition) -> void:
	if is_authority || owner_id != player_position.id: return
	
	global_position = player_position.position
	
func client_handle_player_animation(player_animation: PlayerAnimation) -> void:
	
	if is_authority or owner_id != player_animation.id:
		return
	#print("Client got anim: ", player_animation.id, " state: ", player_animation.animation_state, " my owner_id: ", owner_id)
 #9 SlashDownLeft, 10 SlashDownRight, 11 SlashUpLeft, 12 SlashUpRight
	
	match player_animation.animation_state:
		0: 
			mieczyk.stop()
			anim.play("Idle")
		1: 
			mieczyk.stop()
			anim.play("Down")
		2: 
			mieczyk.stop()
			anim.play("DownLeft")
		3: 
			mieczyk.stop()
			anim.play("DownRight")
		4: 
			mieczyk.stop()
			anim.play("Left")
		5: 
			mieczyk.stop()
			anim.play("Right")
		6: 
			mieczyk.stop()
			anim.play("Up")
		7: 
			mieczyk.stop()
			anim.play("UpLeft")
		8: 
			mieczyk.stop()
			anim.play("UpRight")
		9: 
			mieczyk.play("DownLeft")
			anim.play('SlashDownLeft')
			
		10: 
			mieczyk.play("DownRight")
			anim.play('SlashDownRight')
		11: 
			mieczyk.play("UpLeft")
			anim.play('SlashUpLeft')
		12: 
			mieczyk.play("UpRight")
			anim.play('SlashUpRight')

func client_handle_player_attack(player_attack: PlayerAttack) -> void:
	if is_authority or owner_id != player_attack.our_id: 
		#print(is_authority or owner_id!=player_attack.our_id)
		return
	var enemy = PlayerManagerGlobal.get_player_by_id(player_attack.enemy_id)
	#print(enemy)
	if enemy: 
		
		enemy.take_damage(player_attack.damage, self)
		#update_enemy_health_bar(enemy)

func client_handle_player_stats(packet: PlayerStatsPacket):
	var player  = PlayerManagerGlobal.get_player_by_id(packet.id)
	if player and player != self:
		player.HP = packet.HP
		player.MaxHP = packet.MaxHP
		player.MP = packet.MP
		player.MaxMP = packet.MaxMP
		player.SP = packet.SP
		player.MaxSP = packet.MaxSP		
		player.LVL = packet.LVL
		player.LVLP = packet.LVLP
		player.LVLK = packet.LVLK
		player.LVLD = packet.LVLD		
		player.expLVL = packet.expLVL
		player.expKLVL = packet.expKLVL
		player.expDLVL = packet.expDLVL		
		player.CRV = packet.CRV
		player.STR = packet.STR
		player.INT = packet.INT
		player.WIS = packet.WIS
		player.VIT = packet.VIT
		player.DEX = packet.DEX
		player.DEF = packet.DEF
		player.PER = packet.PER
		player.SPD = packet.SPD
		player.CRT = packet.CRT
		player.CRTD = packet.CRTD
		#player.SPD +=1
		#print(self,'  ', player,'   ',player.HP)
		update_enemy_health_bar()

func client_handle_enemy_packet(packet: EnemyPacket): 
	var enemy = EnemyManagerGlobal.get_enemy_by_id(packet.id)
	#print('HP/MaxHP %d/%d' %[packet.HP, packet.MaxHP])
	#print(enemy)
	if enemy == null:
		# Tworzymy nowego enemy na kliencie
		enemy = preload("res://scenes/Mushroom.tscn").instantiate()
		enemy.enemy_id = packet.id
		enemy.is_replica = true
		get_tree().get_root().add_child(enemy) # albo specjalny node "Enemies"
		EnemyManagerGlobal.add_enemy(enemy)

	# Aktualizacja stanu enemy
	enemy.position = packet.position
	enemy.HP = packet.HP
	enemy.MaxHP = packet.MaxHP
	enemy.health_bar.max_value = packet.MaxHP
	enemy.health_bar.value = packet.HP

	match packet.animation_state:
		0: enemy.anim.play("Idle")
		1: enemy.anim.play("Run")
		2: enemy.anim.play("Attack")
		3: 
			enemy.anim.stop()
			enemy.anim.play("Hit")
		4:
			enemy.anim.play("Death")
			enemy.health_bar.visible = false
			EnemyManagerGlobal.remove_enemy(enemy.enemy_id)

func _ready() -> void:
	if is_authority:
		mana_bar.visible = true
		health_bar.visible  =true
		stamina_bar.visible = true
	else:
		enemy_health_bar.visible = true
		#enemy_health_bar.value = 100
	calculate_stats()
	HP = MaxHP
	MP = MaxMP
	SP = MaxSP
	update_health_bar()
	update_mana_bar()
	update_stamina_bar()
	stats.visible = false
	#connect("give_exp", give_exp)
	anim.play("Idle")

func _process(_delta: float) -> void:
	if HP <= 0:
		alive = false
		HP = 0
		#queue_free()
		#print('Umarł')
	_stat_tick += 1
	if _stat_tick >= 40:
		calculate_stats()
		stats.update(self)
		_stat_tick = 0
		PlayerStatsPacket.create(self).send(NetworkHandling.server_peer)
	if ! is_authority: 
		update_enemy_health_bar()

func calculate_stats():
	CRV = 5* LVLP
	MaxHP = round(max(100, DEF * 4 + VIT * 6))
	MaxMP = round(max(100, WIS * 10))
	MaxSP = round(max(100, VIT * 4 + DEX *3))
	PER = round(WIS * 0.5 + DEX * 0.7)
	CRT = round(DEX * 0.3 + INT * 0.2)
	CRTD = round(100 + STR * 0.5 + INT * 0.3)

func get_input():
	
	direction = Input.get_vector('left', 'right','up', 'down')
	
	direction = direction.normalized()
	
	if direction.length() >0:
		velocity = direction * SPD
		if atakuje: return
		animacja(direction)
		
	else:
		velocity = Vector2.ZERO
		if atakuje: return
		anim.play("Idle")
		mieczyk.stop()
	
	if Input.is_action_just_pressed('heal'):
		heal(5)
	
	if Input.is_action_just_pressed("open stats"):
		if stats.visible: stats.visible = false
		else: 
			stats.visible = true
			#stats.top_level = true
			
	if Input.is_action_just_pressed("attack"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		atakuje= true
		atak(mouse_pos)

func _physics_process(_delta):
	if !is_authority: return
	update_health_bar()
	update_mana_bar()
	update_stamina_bar()
	get_input()
	move_and_slide()
	PlayerPosition.create(owner_id, global_position).send(NetworkHandling.server_peer)
	
	if ! atakuje: PlayerAnimation.create(owner_id, animation_typ(direction)).send(NetworkHandling.server_peer)

func testowanie():
	print("LVL = ", LVL)
	print("PLVL = ", LVLP)
	print("KLVL = ", LVLK)
	print("DLVL = ", LVLD)

	print("expLVL = ", expLVL)
	print("expDLVL = ", expDLVL)
	print("expKLVL = ", expKLVL)

	print("STR = ", STR)
	print("INT = ", INT)
	print("WIS = ", WIS)
	print("VIT = ", VIT)
	print("DEX = ", DEX)
	print("DEF = ", DEF)

	print("PER = ", PER)
	print("CRT = ", CRT)
	print("CRTD = ", CRTD)
	print("SPD = ", SPD)

	print("CRV = ", CRV)

	print("MaxHP = ", MaxHP)
	print("HP = ", HP)
	print("MaxMP = ", MaxMP)
	print("MP = ", MP)
	print("MaxSP = ", MaxSP)
	print("SP = ", SP)

func take_damage(amount:int, _przeciwnik):
	HP = clamp(HP - amount, 0, MaxHP)
	update_health_bar()

func heal(amount:int ):
	HP = clamp(HP+ amount, 0, MaxHP)
	update_health_bar()

func update_health_bar():
	if is_authority:
		health_bar.max_value = MaxHP
		health_bar.value = HP

func update_enemy_health_bar():
	var players =  PlayerManagerGlobal.get_all_player()
	for p in players:
		if p !=self and p.enemy_health_bar:
			#print(p.enemy_health_bar)
			p.enemy_health_bar.max_value = p.MaxHP
			p.enemy_health_bar.value = p.HP
			return
	
func update_mana_bar():
	#if !mana_bar.visible: mana_bar.visible = true
	#print('aktualizuje mane')
	mana_bar.max_value = MaxMP
	mana_bar.value = MP

func update_stamina_bar():
	#print('Aktualizuje stamine')
	stamina_bar.max_value = MaxSP
	stamina_bar.value = SP

func animacja(d:Vector2):
	if d[0] ==0 and d[1]==-1: anim.play('Up')
	elif d[0] ==0 and d[1]==1: anim.play("Down")
	elif d[0]== -1 and d[1] ==0: anim.play("Left")
	elif d[0]==1 and d[1] ==0: anim.play("Right")
	elif d[0] <0 and d[1]<0: anim.play("UpLeft")
	elif d[0] >0 and d[1]<0: anim.play("UpRight")
	elif d[0] <0 and d[1]>0: anim.play("DownLeft")
	elif d[0] >0 and d[1]>0: anim.play("DownRight")

func animation_typ(d: Vector2) -> int:
	#print(d.x, d.y)
	if d.x == 0 and d.y == 0: return 0
	elif d.x == 0.0 and d.y == -1.0: return 6
	elif d.x == 0.0 and d.y == 1.0: return 1
	elif d.x == -1.0 and d.y == 0.0: return 4
	elif d.x == 1.0 and d.y == 0.0: return 5
	elif d.x < 0.0 and d.y < 0.0: return 7
	elif d.x > 0.0 and d.y < 0.0: return 8
	elif d.x < 0.0 and d.y > 0.0: return 2
	elif d.x > 0.0 and d.y > 0.0: return 3
	else: return -1
#0 Idle, 1 Down, 2 DownLeft, 3 DownRight, 4 Left, 5 Right, 6 Up, 7 UpLeft, 
#8 UpRight, 9 SlashDownLeft, 10 SlashDownRight, 11 SlashUpLeft, 12 SlashUpRight
func atak(pos: Vector2) -> void:
	var slash_anim := -1

	var d = [position.x, position.y]
	var p = [pos.x, pos.y]

	if d[0] <= p[0] and d[1] <= p[1]:
		anim.play("SlashDownRight")
		mieczyk.play("DownRight")
		slash_anim = 10
	elif d[0] >= p[0] and d[1] <= p[1]:
		anim.play("SlashDownLeft")
		mieczyk.play("DownLeft")
		slash_anim = 9
	elif d[0] <= p[0] and d[1] >= p[1]:
		anim.play("SlashUpRight")
		mieczyk.play("UpRight")
		slash_anim = 12
	elif d[0] >= p[0] and d[1] >= p[1]:
		anim.play("SlashUpLeft")
		mieczyk.play("UpLeft")
		slash_anim = 11

	deal_dmg()

	# Wyślij animację ataku do serwera
	if slash_anim != -1:
		PlayerAnimation.create(owner_id, slash_anim).send(NetworkHandling.server_peer)

	await anim.animation_finished
	atakuje = false

func deal_dmg():
	if !enemies_in_attack_range.is_empty():
		for e in enemies_in_attack_range:
			if e.has_method('player'):
				PlayerAttack.create(self.owner_id, e.owner_id, 10).send(NetworkHandling.server_peer)
			else: 
				e.take_damage(10, self)
		#print(przeciwnik.HP)

func _on_attack_range_body_entered(body: Node2D) -> void:
	if !body.has_method("enemy") and !body.has_method("player"): return
	if body == self: return
	if is_multiplayer_authority():
		enemies_in_attack_range.append(body)


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.has_method("enemy") or body.has_method('player'):
		enemies_in_attack_range.erase(body)
		

var var_name
func give_exp(amount,type=''):
	#print(osoba,' ', amount,' ', type=='')
	if type!='':
		var_name = "exp%sLVL"%type.capitalize()
	else:
		var_name = 'expLVL'
	#print(var_name)
	set(var_name, get(var_name) + amount)
