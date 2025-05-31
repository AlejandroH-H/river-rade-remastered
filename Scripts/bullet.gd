extends CharacterBody2D

var direction: float = 0.0
var speed: float = 300.0 #Podríamos probar la velocidad en el futuro para ver cual es más adaptable

func _ready():
	add_to_group("projectiles")
	$HitBoxArea.connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area):
	if area.name == "bridge" or area.is_in_group("projectiles"):
		queue_free()

func _physics_process(delta):
	#velocity = Vector2.UP * speed
	#move_and_slide()
	#En este caso, se usa Vector2.UP, ya que es un método que se mete directamente con la coordenada Y, sin tener que usar el convencional y poner la X en 0, lo ví más práctico
	var collision = move_and_collide(Vector2(0, -speed * delta))
	
	if collision:
		var collider = collision.get_collider()
		if collider:
			if collider.is_in_group("Enemy"):
				if collider.get_name()=="Enemy_Helicopter":
					Global.player_score += 200
				else:
					Global.player_score += 100
				#meti a todos los enemigos en el grupo enemy para detectar cuando la bala colisione con uno de ellos
				collider.hitbox = true
				#meti a todos los enemigos en el grupo enemy para detectar cuando la bala colisione con uno de ellos
				collider.hitbox = true
				#hitbox es una variable bool que le permite al juego determinar si debe morir el enemigo o no, accedo a ella mediante el collider ya que hitbox se encuentra en los scripts de enemigos
			if collider.is_in_group("Items"):
				collider.queue_free()
				queue_free()
			else:
				queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
