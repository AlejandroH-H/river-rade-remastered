extends CharacterBody2D

var direction = -1
var speed = 170
var hitbox = false
var bullet = preload("res://Scenes/silver_bullet.tscn")
var bulletCount = 0 #Variable para validar la cantidad de balas que se disparan
var maxSilver_Bullets = 3 #Variable que indica cuántas balas se pueden disparar
var canShoot = true #Variable bandera que activa el uso de las balas
var silverLife = 4000
var sound_played = false
var sound_played2 = false
@onready var Hit = $Area2D/Hit
@onready var Death = $Area2D/Death

func hit_sound():
	if not sound_played:
		Hit.play()
		sound_played = true
	$flash.play("hurt")
	await get_tree().create_timer(0.1).timeout
	
func death_sound():
	if not sound_played2:
		Death.play()
		sound_played2 = true

func _physics_process(delta: float) -> void:
	if silverLife >= 2000:
		$AnimationPlayer.play("idle")
	elif silverLife > 0 and silverLife < 2000:
		$AnimationPlayer.play("enraged")
		speed = 230
		maxSilver_Bullets = 4
	else:
		death_sound()
		velocity.y = 0
		velocity.x = 0
		$AnimationPlayer.play("Death")
		quit_timer()

func _process(delta: float) -> void:
	if hitbox:
		hit_sound()
		silverLife-=200
		hitbox = false
		sound_played = false
	if silverLife > 0:
		move_enemies()
		place()
func move_enemies():
	velocity.x = direction * speed
	move_and_slide()

func place():
	if $RayCast2D_Left.is_colliding():
		direction = 1
		$Sprite2D.flip_h = false
		$Sprite2D.flip_v = false
	elif $RayCast2D_Right.is_colliding():
		direction = -1
		$Sprite2D.flip_h = true
		#$Sprite2D.flip_v = true

func adjust_raycast():
	if direction == 1:
		$RayCast2D_Left.position.x = 25
		$RayCast2D_Right.position.x = -21
	elif direction == -1:
		$RayCast2D_Left.position.x = -25
		$RayCast2D_Right.position.x = 21
		
		

func _on_cooldown_timeout() -> void:
	if  canShoot:
		canShoot = false
		bulletCount = 0
		shootSequence()
	
func shootSequence():
	if  bulletCount < maxSilver_Bullets and silverLife>0:
		shoot()
		$Attack.play()
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
	var newBullet2 = bullet.instantiate()
	newBullet.global_position = $SpawnPoint.global_position
	newBullet.rotation = $SpawnPoint.rotation
	newBullet2.global_position = $SpawnPoint2.global_position
	newBullet2.rotation = $SpawnPoint2.rotation
	get_parent().add_child(newBullet)
	get_parent().add_child(newBullet2)
	
func quit_timer():
	
	var timer2 = Timer.new()
	timer2.wait_time=1.8
	timer2.connect("timeout", _on_timer2_timeout)
	add_child(timer2)
	timer2.start()
	
func _on_timer2_timeout():
	get_tree().change_scene_to_file("res://Scenes/winner.tscn")
