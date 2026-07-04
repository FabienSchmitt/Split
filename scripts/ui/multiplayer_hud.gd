extends CanvasLayer

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

func _ready():
	compute_icons_position()

func compute_icons_position():
	cleanup_icons()
	
	print("MultiplayerHandler : ", MultiplayerHandler.player_actions)
	
	for icon_key in ICONS.keys():
		var player = MultiplayerHandler.player_actions.get(icon_key)
		var row_container = create_icon_row(ICONS.get(icon_key), ICONS_HELPER.get(icon_key))
		if player == MultiplayerHandler.PLAYER.ONE:
			player1_container.add_child(row_container)
		else:
			player2_container.add_child(row_container)

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
