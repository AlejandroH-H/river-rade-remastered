extends CharacterBody2D

var direction: float = 0.0
var speed: float = 300.0 #Podríamos probar la velocidad en el futuro para ver cual es más adaptable

func _physics_process(delta):
	#velocity = Vector2.UP * speed
	#move_and_slide()
	#En este caso, se usa Vector2.UP, ya que es un método que se mete directamente con la coordenada Y, sin tener que usar el convencional y poner la X en 0, lo ví más práctico
	var collision = move_and_collide(Vector2(0, -speed * delta))
	
	if collision:
		var collider = collision.get_collider()
		if collider:
			if collider.get_name() == "Enemy_Boat":
				collider.queue_free()
				queue_free()
			else:
				queue_free()
