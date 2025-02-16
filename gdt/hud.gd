extends CanvasLayer


func _on_key_key_collected() -> void:
	$collectiblesBar/key.modulate = "#e2ab33"

func _on_gem_red_gem_collected() -> void:
	$collectiblesBar/red_gem.modulate = "#e74567"

func _on_gem_green_gem_collected() -> void:
	$collectiblesBar/green_gem.modulate = "#30c394"

func _on_gem_purple_gem_collected() -> void:
	$collectiblesBar/purple_gem.modulate = "#989dfc"
