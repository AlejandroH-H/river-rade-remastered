extends CharacterBody2D

const SPEED = 50.0
const TILT_SPEED = 150.0
const TURBO = SPEED * 2

var bullet = preload("res://Scenes/bullet.tscn")
var bulletCount = 0 #Variable para validar la cantidad de balas que se disparan
var maxBullets = 5 #Variable que indica cuántas balas se pueden disparar
var canShoot = true #Variable bandera que activa el uso de las balas
var is_dead = false
var hitbox = false


func _physics_process(delta: float) -> void:
	
	if hitbox:
		velocity.y = 0
		velocity.x = 0
		$AnimationPlayer.play("Death")
		quit_timer()
	else:
		if not is_dead:
			velocity.y = -SPEED
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and canShoot:
				canShoot = false
				bulletCount = 0
				shootSequence()
				# En esta secuencia, se está validando que al oprimir el click izquierdo y que la variable bandera esté verdadera, que entre a nuestra función de control de disparos, para controlar el flujo

			if Input.is_action_pressed("ia_up"):
				velocity.y = -TURBO
				
			elif Input.is_action_pressed("ia_down"):
				velocity.y = -SPEED/2

			if Input.is_action_pressed("ia_left"):
				velocity.x = -TILT_SPEED
				$AnimationPlayer.play("Left")
			elif Input.is_action_pressed("ia_right"):
				velocity.x = TILT_SPEED
				$AnimationPlayer.play("Right")
			else: 
				velocity.x = 0
				$AnimationPlayer.play("Idle")
	move_and_slide()
	
	
func shootSequence():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and bulletCount < maxBullets:
		shoot()
		bulletCount += 1
		$Timer.start()
		await $Timer.timeout
		shootSequence()
		#Al entrar, se va acumulando el contador, usando nuestra función para disparar (utilizando el nodo) y empezando el timer para controlar cada disparo
	else:
		$Timer.start()
		await $Timer.timeout
		canShoot = true
		#Cuando se llena el contador, volveremos arriba a repetir el mismo ciclo

func shoot():
	var newBullet = bullet.instantiate()

	newBullet.global_position = $SpawnPoint.global_position
	newBullet.rotation = $SpawnPoint.rotation
	get_parent().add_child(newBullet)
	
	
func _on_timer_bar_time_to_die() -> void:
	is_dead = true
	velocity.y = 0
	velocity.x = 0
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Death") 
	#Hasta acá rodo escelente, is_dead es la variable que evita otros movimientos
	var timer = Timer.new()
	timer.wait_time=1.2
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	$AnimationPlayer.stop()
	quit_timer()

	
func quit_timer():
	var timer2 = Timer.new()
	timer2.wait_time=0.3
	timer2.connect("timeout", _on_timer2_timeout)
	add_child(timer2)
	timer2.start()
	var timer3 = Timer.new()
	timer3.wait_time=0.3
	timer3.connect("timeout", _on_timer3_timeout)
	add_child(timer3)
	timer3.start()
	
func _on_timer2_timeout():
	$Sprite2D.hide()
func _on_timer3_timeout():
	get_tree().quit()
	
	
	#_animation_finished()
	#$AnimationPlayer.connect("animation_finished", Callable(self, "_on_animation_player_animation_finished"))
	#$AnimationPlayer.connect("animation_finished", func(anim_name): _on_animation_player_animation_finished)

#func _ready() -> void:
	#animation_player = $AnimationPlayer
	#animation_player.animation_finished.connect(_on_animation_player_animation_finished)
#func _animation_finished():
	#print("funciona este tambien x2")
	#$AnimationPlayer.stop()
	#$AnimationPlayer.visible = false

#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#print("funciona este tambien x2")
	#if anim_name == "died":
		#print("test")
#Todo hasta acá fueron intentos fallidos, pero el timer parece prometedor, aunque me gustaría
#lograr la conexión
