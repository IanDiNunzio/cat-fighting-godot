extends Node


@onready var image = $TextureRect

var time_passed := 0.0
var next_trigger := 60.0  

func _process(delta):
	time_passed += delta

	if time_passed >= next_trigger and time_passed <= 180:
		show_image()
		next_trigger += 60.0


func show_image():
	image.visible = true
	await get_tree().create_timer(3.0).timeout
	image.visible = false
