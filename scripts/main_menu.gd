extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	print('kliknieto start')
	NetworkHandling.start_client()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	print('Exit pressed')
	get_tree().quit()


func _on_server_pressed() -> void:
	print('kliknieto server')
	NetworkHandling.start_server()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
