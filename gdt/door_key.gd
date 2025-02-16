extends Area2D

func _ready() -> void:
	$open.visible = false
	$close.visible = true


func _on_key_door_opened() -> void:
	$open.visible = true
	$close.visible = false
