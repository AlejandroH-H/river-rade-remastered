extends Area2D

@onready var player = get_tree().get_root().find_child("Raider", true, false)
@onready var gas_scene = load("res://Scenes/fuelTank.tscn")

var bool_spawn = true

var ramdom = RandomNumberGenerator.new()

func _ready() -> void:
	ramdom.randomize()
	
func _process(delta: float) -> void:
	spawn_gas()

func spawn_gas():
	if bool_spawn:
		$cooldown.start()
		bool_spawn = false
		var gas_instance = gas_scene.instantiate()

		gas_instance.position = Vector2(ramdom.randf_range(-220, 220), ramdom.randi_range(-163, -1100))
		# -240 223 en X
		# -163 -1100
		add_child(gas_instance)

func _on_cooldown_timeout() -> void:
	bool_spawn = true
