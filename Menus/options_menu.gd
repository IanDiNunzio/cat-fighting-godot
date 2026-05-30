extends CanvasLayer

@onready var music_slider = $MusicVBOX/MusicSlider
@onready var sfx_slider = $SFXVBOX/SFXSlider


func _ready() -> void:
	# Valor inicial de las barras (50%)
	music_slider.value = 50
	sfx_slider.value = 50

	# Conectar sliders
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)

	# Aplicar volumen inicial
	_on_music_slider_value_changed(music_slider.value)
	_on_sfx_slider_value_changed(sfx_slider.value)

	# Mantener música del menú
	MusicManager.play_menu_music()


func _on_music_slider_value_changed(value: float) -> void:
	var v = value / 100.0

	if v <= 0:
		MusicManager.music_player.volume_db = -80
	else:
		MusicManager.music_player.volume_db = linear_to_db(v)

	# Guardar valor global (IMPORTANTE)
	MusicManager.set_music_volume(v)


func _on_sfx_slider_value_changed(value: float) -> void:
	var v = value / 100.0

	if v <= 0:
		MusicManager.sfx_player.volume_db = -80
	else:
		MusicManager.sfx_player.volume_db = linear_to_db(v)

	# Guardar valor global (IMPORTANTE)
	MusicManager.set_sfx_volume(v)


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
