extends CanvasLayer

var is_paused = false

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	visible = is_paused

func _on_Resume_pressed():
	toggle_pause()



func _on_MainMenu_pressed():
	get_tree().paused = false
	SceneManager.fade_to_scene("res://core/ui/main_menu.tscn")
