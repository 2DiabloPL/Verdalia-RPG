extends Control


func _on_button_pressed() -> void:
	print('kliknieto serwer')
	NetworkHandling.start_server()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_button_2_pressed() -> void:
	print('kliknieto clienta')
	NetworkHandling.start_client()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
