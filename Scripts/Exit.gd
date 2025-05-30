extends Area2D

@export var next_scene_path: String
var map
var scene_name
func rand_scene() -> int:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(1, 2)

func _ready():
	map = rand_scene()
	print(map)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Raider":
		change_scene()
		
		
# Todo hasta acá viene del tuto de LuisCanary
func change_scene():
	scene_name = get_tree().current_scene.name
	var player_scene = get_tree().get_nodes_in_group("Player")[0]
	Global.line2d_y = player_scene.get_node("HUD/LivesContainer/TimerBar").points[1].y
	if Global.player_score >= 10000 and scene_name == "path_to_silver":
		get_tree().change_scene_to_file("res://Chars&World/boss_fight.tscn")
	elif Global.player_score >= 10000 and scene_name != "path_to_silver":
		get_tree().change_scene_to_file("res://Chars&World/path_to_silver.tscn")
	else:
		if map == 1:
			get_tree().change_scene_to_file(next_scene_path)
		else:
			get_tree().change_scene_to_file("res://Chars&World/level_three.tscn")
	
	
	#vale, la linea de Global, es donde almaceno el "valor" porque en realidad es posición en Y
	#de la barra, una vez almacenada en el singleton, se cambia de escena. La linea de la magia está en el script del Raider
	
