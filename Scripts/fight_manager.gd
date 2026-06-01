extends Node

@onready var countdown_label = $CanvasLayer/CountdownLabel

func _ready():
	start_countdown()

func start_countdown() -> void:

	countdown_label.visible = true

	countdown_label.text = "3"
	await get_tree().create_timer(1.0).timeout

	countdown_label.text = "2"
	await get_tree().create_timer(1.0).timeout

	countdown_label.text = "1"
	await get_tree().create_timer(1.0).timeout

	countdown_label.text = "GO!"
	enable_players()

	await get_tree().create_timer(0.5).timeout
	countdown_label.visible = false

func enable_players():

	for player in get_tree().get_nodes_in_group("players"):
		player.can_move = true
