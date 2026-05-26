extends Control

@onready var portrait = $WinnerPortrait
@onready var name_label = $NameLabel

# =========================
# READY
# =========================
func _ready():

	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

# =========================
# MOSTRAR GANADOR
# =========================
func set_winner(player_name, player_portrait):

	name_label.text = player_name

	portrait.texture = player_portrait

# =========================
# RESTART
# =========================
func _on_restart_button_pressed():

	get_tree().paused = false

	GameManager.restart_match()

# =========================
# EXIT
# =========================
func _on_exit_button_pressed():

	get_tree().paused = false

	get_tree().quit()
