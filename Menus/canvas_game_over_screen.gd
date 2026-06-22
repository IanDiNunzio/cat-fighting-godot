extends CanvasLayer

@onready var game_over_screen = $GameOverScreen
@onready var portrait : TextureRect = $GameOverScreen/WinnerPortrait
@onready var name_label = $GameOverScreen/NameLabel


# RETRATOS

@onready var player1_portrait = preload("res://Imagenes/retrato3.png")
@onready var player2_portrait = preload("res://Imagenes/retratoblackcat.png")


# READY

func _ready():

	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	visible = false


# MOSTRAR GANADOR

func set_winner(player_name : String, winner_portrait = null):

	visible = true

	get_tree().paused = true

	name_label.text = player_name + " won the battle!"

	# Si GameManager envia retrato
	if winner_portrait != null:

		portrait.texture = winner_portrait

		return

	# PLAYER 1
	if player_name == "Player":

		portrait.texture = player1_portrait

	# PLAYER 2
	elif player_name == "Player 2":

		portrait.texture = player2_portrait


# RESTART

func _on_restart_button_pressed():

	get_tree().paused = false

	visible = false

	GameManager.restart_match()


# EXIT

func _on_exit_button_pressed():

	get_tree().paused = false

	get_tree().change_scene_to_file("res://Menus/level_selector.tscn")
