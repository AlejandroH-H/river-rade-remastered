extends CharacterBody2D

const SPEED = 50.0
const TILT_SPEED = 150.0
const TURBO = SPEED * 2


func _physics_process(delta: float) -> void:

	velocity.y = -SPEED

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
