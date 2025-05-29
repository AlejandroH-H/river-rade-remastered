extends Area2D

@onready var fuel_scene = load("res://Scenes/fuelTank.tscn")
@onready var player = get_tree().get_root().find_child("Raider", true, false)
@onready var tilemap = get_parent().get_node("TileMapLayer")
# Se llama al tilemap para acceder a sus propiedes, y en específico, se usa la propiedad para saber el posicionamiento
# de los tiles

const WATER_TILE_ID = 2  # Este ID le corresponde al tilemap que estamos utilizando para sobreponer el agua
var can_spawn = true # Variable que a lo largo del trayecto pasará de false a true condicionada por el valor del Timer

var fuel_spawn_distance = -300  # Esta es la distancia máxima a la que se podrá spawnear un gasoi
var fuel_spawn_buffer_y = -100  # Distancia mínima a la que puede spawnear un gasoi
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize() # Valor numérico que más adelante pocisionarán al gasoi

func _process(delta: float) -> void:
	if can_spawn:
		spawn_fuel() # Función que por medio de comprobaciones, instanciará al gasoi, todo esto dependiendo de si
		# quiso spawnear dentro del tile de agua

func get_valid_water_positions_in_range() -> Array:
	var valid_positions: Array = [] # Gracias a esta monda de vector, se acumulan todas las pocisiones correctas a las que puede
	# spawnear el gasoi, lo podría aplicar también para los enemigos, pero aún me sigue gustando el popping con le que salen xd
	var used_rect = tilemap.get_used_rect() # Estamos guardando acá toda la textura que tiene relación con nuestro tilemap
	# más adelante será utilizada para pocisionar al gasoi

	var min_y = player.position.y + fuel_spawn_distance + fuel_spawn_buffer_y # Esta variable calcula el mínimo posicionamiento en Y
	# al que puede spawnear el gasoi, esto para que no nos impacte en toda la cara
	var max_y = player.position.y + fuel_spawn_distance # El máximo espacio al que puede spawnear el gasoi

	for x in range(used_rect.position.x, used_rect.end.x): # Con este primer para, sacamos un valor inicial de X y un valor final de X
		for y in range(used_rect.position.y, used_rect.end.y): # Y con este, recorremos tantos valores de Y puedan haber
			var cell_coords = Vector2i(x, y) # Acá guardamos las coordenadas de cada una, usando Vector2
			var tile_id = tilemap.get_cell_source_id(cell_coords) # Identificamos la pocisión en el tilemap, esto para saber en que ID
			# decidió aparecer
			if tile_id == WATER_TILE_ID: # Si efectivamente la ide del tile es igual a 2, pues maravilloso, guardamos la posición y más adelante spawneará como dios lo trajo al mundo
				#con la suerte de que el jugador pueda darse el beneficio de utilizar tan gloriosa gasolina
				var world_pos = tilemap.map_to_local(cell_coords) # Como las cellCords son las wenardas, posteriormente se guardarán en nuestro arreglo
				# de posiciones válidas, sin racismo, pero, lo que pasa es que el gasoi no puede aparecer en el césped :)
				if world_pos.y >= min_y and world_pos.y <= max_y:
					valid_positions.append(world_pos)
# Inciso rápido, se necesita del arreglo porque en la mayoría de los casos, el tileID no vale 2, ahí si que me perdieron porque no sabría hacer
# como para que en la mayoría de veces valga 2, pero con este arreglo lo que estoy haciendo es que se evalúe más rápido
# el spawneo y si aparezcan en gameplay
	return valid_positions

func spawn_fuel():
	can_spawn = false # Se pone en falsa para no ocasionar bugs hermosos
	$cooldown.start() # Empieza el timer

	var possible_positions = get_valid_water_positions_in_range() # Acá ponemos en funcionamiento nuestra función de posicionamiento
	if possible_positions.is_empty(): #Si no retorna nada es porque no entró a la condición, lo que significa que el tileID no vale 2 en ese momento
		print("No se encontró posición válida para gasolina.")
		return

	var spawn_pos = possible_positions[rng.randi_range(0, possible_positions.size() - 1)]

	# Validar que no haya conflicto con enemigos ya presentes
	if is_position_occupied(spawn_pos, 64): #Esto lo hizo la IA, pero sinceramente lo podría quitar, ya que los pocionamientos no cuadran para que se choquen
		# pero al mismo tiempo no quiero xd
		print("Posición ocupada, cancelando gasolina.")
		return

# Si ninguna de las dos condiciones se cumplen, felicidad absoluta, spawnea el gasoi, ese gasoi nació en Canadá o en Suiza, todo
# gracias al vector
	var fuel_instance = fuel_scene.instantiate()
	fuel_instance.position = spawn_pos
	add_child(fuel_instance)

func is_position_occupied(pos: Vector2, radius: float) -> bool:
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.position.distance_to(pos) < radius:
			return true
	return false

func _on_cooldown_timeout() -> void:
	can_spawn = true #Cuando el timer termina, empieza otra vez el spawn y así sucesivamente, el tiempo se puede configurar, pero por ahora me gusta así
	
	# ACLARACIÓN: debido a que el agua choca con la colisión de la pared, pueden haber spawns tanto acá como con los enemigos
	# en dónde o aparezcan pegados a la pared o dentro del césped, se validó que no aparescan en el césped, pero las mismas
	# físicas actuales los empujan hacía dentro, por cuestión tiempo lo que haría sería poner "sombras" con el uso del tilemap con ID número
	# 1, pero cuando se terminen de programar los puentes
