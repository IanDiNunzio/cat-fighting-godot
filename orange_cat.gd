extends CharacterBody2D

# =========================
# PLAYER
# =========================
@export var player_id := 1

# =========================
# MOVIMIENTO
# =========================
@export var speed := 250.0
@export var jump_force := -500.0
@export var gravity := 1200.0

# =========================
# VIDA Y STOCKS
# =========================
@export var max_hp := 100
@export var max_stocks := 3

var hp := max_hp
var stocks := max_stocks

# =========================
# RESPAWN
# =========================
@export var respawn_position := Vector2(500, 200)

# =========================
# ATAQUES
# =========================
@export var light_damage := 10
@export var heavy_damage := 25

var attacking := false
var can_take_damage := true
var dead := false

# Dirección
var facing_direction := 1

# =========================
# NODOS
# =========================
@onready var anim = $AnimatedSprite2D

@onready var player_number = $PlayerNumber

@onready var light_hitbox = $Hitboxes/LightAttack
@onready var heavy_hitbox = $Hitboxes/HeavyAttack

# =========================
# READY
# =========================
func _ready():

	# Texto P1
	player_number.text = "P" + str(player_id)

	# Color del texto
	match player_id:

		1:
			player_number.modulate = Color.RED

		2:
			player_number.modulate = Color.BLUE

		3:
			player_number.modulate = Color.YELLOW

		4:
			player_number.modulate = Color.GREEN

	# Spawn automático
	var spawn_point = get_tree().current_scene.get_node(
		"SpawnPoints/SpawnP" + str(player_id)
	)

	global_position = spawn_point.global_position

	respawn_position = spawn_point.global_position

	# Hitboxes apagadas
	light_hitbox.monitoring = false
	heavy_hitbox.monitoring = false

	# Señales
	light_hitbox.body_entered.connect(_on_light_attack_hit)
	heavy_hitbox.body_entered.connect(_on_heavy_attack_hit)

# =========================
# PHYSICS
# =========================
func _physics_process(delta):

	if dead:
		return

	# =========================
	# GRAVEDAD
	# =========================
	if !is_on_floor():
		velocity.y += gravity * delta

	# =========================
	# SALTO
	# =========================
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# =========================
	# MOVIMIENTO
	# =========================
	var direction := 0

	if Input.is_action_pressed("left"):
		direction = -1

	if Input.is_action_pressed("right"):
		direction = 1

	# Girar personaje
	if direction != 0:

		facing_direction = direction

		anim.flip_h = direction < 0

		$Hitboxes.scale.x = direction

	# Movimiento
	if !attacking:
		velocity.x = direction * speed
	else:
		velocity.x = 0

	# =========================
	# ATAQUES
	# =========================
	if Input.is_action_just_pressed("light_attack") and !attacking:
		light_attack()

	if Input.is_action_just_pressed("heavy_attack") and !attacking:
		heavy_attack()

	move_and_slide()

	update_animations(direction)

	# =========================
	# CAER DEL MAPA
	# =========================
	if global_position.y > 2000:
		die()

# =========================
# ANIMACIONES
# =========================
func update_animations(direction):

	if dead:
		return

	if attacking:
		return

	if !is_on_floor():

		anim.play("Jump")

	elif direction != 0:

		anim.play("Walking")

	else:

		anim.play("Idle")

# =========================
# ATAQUE LIGERO
# =========================
func light_attack():

	attacking = true

	anim.play("LightAttack")

	light_hitbox.monitoring = true

	await get_tree().create_timer(0.15).timeout

	light_hitbox.monitoring = false

	await get_tree().create_timer(0.15).timeout

	attacking = false

# =========================
# ATAQUE PESADO
# =========================
func heavy_attack():

	attacking = true

	anim.play("HeavyAttack")

	heavy_hitbox.monitoring = true

	await get_tree().create_timer(0.3).timeout

	heavy_hitbox.monitoring = false

	await get_tree().create_timer(0.25).timeout

	attacking = false

# =========================
# GOLPES
# =========================
func _on_light_attack_hit(body):

	if body == self:
		return

	if body.has_method("take_damage"):

		body.take_damage(light_damage)

func _on_heavy_attack_hit(body):

	if body == self:
		return

	if body.has_method("take_damage"):

		body.take_damage(heavy_damage)

# =========================
# RECIBIR DAÑO
# =========================
func take_damage(amount):

	if !can_take_damage:
		return

	hp -= amount

	print(name, " HP: ", hp)

	can_take_damage = false

	await get_tree().create_timer(0.4).timeout

	can_take_damage = true

	# Morir
	if hp <= 0:
		die()

# =========================
# MORIR
# =========================
func die():

	if dead:
		return

	dead = true

	velocity = Vector2.ZERO

	stocks -= 1

	print(name, " perdió una vida")
	print("Stocks restantes: ", stocks)

	# Sin vidas
	if stocks <= 0:

		print(name, " fue eliminado")

		queue_free()

		return

	# Espera antes de respawn
	await get_tree().create_timer(1.0).timeout

	respawn()

# =========================
# RESPAWN
# =========================
func respawn():

	global_position = respawn_position

	hp = max_hp

	velocity = Vector2.ZERO

	dead = false

	can_take_damage = false

	# Invulnerabilidad temporal
	await get_tree().create_timer(2.0).timeout

	can_take_damage = true
