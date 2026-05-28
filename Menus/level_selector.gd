extends CanvasLayer

# =========================
# MAPAS
# =========================
var selected_map := "rooftop"
var selected_players := 2
var selected_mode := "local"

# =========================
# PREVIEW
# =========================
@onready var preview = $RightPanel/PreviewTexture
@onready var map_name = $RightPanel/MapLabel

# =========================
# BOTONES MAPAS
# =========================
@onready var rooftop_button = $VBoxContainer/GridContainer/VBoxContainer/TextureButton
@onready var street_button = $VBoxContainer/GridContainer/VBoxContainer2/TextureButton
@onready var park_button = $VBoxContainer/GridContainer/VBoxContainer3/TextureButton
@onready var beach_button = $VBoxContainer/GridContainer/VBoxContainer4/TextureButton

# =========================
# CONTENEDORES MAPAS
# =========================
@onready var rooftop_container = $VBoxContainer/GridContainer/VBoxContainer
@onready var street_container = $VBoxContainer/GridContainer/VBoxContainer2
@onready var park_container = $VBoxContainer/GridContainer/VBoxContainer3
@onready var beach_container = $VBoxContainer/GridContainer/VBoxContainer4

# =========================
# LOCAL
# =========================
@onready var local_p2 = $"PlayersPanel/LocalHBox/2P"
@onready var local_p3 = $"PlayersPanel/LocalHBox/3P"
@onready var local_p4 = $"PlayersPanel/LocalHBox/4P"

# =========================
# ONLINE
# =========================
@onready var online_p2 = $"PlayersPanel/OnlineHBox/2P"
@onready var online_p3 = $"PlayersPanel/OnlineHBox/3P"
@onready var online_p4 = $"PlayersPanel/OnlineHBox/4P"

# =========================
# READY
# =========================
func _ready():

	# =========================
	# MAPAS
	# =========================
	rooftop_button.pressed.connect(_on_rooftop_pressed)
	street_button.pressed.connect(_on_street_pressed)
	park_button.pressed.connect(_on_park_pressed)
	beach_button.pressed.connect(_on_beach_pressed)

	# =========================
	# LOCAL
	# =========================
	local_p2.pressed.connect(_on_local_2p_pressed)
	local_p3.pressed.connect(_on_local_3p_pressed)
	local_p4.pressed.connect(_on_local_4p_pressed)

	# =========================
	# ONLINE
	# =========================
	online_p2.pressed.connect(_on_online_2p_pressed)
	online_p3.pressed.connect(_on_online_3p_pressed)
	online_p4.pressed.connect(_on_online_4p_pressed)

	# =========================
	# DEFAULTS
	# =========================
	select_map(
		"rooftop",
		preload("res://Imagenes/RoofTop.png"),
		rooftop_container
	)

	select_players(2, "local")

# =========================
# MAPAS
# =========================
func select_map(map_id : String, texture : Texture2D, container):

	selected_map = map_id

	preview.texture = texture
	map_name.text = map_id.capitalize()

	reset_map_colors()

	container.modulate = Color(0.5, 1.5, 0.5)

# =========================
# PLAYERS
# =========================
func select_players(amount : int, mode : String):

	selected_players = amount
	selected_mode = mode

	reset_player_colors()

	if mode == "local":

		match amount:

			2:
				local_p2.modulate = Color(0.5, 1.5, 1)

			3:
				local_p3.modulate = Color(0.5, 1.5, 1)

			4:
				local_p4.modulate = Color(0.5, 1.5, 1)

	else:

		match amount:

			2:
				online_p2.modulate = Color(0.5, 1.5, 1)

			3:
				online_p3.modulate = Color(0.5, 1.5, 1)

			4:
				online_p4.modulate = Color(0.5, 1.5, 1)

# =========================
# RESET MAP COLORS
# =========================
func reset_map_colors():

	rooftop_container.modulate = Color.WHITE
	street_container.modulate = Color.WHITE
	park_container.modulate = Color.WHITE
	beach_container.modulate = Color.WHITE

# =========================
# RESET PLAYER COLORS
# =========================
func reset_player_colors():

	local_p2.modulate = Color.WHITE
	local_p3.modulate = Color.WHITE
	local_p4.modulate = Color.WHITE

	online_p2.modulate = Color.WHITE
	online_p3.modulate = Color.WHITE
	online_p4.modulate = Color.WHITE

# =========================
# RETURN
# =========================
func _on_return_button_pressed() -> void:

	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# =========================
# LOCAL
# =========================
func _on_local_2p_pressed():

	select_players(2, "local")

func _on_local_3p_pressed():

	select_players(3, "local")

func _on_local_4p_pressed():

	select_players(4, "local")

# =========================
# ONLINE
# =========================
func _on_online_2p_pressed():

	select_players(2, "online")

func _on_online_3p_pressed():

	select_players(3, "online")

func _on_online_4p_pressed():

	select_players(4, "online")

# =========================
# ROOFTOP
# =========================
func _on_rooftop_pressed():

	select_map(
		"rooftop",
		preload("res://Imagenes/RoofTop.png"),
		rooftop_container
	)

# =========================
# STREET
# =========================
func _on_street_pressed():

	select_map(
		"street",
		preload("res://Imagenes/calleimagen.png"),
		street_container
	)

# =========================
# PARK
# =========================
func _on_park_pressed():

	select_map(
		"park",
		preload("res://Imagenes/parqueimagen.png"),
		park_container
	)

# =========================
# BEACH
# =========================
func _on_beach_pressed():

	select_map(
		"beach",
		preload("res://Imagenes/azoteaimagen.png"),
		beach_container
	)

# =========================
# READY
# =========================
func _on_ready_button_pressed() -> void:

	print("Mapa:", selected_map)
	print("Jugadores:", selected_players)
	print("Modo:", selected_mode)

	# =========================
	# GUARDAR DATOS
	# =========================
	Global.selected_map = selected_map
	Global.player_count = selected_players
	Global.game_mode = selected_mode

	# =========================
	# CARGAR MAPA
	# =========================
	match selected_map:

		"rooftop":
			get_tree().change_scene_to_file("res://Escenarios/rooftop.tscn")

		"street":
			get_tree().change_scene_to_file("res://Escenarios/test_level.tscn")

		"park":
			get_tree().change_scene_to_file("res://Scenes/park.tscn")

		"beach":
			get_tree().change_scene_to_file("res://Scenes/beach.tscn")
