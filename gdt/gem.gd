extends Area2D

signal key_collected

func _on_body_entered(body):
	if body.name == "Player":
		Global.gems_collected += 1
		key_collected.emit()
		$CollectedKeySfx.play()
		hide()


func _on_collected_sfx_finished() -> void:
	queue_free()
