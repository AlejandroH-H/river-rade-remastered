extends CharacterBody2D

var direction = -1
var speed = 60
var hitbox = false
var sound_played = false
@onready var player = $Area2D/AudioStreamPlayer

func death_sound():
	if not sound_played:
		player.play()
		sound_played = true
func _physics_process(delta: float) -> void:
	if not hitbox:
		$AnimationPlayer.play("Idle")
	else:
		death_sound()
		velocity.y = 0
		velocity.x = 0
		$AnimationPlayer.play("Death")
		quit_timer()

func _process(delta: float) -> void:
	if not hitbox:
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
		$Sprite2D.flip_v = true

func adjust_raycast():
	if direction == 1:
		$RayCast2D_Left.position.x = 22
		$RayCast2D_Right.position.x = -38
	elif direction == -1:
		$RayCast2D_Left.position.x = -22
		$RayCast2D_Right.position.x = 38
		
func quit_timer():
	
	var timer2 = Timer.new()
	timer2.wait_time=0.3
	timer2.connect("timeout", _on_timer2_timeout)
	add_child(timer2)
	timer2.start()
	
func _on_timer2_timeout():
	queue_free()
