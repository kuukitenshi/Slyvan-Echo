extends Area2D

@export var SPEED = 2.0 
@export var AMPLITUDE = 30  #degrees

var time = 0.0

func _process(delta: float) -> void:
	time += delta * SPEED
	rotation_degrees = sin(time) * AMPLITUDE

func get_rope_position(body):
	var newPosition
	var shortestDistance
	for child in get_children():
		if not child is Sprite2D:
			continue
		var distance = body.global_position.distance_to(child.global_position)
		if not shortestDistance || distance < shortestDistance:
			newPosition = child.global_position
			shortestDistance = distance
	return newPosition
