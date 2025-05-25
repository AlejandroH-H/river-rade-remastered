extends Area2D

@onready var player = $AudioStreamPlayer



func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.hitbox = true
	elif body.get_name() == "Bullet":
		player.play()
