class_name MultiplayerHandler
extends RefCounted


enum ACTION {SHOOT, MOVE, AIM, LOAD}
enum PLAYER {ONE, TWO}

var _lama: Lama

var  player_actions: Dictionary[ACTION, PLAYER] = {
	ACTION.SHOOT:  PLAYER.TWO,
	ACTION.MOVE: PLAYER.ONE,
	ACTION.AIM: PLAYER.TWO,
	ACTION.LOAD: PLAYER.ONE
}

func _init(l: Lama) -> void:
	_lama = l

func handle_inputs() -> void :
	if Input.is_action_just_pressed("p1_shoot") && player_actions.get(ACTION.SHOOT) == PLAYER.ONE || \
		Input.is_action_just_pressed("p2_shoot") && player_actions.get(ACTION.SHOOT) == PLAYER.TWO:
		_lama.attack(compute_spit_direction())
	
	_lama.current_direction = Input.get_axis("p1_move_left", "p1_move_right") if  player_actions.get(ACTION.MOVE) == PLAYER.ONE else \
		Input.get_axis("p2_move_left", "p2_move_right")

func compute_spit_direction() -> Vector2:

	var input_vector := Input.get_vector("p1_move_left", "p1_move_right", "p1_move_up", "p1_move_down") \
		if  player_actions.get(ACTION.AIM) == PLAYER.ONE else \
		 Input.get_vector("p2_move_left", "p2_move_right", "p2_move_up", "p2_move_down") 

	if input_vector == Vector2.ZERO:
		input_vector = Vector2(_lama.lama_facing_direction, 0)
	else:
		input_vector = input_vector.normalized()
	return input_vector
