extends Node

@onready var music_player = $MusicPlayer
@onready var sfx_player = $SFXPlayer


# MUSICAS


var menu_music = preload("res://Musica/627416__victor_natas__fear-creeps-upon-you.wav")
var level_select_music = preload("res://Musica/627416__victor_natas__fear-creeps-upon-you.wav")

var rooftop_music = preload("res://Musica/419802__sirkoto51__anime-encounter-loop-3.wav")
var training_music = preload("res://Musica/419802__sirkoto51__anime-encounter-loop-3.wav")


# CONTROL


var current_track_name := ""

var music_volume := 1.0
var sfx_volume := 1.0

func _ready():
	if music_volume <= 0:
		music_player.volume_db = -80
	else:
		music_player.volume_db = linear_to_db(music_volume)

	if sfx_volume <= 0:
		sfx_player.volume_db = -80
	else:
		sfx_player.volume_db = linear_to_db(sfx_volume)

func play_music(music: AudioStream, track_name := ""):
	if current_track_name == track_name and music_player.playing:
		return

	current_track_name = track_name

	if music_volume <= 0:
		music_player.volume_db = -80
	else:
		music_player.volume_db = linear_to_db(music_volume)

	music_player.stream = music
	music_player.play()

func stop_music():
	current_track_name = ""
	music_player.stop()

func play_sfx(sound: AudioStream):
	if sfx_volume <= 0:
		return

	sfx_player.volume_db = linear_to_db(sfx_volume)
	sfx_player.stream = sound
	sfx_player.play()


# VOLUMEN


func set_music_volume(value: float):
	music_volume = value

	if value <= 0:
		music_player.volume_db = -80
	else:
		music_player.volume_db = linear_to_db(value)

func set_sfx_volume(value: float):
	sfx_volume = value

	if value <= 0:
		sfx_player.volume_db = -80
	else:
		sfx_player.volume_db = linear_to_db(value)


# ACCESOS RAPIDOS


func play_menu_music():
	play_music(menu_music, "menu")

func play_level_select_music():
	play_music(level_select_music, "level_select")

func play_rooftop_music():
	play_music(rooftop_music, "rooftop")

func play_training_music():
	play_music(training_music, "training")
