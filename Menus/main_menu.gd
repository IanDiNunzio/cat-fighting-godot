extends CanvasLayer

func _ready():
	$Panel/VBoxContainer/Continue.disabled = Global.current_level_path == ""

func _on_Continue_pressed():
	SceneManager.fade_to_scene(Global.current_level_path)

func _on_NewGame_pressed():
	SceneManager.fade_to_scene("res://scenes/LevelBase.tscn")

func _on_Options_pressed():
	SceneManager.fade_to_scene("res://core/ui/options_menu.tscn")

func _on_Quit_pressed():
	get_tree().quit()
