extends Resource

class_name InvItem

@export var item_id: String = ''
@export var name: String 		= ''
@export var texture: Texture2D
@export var max_in_stack:int 	= 1
@export_multiline var description: String = ''
@export var is_tool: bool		= false
@export var tool_tier: int 		= 0
@export var is_weapon:bool		= false
@export var is_breakable: bool	= false
@export var durability:int 
@export var is_ore: bool 		= false
@export var ore_tier: int 		= 0
@export var value: int
