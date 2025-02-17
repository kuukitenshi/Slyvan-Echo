extends Node2D

class_name Level


func _on_door_player_entered(level: Variant) -> void:
	$endsfx.play()
	

func _on_endsfx_finished() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
