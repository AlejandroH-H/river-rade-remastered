extends Node2D

func _ready():
	AudioPlayer.stop_music()
	var timer2 = Timer.new()
	timer2.wait_time=4.0
	timer2.connect("timeout", _on_timer2_timeout)
	add_child(timer2)
	timer2.start()
func _on_timer2_timeout():
	SilverTheme.not_music()
	SilverTheme.play_music_level()
