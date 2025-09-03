extends Control

@onready var lvl_label: Label = $GridContainer/LVL
@onready var lvlexp_label: Label = $GridContainer/LVLEXP
@onready var lvlk_label: Label = $GridContainer/LVLK
@onready var lvlkexp_label: Label = $GridContainer/LVLKEXP
@onready var lvld_label: Label = $GridContainer/LVLD
@onready var lvldexp_label: Label = $GridContainer/LVLDEXP
@onready var lvlp_label: Label = $GridContainer/LVLP
@onready var crv_label: Label = $GridContainer/CRV
@onready var str_label: Label = $GridContainer/STR
@onready var int_label: Label = $GridContainer/INT
@onready var wis_label: Label = $GridContainer/WIS
@onready var vit_label: Label = $GridContainer/VIT
@onready var dex_label: Label = $GridContainer/DEX
@onready var def_label: Label = $GridContainer/DEF
@onready var per_label: Label = $GridContainer/PER
@onready var spd_label: Label = $GridContainer/SPD
@onready var crt_label: Label = $GridContainer/CRT
@onready var crtd_label: Label = $GridContainer/CRTD
@onready var max_hp_label: Label = $GridContainer/MaxHP
@onready var hp_label: Label = $GridContainer/HP
@onready var max_mp_label: Label = $GridContainer/MaxMP
@onready var mp_label: Label = $GridContainer/MP
@onready var max_sp_label: Label = $GridContainer/MaxSP
@onready var sp_label: Label = $GridContainer/SP
@onready var exp_to_next:float = 0
@onready var expd_to_next:float = 0
@onready var expk_to_next:float = 0


	
	
	
func update(player):
	exp_to_next  = 0.1 * player.LVL**3 + 10 * player.LVL + 100
	expd_to_next = 0.1 * player.LVLD**3 + 10 * player.LVLD + 100
	expk_to_next = 0.1 * player.LVLK**3 + 10 * player.LVLK + 100
	if player.expLVL >= exp_to_next:
		player.LVL +=1
		player.expLVL -= exp_to_next
		exp_to_next  = 0.1 * player.LVL**3 + 10 * player.LVL + 100
	if player.expDLVL >= expd_to_next:
		player.LVLD +=1
		player.expDLVL -= expd_to_next
		expd_to_next  = 0.1 * player.LVLD**3 + 10 * player.LVLD + 100
	if player.expKLVL >= expk_to_next:
		player.LVLK +=1
		player.expKLVL -= expk_to_next
		expk_to_next  = 0.1 * player.LVLK**3 + 10 * player.LVLK + 100
		
	lvl_label.text = "lvl gracza: %d" % player.LVL
	lvlexp_label.text = "%d / %d" % [player.expLVL, exp_to_next ]
	
	lvlk_label.text = "Lvl Kowala: %d" % player.LVLK
	lvlkexp_label.text = "%d / %d" % [player.expKLVL , expk_to_next]
	
	lvld_label.text = "Lvl Drwala: %d" % player.LVLD
	lvldexp_label.text = "%d / %d" % [player.expDLVL , expd_to_next]
	
	lvlp_label.text = "Profesje: %d" % player.LVLP
	crv_label.text = "Kreatywność: %d"% player.CRV
	
	str_label.text = "Siła: %d" %player.STR
	int_label.text = "Inteligencja: %d"% player.INT
	wis_label.text = "Mądrość: %d"% player.WIS
	vit_label.text = "Żywotność: %d"% player.VIT
	dex_label.text = "Zwinność: %d"% player.DEX
	def_label.text = "Obrona: %d"% player.DEF
	per_label.text = "Percepcja: %d"% player.PER
	spd_label.text = "Szybkość: %d"% player.SPD
	crt_label.text = "Szansa kryt.: %d" % player.CRT
	crtd_label.text = "Siła kryt.: %d"% player.CRTD

	max_hp_label.text = "Max życia: %d" %player.MaxHP
	hp_label.text = "Życie %d / %d" % [player.HP, player.MaxHP]

	max_mp_label.text = "Max many: %d" %player.MaxMP
	mp_label.text = "Mana %d / %d" % [player.MP, player.MaxMP]

	max_sp_label.text = "Max staminy: %d" %player.MaxSP
	sp_label.text = "Stamina %d / %d" % [player.SP, player.MaxSP]
