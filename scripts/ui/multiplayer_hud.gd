extends Control

const ICONS := {
	MultiplayerHandler.ACTION.CHARGE: preload("res://assets/icons/pan_flute.png"),
	MultiplayerHandler.ACTION.SHOOT: preload("res://assets/icons/drops.png"),
	MultiplayerHandler.ACTION.MOVE: preload("res://assets/icons/two_arrows.png"),
	MultiplayerHandler.ACTION.AIM: preload("res://assets/icons/target.png")
}

const ICONS_HELPER := {
	MultiplayerHandler.ACTION.CHARGE: preload("res://assets/icons/xbox_button_x_outline.png"),
	MultiplayerHandler.ACTION.SHOOT: preload("res://assets/icons/xbox_button_a_outline.png"),
	MultiplayerHandler.ACTION.MOVE: preload("res://assets/icons/xbox_stick_r.png"),
	MultiplayerHandler.ACTION.AIM: preload("res://assets/icons/xbox_stick_l.png")
}

@onready var player1_container: HBoxContainer = %Player1IconContainer
@onready var player2_container: HBoxContainer = %Player2IconContainer
@onready var player1_timer: Label = %Timer1Label
@onready var player2_timer: Label = %Timer2Label
@onready var change_audio_player: AudioStreamPlayer2D = %ChangeAudioStreamPlayer2D
@onready var warning_audio_player: AudioStreamPlayer2D = %WarningAudioStreamPlayer2D

@onready var player1_shuffle_indicator: Panel = %Player1ShufflePanel
@onready var player2_shuffle_indicator: Panel = %Player2ShufflePanel
@onready var player1_shuffle_panel_container: PanelContainer = %Player1ShuffleContainer
@onready var player2_shuffle_panel_container: PanelContainer = %Player2ShuffleContainer
@onready var change_container: PanelContainer = %ChangeContainer

func _ready():
	compute_icons_position(false)
	EventBus.controls_mixed.connect(compute_icons_position)
	EventBus.send_controls_mixed_warning.connect(play_warning)
	change_container.visible = false

func _process(delta: float) -> void:
	if MultiplayerHandler.mix_timer:
		player1_timer.text = "%.1f" % MultiplayerHandler.mix_timer.time_left
		player2_timer.text = "%.1f" % MultiplayerHandler.mix_timer.time_left
	

func compute_icons_position(with_sound : bool = true):
	cleanup_icons()
	
	print("MultiplayerHandler : ", MultiplayerHandler.player_actions)
	if with_sound:
		change_audio_player.play()
		display_change_panel()
	
	for icon_key in ICONS.keys():
		var player = MultiplayerHandler.player_actions.get(icon_key)
		var row_container = create_icon_row(ICONS.get(icon_key), ICONS_HELPER.get(icon_key))
		if player == MultiplayerHandler.PLAYER.ONE:
			player1_container.add_child(row_container)
		else:
			player2_container.add_child(row_container)
		
		player1_shuffle_indicator.visible = MultiplayerHandler.shuffle_action_player == MultiplayerHandler.PLAYER.ONE 
		player2_shuffle_indicator.visible = MultiplayerHandler.shuffle_action_player == MultiplayerHandler.PLAYER.TWO 

func create_icon_row(main_icon_texture: Resource, helper_icon_texture: Resource) -> VBoxContainer:
	var row_container = VBoxContainer.new()
	row_container.alignment = BoxContainer.ALIGNMENT_CENTER

	var main_icon = create_empty_icon_container(main_icon_texture)
	row_container.add_child(main_icon)

	var helper_icon = create_empty_icon_container(helper_icon_texture)
	helper_icon.modulate = Color(1, 1, 1, 0.85)
	row_container.add_child(helper_icon)
	return row_container

func create_empty_icon_container(r: Resource) -> TextureRect:
	var icon_container = TextureRect.new()
	icon_container.texture = r
	icon_container.modulate = Color(1,1,1,1)
	icon_container.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return icon_container
	
func cleanup_icons():
	for c in player1_container.get_children():
		c.queue_free()
	for c in player2_container.get_children():
		c.queue_free()

func play_warning():
	blink(player1_shuffle_panel_container)
	blink(player2_shuffle_panel_container)
	warning_audio_player.play()
	await warning_audio_player.finished
	EventBus.warning_played.emit()

func blink(p: PanelContainer):
	var tween = create_tween()
	tween.set_loops(3)
	var original_modulate = p.modulate
	tween.tween_property(p, "modulate", Color(1, 1, 0, 1), 0.5)
	tween.tween_property(p, "modulate", original_modulate, 0.5)

func display_change_panel():
	var tween = create_tween()
	tween.tween_property(change_container, "visible", true, 0.5)
	tween.tween_property(change_container, "visible", false, 0.5)
