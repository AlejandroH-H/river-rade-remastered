extends Node

var line2d_y = -100
var player_lives = 3
var player_score = 0

func reset_level():
	get_tree().reload_current_scene()
