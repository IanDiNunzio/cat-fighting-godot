extends Node2D

@export var shoe_scene : PackedScene

@onready var left_spawn = $LeftSpawn
@onready var right_spawn = $RightSpawn

var timer := 0.0
var increase_timer := 0.0

# Chance inicial
var current_chance := 10.0

func _process(delta):

	timer += delta
	increase_timer += delta

	# Cada 10 segundos aumenta la chance
	if increase_timer >= 10.0:

		increase_timer = 0

		current_chance += 10

		# Máximo 80%
		current_chance = min(current_chance, 80)

	# Cada 5 segundos chequea spawn
	if timer >= 5.0:

		timer = 0

		if randf_range(0,100) <= current_chance:

			spawn_shoe()

			# Reduce la chance a la mitad después de lanzar
			current_chance *= 0.5

func spawn_shoe():

	if shoe_scene == null:
		return

	var shoe = shoe_scene.instantiate()

	get_tree().current_scene.add_child(shoe)

	var from_left = randf() < 0.5

	if from_left:

		shoe.global_position = left_spawn.global_position

		shoe.launch(true)

	else:

		shoe.global_position = right_spawn.global_position

		shoe.launch(false)
