extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

signal life_changed(player_hearts)

var max_hearts: int = 5
var hearts: float = max_hearts
var enemy_in_attack_range = false
var enemy_attack_coldown = true
var player_is_alive = true
var attack_in_progress = false

func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()
	attack()
	
	if hearts <= 0:
		player_is_alive = false
		$AnimatedSprite2D.play("dead")
#		TODO: METER MUSICA DE MORTE, respawn
		hearts = 0
		self.queue_free() # funcao de parar com som e dps dar respawn

func player_movement(delta):
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

#func damage(dmg):
	#hearts -= dmg * 0.5
	#emit_signal("life_changed", hearts)
	#if hearts <= 0:

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_coldown == true:
		hearts -= 10 * 0.5
		enemy_attack_coldown = false
		$AttackColdown.start()
		print("dmg")
	
func player():
	pass


func _on_attack_coldown_timeout() -> void:
	enemy_attack_coldown = true
	
func attack():
	var direction := Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("attack"):
		Global.player_curr_attack = true
		attack_in_progress  = true
		if direction > 0: # dir
			# bolas para a dir
			$DealAttack.start()
		if direction == -1:
			$DealAttack.start()
			

func _on_deal_attack_timeout() -> void:
	$DealAttack.stop()
	Global.player_curr_attack = false
	attack_in_progress = false
