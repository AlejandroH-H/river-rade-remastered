extends AudioStreamPlayer
var music = true
#Script global para poder cargar la musica entre escenas
const level_music = preload("res://assets/public/Music/Strike Force Heroes Music - Rose at Midnight.mp3")

func _play_music(music: AudioStream, volume = -8.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()
	
func play_music_level():
	_play_music(level_music)
