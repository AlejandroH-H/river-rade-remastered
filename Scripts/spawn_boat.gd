extends Area2D

@onready var player = get_tree().get_root().find_child("Raider", true, false)
@onready var boat_scene = load("res://Chars&World/enemy_boat.tscn")

var bool_spawn = true
#Variable bandera que se desactiva cuando spawnea el enemigo, y que se activa cuando se cumpla el timer
var min_spawn_y = -190
# Esta variable será usada para empezar a medir e pocisionamiento del jugador en Y
# Siendo importante para la aparción de los enemigos desde un principio
var ramdom = RandomNumberGenerator.new()
# Este valor ramdom pocisionará al enemigo dependiendo del número que saque
# Aunque me estoy dando cuenta que puede ser el causante de su nula aparición en mucho tiempo
# Debido a que saca cualquier número, y dentro de las condiciones se asignan valores específicos
func _ready() -> void:
	ramdom.randomize()
	
func _process(delta: float) -> void:
	spawn_boat()

func spawn_boat():
	if bool_spawn:
		$cooldown.start()
		bool_spawn = false
		var boat_instance = boat_scene.instantiate()
		# Esta instancia se realiza para activar todas las propiedades del nodo, y acceder a la posición en tiempor real
		min_spawn_y = max(min_spawn_y, player.position.y - 60)
		boat_instance.position = Vector2(ramdom.randf_range(-179, 170), ramdom.randi_range(max(min_spawn_y - 50, -200), min_spawn_y - 1000))
		# -240 223 en X
		# -163 -1100
		add_child(boat_instance)

func _on_cooldown_timeout() -> void:
	bool_spawn = true
