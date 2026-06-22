extends CanvasLayer


# READY

func _ready():
	MusicManager.play_menu_music()


# FIGHT

func _on_fight_button_pressed() -> void:

	get_tree().change_scene_to_file("res://Menus/level_selector.tscn")


# TRAINING MODE

func _on_training_mode_button_pressed() -> void:

	get_tree().change_scene_to_file("res://online_lobby_canvas.tscn")


# OPTIONS

func _on_options_button_pressed() -> void:

	get_tree().change_scene_to_file("res://Menus/options_menu.tscn")


# CREDITS

func _on_credits_button_pressed() -> void:

	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")


# EXIT

func _on_exit_button_pressed() -> void:

	get_tree().quit()
