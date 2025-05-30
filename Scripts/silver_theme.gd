extends AudioStreamPlayer

var music = true
#Script global para poder cargar la musica entre escenas
var level_music = preload("res://assets/public/Music/Raze Soundtrack - Boss Battles [Coleman Trapp - Side Scroller CT].mp3")

func _ready():
	if level_music is AudioStreamMP3:
		level_music.loop = true


func _play_music(music: AudioStream, volume = -8.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()
	
func play_music_level():
	_play_music(level_music)
	
func stop_music():
	if music:
		stop()
		music = false
		
func not_music():
	if not music:
		music = true
