extends Control

func _ready():
	# Estado inicial
	$CatRect1.visible = true
	$CatRect2.visible = false

	await get_tree().create_timer(3.0).timeout

	# Cambiar imágenes
	$CatRect1.visible = false
	$CatRect2.visible = true
	$CatWink.play()

	await get_tree().create_timer(2.0).timeout

	# Ir al menú principal
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
