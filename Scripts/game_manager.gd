extends Node

# =========================
# CONFIGURACION
# =========================
var player_count := 2

# =========================
# JUGADORES
# =========================
var players := []

# =========================
# ESCENA GAME OVER
# =========================
var game_over_scene : PackedScene = preload("res://Menus/canvas_game_over_screen.tscn")

# Evitar mostrar varias veces
var game_ended := false

# =========================
# READY
# =========================
func _ready():

	# Verificar que exista la escena
	if game_over_scene == null:

		push_error("No se pudo cargar game_over_screen.tscn")

# =========================
# REGISTRAR JUGADOR
# =========================
func register_player(player):

	if player not in players:
		players.append(player)

# =========================
# ELIMINAR JUGADOR
# =========================
func remove_player(player):

	if player in players:
		players.erase(player)

	check_winner()

# =========================
# VERIFICAR GANADOR
# =========================
func check_winner():

	# Evitar repetir
	if game_ended:
		return

	var alive_players := []

	for p in players:

		if is_instance_valid(p) and !p.dead:
			alive_players.append(p)

	# Si solo queda uno vivo
	if alive_players.size() == 1:

		game_ended = true

		show_game_over(alive_players[0])

# =========================
# MOSTRAR PANTALLA FINAL
# =========================
func show_game_over(winner):

	# Verificar escena
	if game_over_scene == null:

		push_error("game_over_scene es null")
		return

	# Crear pantalla primero
	var screen = game_over_scene.instantiate()

	# Verificar instancia
	if screen == null:

		push_error("No se pudo instanciar game_over_screen")
		return

	# Permitir funcionar pausado
	screen.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# Añadir a escena actual
	get_tree().current_scene.add_child(screen)

	# Pasar datos del ganador
	if screen.has_method("set_winner"):

		screen.set_winner(
			winner.character_name,
			winner.portrait
		)

	# Pausar DESPUES de crear la UI
	get_tree().paused = true

# =========================
# REINICIAR PELEA
# =========================
func restart_match():

	game_ended = false

	players.clear()

	get_tree().paused = false

	get_tree().reload_current_scene()
