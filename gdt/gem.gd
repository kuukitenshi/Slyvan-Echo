extends Area2D

class_name Gem

signal gem_collected
var has_gem_red = false
var has_gem_green = false
var has_gem_purple = false

var open_red = false
var open_green = false
var open_purple = false

@export var type = ""
@export var door : Node2D  = null

func _on_body_entered(body):
	if body.name == "Player":
		#Global.gems_collected += 1
		if type == "green":
			has_gem_green = true
		elif type == "purple":
			has_gem_purple = true
		elif type == "red":
			has_gem_red = true
		gem_collected.emit()
		$CollectedKeySfx.play()
		hide()

func _on_collected_sfx_finished() -> void:
	queue_free()
