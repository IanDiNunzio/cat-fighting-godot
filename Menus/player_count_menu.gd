extends Control

func _ready():
	$CenterContainer/VBoxContainer/ButtonsContainer/Btn2P.pressed.connect(_on_2p_pressed)
	$CenterContainer/VBoxContainer/ButtonsContainer/Btn3P.pressed.connect(_on_3p_pressed)
	$CenterContainer/VBoxContainer/ButtonsContainer/Btn4P.pressed.connect(_on_4p_pressed)

func _on_2p_pressed():
	GameManager.player_count = 2
	start_game_flow()

func _on_3p_pressed():
	GameManager.player_count = 3
	start_game_flow()

func _on_4p_pressed():
	GameManager.player_count = 4
	start_game_flow()

func start_game_flow():
	get_tree().change_scene_to_file("res://Scenes/CharacterSelect.tscn")


func _on_btn_2p_pressed() -> void:
	pass # Replace with function body.


func _on_btn_3p_pressed() -> void:
	pass # Replace with function body.


func _on_btn_4p_pressed() -> void:
	pass # Replace with function body.
