extends Node2D

class_name Level


func _ready() -> void:
	set_gems_label()
	for gem in $Gems.get_children():
		#gem.gem_collected.connect(_on_gem_collected)
		pass

func _on_gem_collected() -> void:
	set_gems_label()
	
func set_gems_label():
	#$HUD.gems(Global.gems_collected)
	pass

func _on_door_player_entered(level: Variant) -> void:
	$endsfx.play()
	
	
func _on_endsfx_finished() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
