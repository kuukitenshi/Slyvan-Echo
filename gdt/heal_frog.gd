extends Node

func _ready() -> void:
	$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		body.health_player()
		$sfx.play()
