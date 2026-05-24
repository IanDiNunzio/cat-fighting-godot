extends StaticBody2D

enum State{
	IDLE,
	WARNING,
	DAMAGE
}

@export var damage := 20
var current_state = State.IDLE

func _ready() -> void:
	change_state(State.IDLE)

func change_state(new_state):
	current_state = new_state
	match  current_state:
		State.IDLE:
			enter_idle()
		
		State.WARNING:
			enter_warning()
		
		State.DAMAGE:
			enter_damage()

func enter_idle():
	$"../Sprite2D".modulate = Color(1,1,1)
	$Timer.start(5)
	$ColorRect.visible = false

func enter_warning():
	$Timer.start(0.5)
	$ColorRect.visible = true
	await get_tree().create_timer(0.1).timeout
	$ColorRect.visible = false
	await get_tree().create_timer(0.1).timeout
	$ColorRect.visible = true
	await get_tree().create_timer(0.1).timeout
	$ColorRect.visible = false
	await get_tree().create_timer(0.1).timeout
	$ColorRect.visible = true

func enter_damage():
	$"../Sprite2D".modulate = Color(0.9,0.95,1)
	$ColorRect.visible = true
	$Timer.start(0.8)

func _on_timer_timeout() -> void:
	match current_state:
		State.IDLE:
			change_state(State.WARNING)
		State.WARNING:
			change_state(State.DAMAGE)
		State.DAMAGE:
			change_state(State.IDLE)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.take_damage(damage)
