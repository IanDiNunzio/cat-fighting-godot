extends Control


@onready var preview_image = $PreviewPanel/CharacterImage
@onready var preview_name = $PreviewPanel/CharacterName

@onready var speed_label = $PreviewPanel/StatsContainer/Speed
@onready var attack_label = $PreviewPanel/StatsContainer/Attack
@onready var weight_label = $PreviewPanel/StatsContainer/Jump

@onready var ready_button = $HBoxContainer/ReadyButton
@onready var back_button = $HBoxContainer/BackButton

@onready var sfx_player = $Audio/SFXPlayer


# =========================
# BOTONES PLAYER COUNT
# =========================

@onready var btn_2_players = $PlayerCountContainer/Btn2Players
@onready var btn_3_players = $PlayerCountContainer/Btn3Players
@onready var btn_4_players = $PlayerCountContainer/Btn4Players

@onready var player_buttons = [
	btn_2_players,
	btn_3_players,
	btn_4_players
]


# =========================
# TEXTURE BUTTONS
# =========================

@onready var texture_button_1 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton
@onready var texture_button_2 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton2
@onready var texture_button_3 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton3
@onready var texture_button_4 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton4


# =========================
# ICONOS PLAYER
# =========================

@onready var p1_icon = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton/P1Icon
@onready var p2_icon = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton/P2Icon
@onready var p3_icon = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton/P3Icon
@onready var p4_icon = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton/P4Icon

@onready var p1_icon2 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton2/P1Icon
@onready var p2_icon2 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton2/P2Icon
@onready var p3_icon2 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton2/P3Icon
@onready var p4_icon2 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton2/P4Icon

@onready var p1_icon3 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton3/P1Icon
@onready var p2_icon3 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton3/P2Icon
@onready var p3_icon3 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton3/P3Icon
@onready var p4_icon3 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton3/P4Icon

@onready var p1_icon4 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton4/P1Icon
@onready var p2_icon4 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton4/P2Icon
@onready var p3_icon4 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton4/P3Icon
@onready var p4_icon4 = $MarginContainer/VBoxContainer/CenterContainer/GridContainer/TextureButton4/P4Icon


# =========================
# SONIDOS
# =========================

@export var click_sound : AudioStream


# =========================
# PERSONAJES
# =========================

var characters = {
	"Black Cat": {
		"texture": preload("res://Imagenes/retrato4.png"),
		"speed": "★★★★☆",
		"attack": "★★★☆☆",
		"weight": "★★☆☆☆"
	},

	"Orange Cat": {
		"texture": preload("res://Imagenes/retrato3.png"),
		"speed": "★★★☆☆",
		"attack": "★★★★☆",
		"weight": "★★★☆☆"
	},

	"White Cat": {
		"texture": preload("res://Imagenes/retrato2cambiar.png"),
		"speed": "★★★★★",
		"attack": "★★☆☆☆",
		"weight": "★☆☆☆☆"
	},

	"Gray Cat": {
		"texture": preload("res://Imagenes/retrato1.png"),
		"speed": "★★☆☆☆",
		"attack": "★★★★★",
		"weight": "★★★★☆"
	}
}


var selected_character = ""
var selected_players := 2

var current_player := 1

var player_selections = {}


func _ready():

	hide_all_icons()

	# =========================
	# PLAYER COUNT BUTTONS
	# =========================

	for button in player_buttons:
		button.toggle_mode = true

	select_player_button(btn_2_players, 2)


	# =========================
	# READY / BACK
	# =========================

	ready_button.pressed.connect(on_ready_pressed)
	back_button.pressed.connect(on_back_pressed)


	# =========================
	# TEXTURE BUTTONS
	# =========================

	


func select_character(character_name, button_id):

	play_click()

	if current_player > selected_players:
		return

	player_selections[current_player] = character_name

	selected_character = character_name

	var data = characters[character_name]

	preview_image.texture = data["texture"]
	preview_name.text = character_name

	speed_label.text = "Speed: " + data["speed"]
	attack_label.text = "Attack: " + data["attack"]
	weight_label.text = "Weight: " + data["weight"]

	show_player_icon(button_id, current_player)

	current_player += 1


func show_player_icon(button_id, player_id):

	match button_id:

		1:
			if player_id == 1:
				p1_icon.show()
			elif player_id == 2:
				p2_icon.show()
			elif player_id == 3:
				p3_icon.show()
			elif player_id == 4:
				p4_icon.show()

		2:
			if player_id == 1:
				p1_icon2.show()
			elif player_id == 2:
				p2_icon2.show()
			elif player_id == 3:
				p3_icon2.show()
			elif player_id == 4:
				p4_icon2.show()

		3:
			if player_id == 1:
				p1_icon3.show()
			elif player_id == 2:
				p2_icon3.show()
			elif player_id == 3:
				p3_icon3.show()
			elif player_id == 4:
				p4_icon3.show()

		4:
			if player_id == 1:
				p1_icon4.show()
			elif player_id == 2:
				p2_icon4.show()
			elif player_id == 3:
				p3_icon4.show()
			elif player_id == 4:
				p4_icon4.show()


func hide_all_icons():

	for icon in [
		p1_icon,p2_icon,p3_icon,p4_icon,
		p1_icon2,p2_icon2,p3_icon2,p4_icon2,
		p1_icon3,p2_icon3,p3_icon3,p4_icon3,
		p1_icon4,p2_icon4,p3_icon4,p4_icon4
	]:
		icon.hide()


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


func play_click():

	if click_sound:
		sfx_player.stream = click_sound
		sfx_player.play()


# =========================
# PLAYER COUNT
# =========================

func select_player_button(active_button, amount):

	play_click()

	selected_players = amount

	current_player = 1
	player_selections.clear()

	hide_all_icons()

	for button in player_buttons:
		button.button_pressed = false

	active_button.button_pressed = true


func _on_btn_2_players_pressed() -> void:

	select_player_button(btn_2_players, 2)


func _on_btn_3_players_pressed() -> void:

	select_player_button(btn_3_players, 3)


func _on_btn_4_players_pressed() -> void:

	select_player_button(btn_4_players, 4)


func _on_back_button_pressed() -> void:

	on_back_pressed()


func _on_ready_button_pressed() -> void:

	on_ready_pressed()


# =========================
# TEXTURE BUTTONS
# =========================

func _on_texture_button_pressed() -> void:

	select_character("Black Cat", 1)


func _on_texture_button_2_pressed() -> void:

	select_character("Orange Cat", 2)


func _on_texture_button_3_pressed() -> void:

	select_character("White Cat", 3)


func _on_texture_button_4_pressed() -> void:

	select_character("Gray Cat", 4)
