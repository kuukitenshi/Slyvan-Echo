extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSfx.play()
		
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)
		$AnimatedSprite2D.play("idle")
	
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	move_and_slide()
