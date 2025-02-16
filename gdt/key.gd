extends Area2D

signal key_collected
signal door_opened

var key_taken = false
var in_door_zone = false


func _on_body_entered(body):
	if body.name == "Player" and key_taken == false:
		key_collected.emit()
		key_taken = true
		$CollectedKeySfx.play()
		hide()

func _on_collected_key_sfx_finished() -> void:
	queue_free()

func _process(delta: float) -> void:
	if key_taken and in_door_zone:
		if Input.is_action_just_pressed("ui_accept"):
			print("door opened")
			door_opened.emit()
			


func _on_door_key_body_entered(body: Node2D) -> void:
	in_door_zone = true


func _on_door_key_body_exited(body: Node2D) -> void:
	in_door_zone = false
