extends CharacterBody2D

@export var speed := 250.0
@export var jump_force := -500.0
@export var gravity := 1200.0

@export var max_hp := 100

var hp := max_hp
var damage_percent := 0

var attacking := false
var facing_direction := 1

func _ready():

	$Hitboxes/LightAttack.monitoring = false
	$Hitboxes/HeavyAttack.monitoring = false


func _physics_process(delta):

	# gravedad
	if !is_on_floor():
		velocity.y += gravity * delta

	# movimiento
	var dir = Input.get_axis("left", "right")

	velocity.x = dir * speed

	# direccion
	if dir != 0:
		facing_direction = sign(dir)
		$Sprite2D.scale.x = facing_direction

	# salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# ataques
	if Input.is_action_just_pressed("light_attack"):
		light_attack()

	if Input.is_action_just_pressed("heavy_attack"):
		heavy_attack()

	move_and_slide()


func light_attack():

	if attacking:
		return

	attacking = true

	$AnimationPlayer.play("light_attack")

	$Hitboxes/LightAttack.monitoring = true

	await get_tree().create_timer(0.15).timeout

	$Hitboxes/LightAttack.monitoring = false

	await get_tree().create_timer(0.2).timeout

	attacking = false


func heavy_attack():

	if attacking:
		return

	attacking = true

	$AnimationPlayer.play("heavy_attack")

	await get_tree().create_timer(0.25).timeout

	$Hitboxes/HeavyAttack.monitoring = true

	await get_tree().create_timer(0.15).timeout

	$Hitboxes/HeavyAttack.monitoring = false

	await get_tree().create_timer(0.4).timeout

	attacking = false


func take_damage(amount, knockback):

	damage_percent += amount

	velocity += knockback

	print("Daño:", damage_percent)


func _on_light_attack_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_heavy_attack_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
