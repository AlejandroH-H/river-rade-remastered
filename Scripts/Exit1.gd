extends Area2D


@export var next_scene_path: String
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Raider":
		change_scene()
		
		
# Todo hasta acá viene del tuto de LuisCanary
func change_scene():
	var player_scene = get_tree().get_nodes_in_group("Player")[0]
	Global.line2d_y = player_scene.get_node("HUD/LivesContainer/TimerBar").points[1].y
	get_tree().change_scene_to_file(next_scene_path)
