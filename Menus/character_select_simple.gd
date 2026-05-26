extends CanvasLayer

# =========================
# BOTONES LOCAL
# =========================
@onready var local_2p = $"Control/LocalOnline/LocalBox/2PButton"
@onready var local_3p = $"Control/LocalOnline/LocalBox/3PButton"
@onready var local_4p = $"Control/LocalOnline/LocalBox/4PButton"

# =========================
# BOTONES ONLINE
# =========================
@onready var online_2p = $"Control/LocalOnline/OnlineBox/2PButton"
@onready var online_3p = $"Control/LocalOnline/OnlineBox/3PButton"
@onready var online_4p = $"Control/LocalOnline/OnlineBox/4PButton"

# =========================
# READY
# =========================
@onready var ready_button = $Control/ReadyButton

# =========================
# READY
# =========================
func _ready():

	# LOCAL
	local_2p.pressed.connect(func(): select_mode("local", 2))
	local_3p.pressed.connect(func(): select_mode("local", 3))
	local_4p.pressed.connect(func(): select_mode("local", 4))

	# ONLINE
	online_2p.pressed.connect(func(): select_mode("online", 2))
	online_3p.pressed.connect(func(): select_mode("online", 3))
	online_4p.pressed.connect(func(): select_mode("online", 4))

	# READY
	ready_button.pressed.connect(start_game)


# =========================
# SELECCIONAR MODO
# =========================
func select_mode(mode, players):

	GameSettings.game_mode = mode
	GameSettings.player_count = players

	reset_buttons()

	# LOCAL
	if mode == "local":

		match players:

			2:
				local_2p.modulate = Color.GREEN

			3:
				local_3p.modulate = Color.GREEN

			4:
				local_4p.modulate = Color.GREEN

	# ONLINE
	else:

		match players:

			2:
				online_2p.modulate = Color.GREEN

			3:
				online_3p.modulate = Color.GREEN

			4:
				online_4p.modulate = Color.GREEN


# =========================
# RESET BOTONES
# =========================
func reset_buttons():

	local_2p.modulate = Color.WHITE
	local_3p.modulate = Color.WHITE
	local_4p.modulate = Color.WHITE

	online_2p.modulate = Color.WHITE
	online_3p.modulate = Color.WHITE
	online_4p.modulate = Color.WHITE


# =========================
# START GAME
# =========================
func start_game():

	print(GameSettings.game_mode)
	print(GameSettings.player_count)

	get_tree().change_scene_to_file("res://Escenarios/test_level.tscn")
