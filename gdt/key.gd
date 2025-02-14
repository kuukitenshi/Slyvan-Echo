extends Area2D

signal key_collected

func _on_body_entered(body):
	if body.name == "Player":
		key_collected.emit()
		$CollectedKeySfx.play()
		hide()

func _on_collected_key_sfx_finished() -> void:
	queue_free()
