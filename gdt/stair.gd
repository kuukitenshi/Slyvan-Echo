extends Area2D

var distance = 112 
var speed = 50.0
var target_distance = 112 #pixeis
var player_fixed = false
var on_ladder = false

func _process(delta: float) -> void:
	if player_fixed:
		distance = lerp(float(distance), float(target_distance), delta * speed)
		position.y = distance 
		# Verifica se já subiu ou desceu 112 pixels e libera o movimento
		if abs(distance - target_distance) >= 112:
			player_fixed = false
			on_ladder = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		on_ladder = true
	#if body.name == "Player":
		#if Input.is_action_just_pressed("interact"):
			#if Input.is_action_just_pressed("move_up"):
				#target_distance -= 10
			#if Input.is_action_just_pressed("move_down"):
				#target_distance += 10 


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		on_ladder = false
		
		
func _unhandled_input(event: InputEvent) -> void:
	if on_ladder and not player_fixed:
		if event.is_action_pressed("move_up"):
			player_fixed = true
			target_distance = distance - 112  # Sobe 112 pixels
		elif event.is_action_pressed("move_down"):
			player_fixed = true
			target_distance = distance + 112  # Desce 112 pixels
