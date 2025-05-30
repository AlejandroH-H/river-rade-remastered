extends Node2D


func _ready() -> void:
	AudioPlayer.stop_music()
	SilverTheme.stop_music()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
