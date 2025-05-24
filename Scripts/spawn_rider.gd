extends Area2D

@onready var player = get_tree().get_root().find_child("Raider", true, false)
@onready var heli_scene = load("res://Chars&World/enemy_helicopter.tscn")

var bool_spawn = true
var min_spawn_y = -163
var ramdom = RandomNumberGenerator.new()

func _ready() -> void:
	ramdom.randomize()
	
func _process(delta: float) -> void:
	spawn_heli()

func spawn_heli():
	if bool_spawn:
		$cooldown.start()
		bool_spawn = false
		var heli_instance = heli_scene.instantiate()
		min_spawn_y = max(min_spawn_y, player.position.y - 60)
		heli_instance.position = Vector2(ramdom.randf_range(-220, 220), ramdom.randi_range(max(min_spawn_y - 70, -200), min_spawn_y - 1000))
		# -240 223 en X
		# -163 -1100
		add_child(heli_instance)

func _on_cooldown_timeout() -> void:
	bool_spawn = true
