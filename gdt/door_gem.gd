extends StaticBody2D

@export var door_type = ""
signal player_entered()

@onready var closed: AnimatedSprite2D = $closed
@onready var open: AnimatedSprite2D = $open
@onready var collision: CollisionShape2D = $collision

var is_open = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_entered.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		assert(body is Player)
		if body.gem_list.has(door_type) and not is_open:
			open.visible = true
			closed.visible = false
			is_open = true
			collision.queue_free()
