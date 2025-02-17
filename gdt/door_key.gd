extends StaticBody2D

@onready var closed: AnimatedSprite2D = $closed
@onready var open: AnimatedSprite2D = $open
@onready var collision: CollisionShape2D = $collision

var is_open = false

func _ready() -> void:
	closed.visible = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		assert(body is Player)
		if body.has_key and not is_open:
			closed.visible = false
			open.visible = true
			is_open = true
			collision.queue_free()
