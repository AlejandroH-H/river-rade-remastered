extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player_scene = get_tree().get_nodes_in_group("Player")[0]
		var parent = get_parent()
		if player_scene:
			if player_scene.get_node("TimerBar").points[1].y >= -80:
				player_scene.get_node("TimerBar").points[1].y -=20
			elif player_scene.get_node("TimerBar").points[1].y == -90:
				player_scene.get_node("TimerBar").points[1].y -=10
				queue_free()
			else:
				player_scene.get_node("TimerBar").points[1].y -=0
			queue_free()
			if parent:
				parent.queue_free()
		
