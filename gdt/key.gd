extends Area2D

class_name Key

signal key_collected

@export var door : Node2D  = null
@onready var collected_key_sfx: AudioStreamPlayer = $CollectedKeySfx


func _on_body_entered(body):
	if body.name == "Player":
		body.has_key = true
		key_collected.emit()
		collected_key_sfx.play()
		hide()

func _on_collected_key_sfx_finished() -> void:
	queue_free()
