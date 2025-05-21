extends CharacterBody2D

var direction = -1
var speed = 40

func _physics_process(delta: float) -> void:
	$AnimationPlayer.play("Idle")

func _process(delta: float) -> void:
	move_enemies()
	place()

func move_enemies():
	velocity.x = direction * speed
	move_and_slide()

func place():
	if $RayCast2D_Left.is_colliding():
		direction = 1
		$Sprite2D.flip_h = false
	elif $RayCast2D_Right.is_colliding():
		direction = -1
		$Sprite2D.flip_h = true

func adjust_raycast():
	if direction == 1:
		$RayCast2D_Left.position.x = 22
		$RayCast2D_Right.position.x = -41
	elif direction == -1:
		$RayCast2D_Left.position.x = -22
		$RayCast2D_Right.position.x = 41
