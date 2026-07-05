extends Node 

enum ACTION {SHOOT, MOVE, AIM, CHARGE, SHUFFLE}
enum PLAYER {ONE, TWO, UNDEFINED}

var  player_actions: Dictionary[ACTION, PLAYER] = {
	ACTION.SHOOT:  PLAYER.TWO,
	ACTION.MOVE: PLAYER.ONE,
	ACTION.AIM: PLAYER.TWO,
	ACTION.CHARGE: PLAYER.ONE
}

var shuffle_action_player := PLAYER.UNDEFINED

var is_singleplayer := false
var mix_timer: SceneTreeTimer
var is_changing := false

func _ready() -> void:
	EventBus.game_starts.connect(plan_next_mix)
	EventBus.warning_played.connect(mix_controls)
	shuffle_action_player = randi_range(PLAYER.ONE, PLAYER.TWO)


func set_single_player():
	is_singleplayer = true
	for pa_key in player_actions.keys():
		player_actions.set(pa_key, PLAYER.ONE)

func handle_inputs(lama: Lama) -> void :
	if GameManager.is_game_over:
		return
	
	# Aiming
	lama.set_aiming_direction(get_aiming_direction())

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

	# Shuffle
	if (Input.is_action_just_pressed("p1_shuffle") && shuffle_action_player == PLAYER.ONE || \
		Input.is_action_just_pressed("p2_shuffle") && shuffle_action_player == PLAYER.TWO) && \
		!is_changing:

		is_changing = true
		send_mix_warning()

func compute_spit_direction(lama: Lama) -> Vector2:

	var input_vector = get_aiming_direction()

	if input_vector == Vector2.ZERO:
		input_vector = Vector2(lama.lama_facing_direction, 0)
	else:
		input_vector = input_vector.normalized()
	return input_vector

func get_aiming_direction() -> Vector2:
	var input_vector := Input.get_vector("p1_aim_left", "p1_aim_right", "p1_aim_up", "p1_aim_down") \
		if  player_actions.get(ACTION.AIM) == PLAYER.ONE else \
		 Input.get_vector("p2_aim_left", "p2_aim_right", "p2_aim_up", "p2_aim_down")
	return input_vector.normalized()


func mix_controls():
	if is_singleplayer: return

	for pa_key in player_actions.keys():
		var player = randi_range(PLAYER.ONE, PLAYER.TWO)
		player_actions.set(pa_key, player)
	
	# check shuffle 
	var player_1_controls = player_actions.values().filter(func(x) -> bool : return x == PLAYER.ONE)
	if player_1_controls.size() < 2:
		shuffle_action_player = PLAYER.ONE
	elif player_1_controls.size() > 2 : 
		shuffle_action_player = PLAYER.TWO
	else :
		shuffle_action_player = randi_range(PLAYER.ONE, PLAYER.TWO)

	EventBus.controls_mixed.emit()
	is_changing = false
	
	plan_next_mix()

func plan_next_mix():
	mix_timer = get_tree().create_timer(20)
	mix_timer.timeout.connect(func() : send_mix_warning())

func send_mix_warning():
	EventBus.send_controls_mixed_warning.emit()
	
