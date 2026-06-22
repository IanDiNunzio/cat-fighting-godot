extends Node


# LEVEL SELECTOR

var selected_map := "rooftop"
var player_count := 2
var game_mode := "local"


# MAP SCENES

var map_scenes = {

	"rooftop": "res://Scenes/rooftop.tscn",
	"street": "res://Scenes/street.tscn",
	"park": "res://Scenes/park.tscn",
	"beach": "res://Scenes/beach.tscn"
}


# LOAD SELECTED MAP

func load_selected_map():

	if selected_map in map_scenes:

		get_tree().change_scene_to_file(
			map_scenes[selected_map]
		)

	else:

		print("Mapa no encontrado:", selected_map)
