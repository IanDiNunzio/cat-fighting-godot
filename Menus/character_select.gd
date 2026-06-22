extends Control


# AUDIO

@onready var sfx_player: AudioStreamPlayer = $Audio/SFXPlayer
@export var click_sound: AudioStream



# UI PREVIEW

@onready var preview_image = $PreviewPanel/CharacterImage
@onready var preview_name = $PreviewPanel/CharacterName

@onready var speed_label = $PreviewPanel/StatsContainer/Speed
@onready var attack_label = $PreviewPanel/StatsContainer/Attack
@onready var weight_label = $PreviewPanel/StatsContainer/Jump

@onready var ready_button = $HBoxContainer/ReadyButton
@onready var back_button = $HBoxContainer/BackButton



# PLAYER COUNT

@onready var btn_2_players = $PlayerCountContainer/Btn2Players
@onready var btn_3_players = $PlayerCountContainer/Btn3Players
@onready var btn_4_players = $PlayerCountContainer/Btn4Players

@onready var player_buttons = [btn_2_players, btn_3_players, btn_4_players]



# CHARACTERS

var characters = {
	"Black Cat": {"texture": preload("res://Imagenes/retrato4.png"), "speed": "★★★★☆", "attack": "★★★☆☆", "weight": "★★☆☆☆"},
	"Orange Cat": {"texture": preload("res://Imagenes/retrato3.png"), "speed": "★★★☆☆", "attack": "★★★★☆", "weight": "★★★☆☆"},
	"White Cat": {"texture": preload("res://Imagenes/retrato2cambiar.png"), "speed": "★★★★★", "attack": "★★☆☆☆", "weight": "★☆☆☆☆"},
	"Gray Cat": {"texture": preload("res://Imagenes/retrato1.png"), "speed": "★★☆☆☆", "attack": "★★★★★", "weight": "★★★★☆"}
}



# GAME STATE

var selected_players := 2
var player_selections := {}  
var character_taken := {}     



# READY

func _ready():

	for b in player_buttons:
		b.toggle_mode = true

	select_player_button(btn_2_players, 2)

	ready_button.pressed.connect(on_ready_pressed)
	back_button.pressed.connect(on_back_pressed)



# CLICK SOUND

func play_click():
	if click_sound:
		sfx_player.stream = click_sound
		sfx_player.play()



# CORE FIXED SELECTOR

func select_character(character_name: String):

	play_click()

	#  ya está tomado
	if character_taken.has(character_name):
		return

	#  ya no hay slots
	if player_selections.size() >= selected_players:
		return

	#  PLAYER = ORDEN REAL DE CLICK
	var player_id = player_selections.size() + 1

	player_selections[player_id] = character_name
	character_taken[character_name] = true

	var data = characters[character_name]

	preview_image.texture = data["texture"]
	preview_name.text = character_name

	speed_label.text = "Speed: " + data["speed"]
	attack_label.text = "Attack: " + data["attack"]
	weight_label.text = "Weight: " + data["weight"]



# PLAYER COUNT

func select_player_button(active_button, amount):

	play_click()

	selected_players = amount

	player_selections.clear()
	character_taken.clear()

	for b in player_buttons:
		b.button_pressed = false

	active_button.button_pressed = true


func _on_btn_2_players_pressed(): select_player_button(btn_2_players, 2)
func _on_btn_3_players_pressed(): select_player_button(btn_3_players, 3)
func _on_btn_4_players_pressed(): select_player_button(btn_4_players, 4)



# Botones (IMPORTANT FIX)

func _on_texture_button_pressed():
	select_character("Black Cat")

func _on_texture_button_2_pressed():
	select_character("Orange Cat")

func _on_texture_button_3_pressed():
	select_character("White Cat")

func _on_texture_button_4_pressed():
	select_character("Gray Cat")



# READY / BACK

func on_ready_pressed():

	play_click()

	if player_selections.size() < selected_players:
		return

	Global.player_count = selected_players
	Global.player_characters = player_selections

	get_tree().change_scene_to_file("res://Scenes/testlevel.tscn")


func on_back_pressed():

	play_click()
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
