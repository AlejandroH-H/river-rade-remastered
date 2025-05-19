extends CharacterBody2D

const SPEED = 50.0
const TILT_SPEED = 150.0
const TURBO = SPEED * 2

var bullet = preload("res://Scenes/bullet.tscn")
var bulletCount = 0 #Variable para validar la cantidad de balas que se disparan
var maxBullets = 5 #Variable que indica cuántas balas se pueden disparar
var canShoot = true #Variable bandera que activa el uso de las balas


func _physics_process(delta: float) -> void:
	
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
