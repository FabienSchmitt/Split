class_name SingleplayerHandler
extends Node

var _lama: Lama 

func _init(p: Lama) -> void: 
	_lama = p

func handle_input() -> void :
	if GameManager.is_game_over:
		return

	print("single player handler")
	if Input.is_action_just_pressed("p1_shoot"):
		_lama.attack(compute_spit_direction())

	_lama.current_direction = Input.get_axis("p1_move_left", "p1_move_right")

func compute_spit_direction() -> Vector2:
	var input_vector := Input.get_vector("p1_move_left", "p1_move_right", "p1_move_up", "p1_move_down")
	if input_vector == Vector2.ZERO:
		input_vector = Vector2(_lama.lama_facing_direction, 0)
	else:
		input_vector = input_vector.normalized()
	return input_vector
