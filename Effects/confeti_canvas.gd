extends CanvasLayer

@onready var sprite = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer

func play_confetti():

	sprite.position = get_viewport().get_visible_rect().size / 2

	sprite.stop()
	sprite.frame = 0

	sprite.play("confetti")

	await get_tree().create_timer(0.5).timeout
	audio.play()

	await sprite.animation_finished

	queue_free()
