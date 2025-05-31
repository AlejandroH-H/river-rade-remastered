extends Node2D



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Chars&World/level_one.tscn")
	AudioPlayer.not_music()
	Global.player_lives = 3
	Global.player_score = 0


func _on_button_2_pressed() -> void:
	get_tree().quit()
