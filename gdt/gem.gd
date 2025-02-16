extends Area2D

class_name Gem

signal gem_collected


@export var type = ""
@export var door : Node2D  = null

func _on_body_entered(body):
	if body.name == "Player":
		body.gem_list.append(type)
		gem_collected.emit()
		$CollectedSfx.play()
		hide()

func _on_collected_sfx_finished() -> void:
	queue_free()
