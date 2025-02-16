extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

var hearts_list : Array[TextureRect]
var health = 5

var enemy_in_attack_range = false
var enemy_attack_coldown = true
var player_is_alive = true
var attack_in_progress = false

@onready var h_box_container: HBoxContainer = $health_bar/HBoxContainer


func _ready() -> void:
	var hearts_parent = h_box_container
	for child in hearts_parent.get_children():
		hearts_list.append(child)
	print(hearts_list)


func _physics_process(delta: float) -> void:
	if not player_is_alive:
		return
	player_movement(delta)
	enemy_attack()
	attack()
	update_heart_display()


func player_movement(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSfx.play()
		
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		position.x += direction * SPEED * delta
		$AnimatedSprite2D.play("run")
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		#velocity.x = move_toward(velocity.x, 0, SPEED / 2)
		$AnimatedSprite2D.play("idle")
		
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_coldown == true:
		health -= 1
		enemy_attack_coldown = false
		$AttackColdown.start()
	
func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health
	if health <= 0:
		player_is_alive = false
		$AnimatedSprite2D.play("dead")
		$deathsfx.play()
		health = 0
		visible = false
		await get_tree().create_timer(1).timeout
		reset_player()
	
func reset_player() -> void:
	position = get_parent().level_start_pos # TODO:
	visible = true
	player_is_alive = true
	
func health_player():
	if health < 5:
		health = 5
		update_heart_display()

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
	
func handle_spikes() -> void:
	if health > 2:
		health -= 2
	else:
		health = 0
	update_heart_display()
