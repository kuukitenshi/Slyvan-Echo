extends CharacterBody2D

class_name Player

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

var hearts_list : Array[TextureRect] = []
var health = 5

var enemy_in_attack_range = false
var enemy_attack_coldown = true
var player_is_alive = true
var attack_in_progress = false

var gem_list : Array[String] = []
var has_key = false
var on_rope = false

var target_position : Vector2

@export var level_start_pos : Node2D
@onready var h_box_container: HBoxContainer = $health_bar/HBoxContainer
@onready var area_2d_rope: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	var hearts_parent = h_box_container
	for child in hearts_parent.get_children():
		hearts_list.append(child)
	print(hearts_list)

func _physics_process(delta: float) -> void:
	target_position = target_position.lerp(global_position, delta * 50)
	camera_2d.global_position = target_position
	if not player_is_alive:
		return
	player_movement(delta)
	enemy_attack()
	attack()
	update_heart_display()

func player_movement(delta):
	if not is_on_floor() and not on_rope:
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() || on_rope):
		if on_rope:
			_exit_rope()
		velocity.y = JUMP_VELOCITY
		$JumpSfx.play()
		
	var direction := Input.get_axis("move_left", "move_right")
	var climbDirection = Input.get_axis("ui_up", "ui_down")
	
	if on_rope:
		if climbDirection:
			position.y += climbDirection
	else:
		if direction and not on_rope:
			velocity.x = direction * SPEED 
			sprite.play("run")
			if direction == -1:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		elif not direction and not on_rope:
			velocity.x = move_toward(velocity.x, 0, SPEED / 2)
			sprite.play("idle")
			
	if not is_on_floor():
		sprite.play("jump")

	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false
		
func color_dmg():
	var timer = 0.1
	sprite.modulate = Color.DARK_RED
	await get_tree().create_timer(timer).timeout
	sprite.modulate = Color.WHITE
	await get_tree().create_timer(timer).timeout
	sprite.modulate = Color.DARK_RED
	await get_tree().create_timer(timer).timeout
	sprite.modulate = Color.WHITE
	await get_tree().create_timer(timer).timeout
	sprite.modulate = Color.DARK_RED
	await get_tree().create_timer(timer).timeout
	sprite.modulate = Color.WHITE

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_coldown == true:
		health -= 1
		color_dmg()
		enemy_attack_coldown = false
		$AttackColdown.start()
	
func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health
	if health <= 0:
		player_is_alive = false
		sprite.play("dead")
		$deathsfx.play()
		health = 0
		visible = false
		await get_tree().create_timer(1).timeout
		reset_player()
	
func reset_player() -> void:
	position = level_start_pos.position
	visible = true
	player_is_alive = true
	health = 5
	health_player()
	
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
			# TODO: bolas para a dir
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
		color_dmg()
	else:
		health = 0
	update_heart_display()

func _enter_rope(area):
	print("entrou")
	on_rope = true
	reparent(area)
	global_position = area.get_rope_position(self)
	rotation_degrees = 0
	velocity = Vector2.ZERO
#
func _exit_rope():
	print("a sair corda")
	area_2d_rope.monitoring = false
	on_rope = false 
	print("antes reparent: ", get_parent())
	reparent(get_tree().current_scene)
	print("dps reparent: ", get_parent())
	rotation_degrees = 0
	await get_tree().create_timer(0.5).timeout
	area_2d_rope.monitoring = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("rope") and not on_rope:
		call_deferred("_enter_rope", area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("rope") and on_rope:
		on_rope = false
		reparent(get_tree().current_scene)
		rotation_degrees = 0
