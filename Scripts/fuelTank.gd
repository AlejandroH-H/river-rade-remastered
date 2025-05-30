extends Area2D
@onready var player = $AudioStreamPlayer
var parent
var sprite
var colision
func _ready():
	sprite = get_node("../Sprite2D")
	colision = get_node("../CollisionShape2D")
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player_scene = get_tree().get_nodes_in_group("Player")[0]
		player.play()
		player.connect("finished", _on_audio_finished)
		if player_scene:
			if player_scene.get_node("HUD/LivesContainer/TimerBar").points[1].y >= -80:
				player_scene.get_node("HUD/LivesContainer/TimerBar").points[1].y -=20
				#queue_free()
			elif player_scene.get_node("HUD/LivesContainer/TimerBar").points[1].y == -90:
				player_scene.get_node("HUD/LivesContainer/TimerBar").points[1].y -=10
				#queue_free()
			else:
				player_scene.get_node("HUD/LivesContainer/TimerBar").points[1].y -=0
			#queue_free()
		sprite.hide()
		if is_instance_valid(colision):
				colision.queue_free()
	
func _on_audio_finished():
	parent = get_parent()
	if parent:
		parent.queue_free()
#Se hicieron modificaciones para cuadrar con el audio, escondo el sprite y borro la colision fuera del Area2D
#porque sino, el tanque permanece en el mapa por un segundo y obstruye al Raider
