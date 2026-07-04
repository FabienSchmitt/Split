extends Node 

enum ACTION {SHOOT, MOVE, AIM, CHARGE}
enum PLAYER {ONE, TWO}

var  player_actions: Dictionary[ACTION, PLAYER] = {
	ACTION.SHOOT:  PLAYER.TWO,
	ACTION.MOVE: PLAYER.ONE,
	ACTION.AIM: PLAYER.TWO,
	ACTION.CHARGE: PLAYER.ONE
}

func set_single_player():
	for pa_key in player_actions.keys():
		player_actions.set(pa_key, PLAYER.ONE)

func handle_inputs(lama: Lama) -> void :
	if GameManager.is_game_over:
		return
		
	# Shooting
	if Input.is_action_just_pressed("p1_shoot") && player_actions.get(ACTION.SHOOT) == PLAYER.ONE || \
		Input.is_action_just_pressed("p2_shoot") && player_actions.get(ACTION.SHOOT) == PLAYER.TWO:
		lama.stop_charging()
		lama.attack(compute_spit_direction(lama))
	
	# Moving
	lama.current_direction = Input.get_axis("p1_move_left", "p1_move_right") if  player_actions.get(ACTION.MOVE) == PLAYER.ONE else \
		Input.get_axis("p2_move_left", "p2_move_right")

	# Crachat
	if Input.is_action_just_pressed("p1_charge") && player_actions.get(ACTION.CHARGE) == PLAYER.ONE || \
		Input.is_action_just_pressed("p2_charge") && player_actions.get(ACTION.CHARGE) == PLAYER.TWO:
		# play sound and increase progress bar
		lama.start_charging()

	elif Input.is_action_just_released("p1_charge") && player_actions.get(ACTION.CHARGE) == PLAYER.ONE || \
		Input.is_action_just_released("p2_charge") && player_actions.get(ACTION.CHARGE) == PLAYER.TWO:
		lama.stop_charging()

func compute_spit_direction(lama: Lama) -> Vector2:

	var input_vector := Input.get_vector("p1_move_left", "p1_move_right", "p1_move_up", "p1_move_down") \
		if  player_actions.get(ACTION.AIM) == PLAYER.ONE else \
		 Input.get_vector("p2_move_left", "p2_move_right", "p2_move_up", "p2_move_down") 

	if input_vector == Vector2.ZERO:
		input_vector = Vector2(lama.lama_facing_direction, 0)
	else:
		input_vector = input_vector.normalized()
	return input_vector
