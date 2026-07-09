extends Control

func _on_button_começar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameplay_sala.tscn")

func _on_button_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameplay_creditos.tscn")


func _on_button_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameplay_menu_principal.tscn")
