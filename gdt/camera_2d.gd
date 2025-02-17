extends Camera2D

@export var player : Player
@export var speed : float
var target_position : Vector2

func _physics_process(delta: float) -> void:
	target_position = target_position.slerp(player.global_position, delta * speed)
	global_position = target_position
