extends RigidBody2D

func _ready() -> void:
	$open.visible = false
	$close.visible = true


func _on_key_door_opened() -> void:
	$open.visible = true
	print("visivel aberta")
	$close.visible = false
	$collision.disabled = true
