extends CanvasLayer

var is_paused = false

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("pausemenu"):
		toggle_pause()
		get_viewport().set_input_as_handled()

func toggle_pause():
	is_paused = !is_paused
	
	get_tree().paused = is_paused
	visible = is_paused

# =========================
# RESUME
# =========================
func _on_resume_button_pressed() -> void:
	toggle_pause()

# =========================
# RESTART
# =========================
func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

# =========================
# MAIN MENU
# =========================
func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
