extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.get_name()=="Raider":
		get_tree().reload_current_scene()
		#Esta función esta compartida tanto para la hitbos del mapa como para la del area2D del enemigo
		#Se puede cambiar a futuro
