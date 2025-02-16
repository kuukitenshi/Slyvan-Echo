extends Node

var player_curr_attack = false

func _ready() -> void:
	pass

func _input(event):
	if event.is_action_pressed("return_to_main_menu"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
