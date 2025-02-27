extends CharacterBody2D

var speed = 35
var player_chase = false
var player = null

var health = 100
var player_in_attack_area = false
var can_take_dmg = true

@export var sprite: AnimatedSprite2D = null
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	sprite.visible = true
	sprite.position = collision_shape_2d.position
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	deal_with_dmg()
	if player_chase:
		position += (player.position - position)/speed
		sprite.play("walk")
		if(player.position.x - position.x) < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		sprite.play("idle")
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(body)
		player = body
		player_chase = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_area = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_area = false

func deal_with_dmg():
	if player_in_attack_area and Global.player_curr_attack == true:
		if can_take_dmg:
			health = health - 20
			$takeDmgCooldown.start()
			can_take_dmg = false
			if health <= 0:
				sprite.play("dead")
				await get_tree().create_timer(2).timeout
				self.queue_free()


func _on_take_dmg_cooldown_timeout() -> void:
	can_take_dmg = true
