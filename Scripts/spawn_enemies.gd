extends Area2D
# Toda la documentación de este funcionamiento está en el spawn del gasoi
@onready var player = get_tree().get_root().find_child("Raider", true, false)
@onready var tilemap = get_parent().get_node("TileMapLayer")

@onready var heli_scene = load("res://Chars&World/enemy_helicopter.tscn")
@onready var boat_scene = load("res://Chars&World/enemy_boat.tscn")

const WATER_TILE_IDS = 2  # ID del tile de agua
var can_spawn = true
var rng = RandomNumberGenerator.new()

# Configuración de aparición
var heli_spawn_buffer_y = -25
var boat_spawn_buffer_y = -30
var base_spawn_distance = -100 

func _ready() -> void:
	rng.randomize()

func _process(delta: float) -> void:
	if can_spawn:
		spawn_enemy()

func get_random_water_tile_position() -> Vector2:
	var used_rect = tilemap.get_used_rect()
	var attempts = 0

	var max_y = player.position.y + base_spawn_distance    # más cerca del jugador (más abajo visualmente)
	var min_y = max_y - 250                                 # hasta 250px más arriba

	while attempts < 30:
		var x = rng.randi_range(used_rect.position.x, used_rect.end.x - 1)
		var y = rng.randi_range(used_rect.position.y, used_rect.end.y - 1)
		var cell_coords = Vector2i(x, y)

		var tile_id = tilemap.get_cell_source_id(cell_coords)  # Primer layer
		if tile_id == WATER_TILE_IDS:
			var world_pos = tilemap.map_to_local(cell_coords)
			if (world_pos.y >= min_y) and (world_pos.y <= max_y):
				return world_pos

		attempts += 1
	return Vector2.ZERO

func spawn_enemy():
	can_spawn = false
	$cooldown.start()

	var enemy_type = rng.randi_range(0, 1)  # 0 = helicóptero, 1 = barco
	var spawn_pos : Vector2
	var instance : Node2D
	var spawned := false
	var attempts := 0

	while attempts < 10:
		spawn_pos = get_random_water_tile_position()

		if spawn_pos != Vector2.ZERO:
			if enemy_type == 0:
				instance = heli_scene.instantiate()
				spawn_pos.y += rng.randf_range(heli_spawn_buffer_y, 0)
			else:
				instance = boat_scene.instantiate()
				spawn_pos.y += rng.randf_range(boat_spawn_buffer_y, 0)

			instance.position = spawn_pos
			add_child(instance)
			spawned = true
			break

		attempts += 1

	if !spawned:
		print("No se pudo spawnear el enemigo tras 10 intentos.")

func _on_cooldown_timeout() -> void:
	can_spawn = true
