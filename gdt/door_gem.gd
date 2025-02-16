extends Area2D

@export var door_type = ""
signal player_entered(door_type)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_entered.emit(door_type)
		
