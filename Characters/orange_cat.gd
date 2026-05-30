extends CharacterBody2D

# =========================
# PLAYER
# =========================
@export var player_id := 1

# =========================
# DATOS PERSONAJE
# =========================
@export var character_name := "Player"

@export var portrait : Texture2D

# =========================
# MOVIMIENTO
# =========================
@export var speed := 250.0
@export var jump_force := -500.0
@export var gravity := 1200.0

# =========================
# DOBLE SALTO
# =========================
@export var max_jumps := 2

var jumps_left := max_jumps

# =========================
# VIDA Y STOCKS
# =========================
@export var max_hp := 100
@export var max_stocks := 3

var hp := max_hp
var stocks := max_stocks

# =========================
# KNOCKBACK
# =========================
@export var base_knockback := 350.0
@export var max_knockback := 1200.0
@export var knockback_vertical := -450.0

# 🔥 NUEVO (solo añadido, NO rompe nada)
@export var knockback_angle_y := -0.75

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

# =========================
# STUN
# =========================
var stunned := false

# Dirección
var facing_direction := 1

# =========================
# NODOS
# =========================
@onready var anim = $AnimatedSprite2D

@onready var player_number = $PlayerNumber

@onready var light_hitbox = $Hitboxes/LightAttack
@onready var heavy_hitbox = $Hitboxes/HeavyAttack

@onready var hit_light_sfx = $AudioHitLight
@onready var hit_heavy_sfx = $AudioHitHeavy

@onready var audio_hit_light = $AudioHitLight
@onready var audio_hit_heavy = $AudioHitHeavy


# =========================
# UI
# =========================
@onready var health_label = get_tree().current_scene.get_node(
	"UI/HUD/BottomUI/P" + str(player_id) + "Anchor/P" + str(player_id) + "_HUD/HealthLabel"
)

# =========================
# STOCK UI
# =========================
@onready var stock1 = get_tree().current_scene.get_node(
	"UI/HUD/BottomUI/P1Anchor/P1_HUD/StockContainer/Stock1"
)

@onready var stock2 = get_tree().current_scene.get_node(
	"UI/HUD/BottomUI/P1Anchor/P1_HUD/StockContainer/Stock2"
)

@onready var stock3 = get_tree().current_scene.get_node(
	"UI/HUD/BottomUI/P1Anchor/P1_HUD/StockContainer/Stock3"
)

# =========================
# READY
# =========================
func _ready():

	
	# Registrar jugador
	GameManager.register_player(self)

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

	# Actualizar UI
	update_health_ui()
	update_stock_ui()
	
	# Audio SFX
	audio_hit_light.bus = "SFX"
	audio_hit_heavy.bus = "SFX"

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
	else:
		jumps_left = max_jumps

	# =========================
	# DOBLE SALTO
	# =========================
	if Input.is_action_just_pressed("jump") and jumps_left > 0:

		velocity.y = jump_force
		jumps_left -= 1

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

	# =========================
	# MOVIMIENTO
	# =========================
	if !attacking and !stunned:
		velocity.x = direction * speed
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 30)

	move_and_slide()

	# =========================
	# ATAQUES
	# =========================
	if Input.is_action_just_pressed("light_attack") and !attacking:
		light_attack()

	if Input.is_action_just_pressed("heavy_attack") and !attacking:
		heavy_attack()

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

		if hit_light_sfx and MusicManager.sfx_volume > 0:
			hit_light_sfx.play()

		body.take_damage(light_damage, facing_direction)

func _on_heavy_attack_hit(body):

	if body == self:
		return

	if body.has_method("take_damage"):

		if hit_heavy_sfx and MusicManager.sfx_volume > 0:
			hit_heavy_sfx.play()

		body.take_damage(heavy_damage, facing_direction)

# =========================
# RECIBIR DAÑO (🔥 AQUÍ ESTÁ EL CAMBIO)
# =========================
func take_damage(amount, attack_direction):

	if !can_take_damage:
		return

	hp -= amount

	if hp < 0:
		hp = 0

	print(name, " HP: ", hp)

	# =========================
	# KNOCKBACK 45° REAL
	# =========================

	var missing_hp = max_hp - hp

	var knockback_strength = lerp(
		base_knockback,
		max_knockback,
		float(missing_hp) / float(max_hp)
	)

	var dir = sign(attack_direction)
	if dir == 0:
		dir = facing_direction

	# 🔥 45° real (esto es lo que faltaba)
	var knock_dir = Vector2(dir, knockback_angle_y).normalized()

	velocity = knock_dir * knockback_strength

	# =========================
	# STUN
	# =========================
	stunned = true

	update_health_ui()

	can_take_damage = false

	await get_tree().create_timer(0.25).timeout

	stunned = false

	await get_tree().create_timer(0.15).timeout

	can_take_damage = true

	# Morir
	if hp <= 0:
		die()

# =========================
# UI VIDA
# =========================
func update_health_ui():

	if health_label:
		health_label.text = str(hp) + " HP"

# =========================
# UI STOCKS
# =========================
func update_stock_ui():

	if stock1:
		stock1.visible = stocks >= 1

	if stock2:
		stock2.visible = stocks >= 2

	if stock3:
		stock3.visible = stocks >= 3

# =========================
# MORIR
# =========================
func die():

	if dead:
		return

	dead = true

	velocity = Vector2.ZERO

	stocks -= 1

	update_stock_ui()

	print(name, " perdió una vida")
	print("Stocks restantes: ", stocks)

	if stocks <= 0:

		print(name, " fue eliminado")

		GameManager.check_winner()
		queue_free()
		return

	await get_tree().create_timer(1.0).timeout
	respawn()

# =========================
# RESPAWN
# =========================
func respawn():

	global_position = respawn_position

	hp = max_hp

	jumps_left = max_jumps

	update_health_ui()

	velocity = Vector2.ZERO

	dead = false
	stunned = false

	can_take_damage = false

	await get_tree().create_timer(2.0).timeout

	can_take_damage = true
