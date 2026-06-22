extends CharacterBody2D


# PLAYER

@export var player_id := 1


# DATOS PERSONAJE

@export var character_name := "Player"

@export var portrait : Texture2D


# MOVIMIENTO

@export var speed := 250.0
@export var jump_force := -500.0
@export var gravity := 1200.0


# DOBLE SALTO

@export var max_jumps := 2
var jumps_left := max_jumps


# VIDA Y STOCKS

@export var max_hp := 100
@export var max_stocks := 3

var hp := max_hp
var stocks := max_stocks

@export var confetti_scene: PackedScene
@onready var audio_death = $AudioDeath


# KNOCKBACK

@export var base_knockback := 350.0
@export var max_knockback := 1200.0
@export var knockback_vertical := -450.0
@export var knockback_angle_y := -0.75


# RESPAWN

@export var respawn_position := Vector2(500, 200)


# ATAQUES

@export var light_damage := 10
@export var heavy_damage := 25

var attacking := false
var can_take_damage := true
var dead := false
var stunned := false
var facing_direction := 1


# NODOS

@onready var anim = $AnimatedSprite2D
@onready var player_number = $PlayerNumber

@onready var light_hitbox = $Hitboxes/LightAttack
@onready var heavy_hitbox = $Hitboxes/HeavyAttack
@onready var special_hitbox = $Hitboxes/SpecialAttack

@onready var hit_light_sfx = $AudioHitLight
@onready var hit_heavy_sfx = $AudioHitHeavy
@onready var audio_hit_light = $AudioHitLight
@onready var audio_hit_heavy = $AudioHitHeavy
@onready var audio_special = $AudioSpecialAttack
@onready var audio_jump = $AudioJumping


var can_move := false
var blocking := false

@export var special_damage := 35
@export var special_dash_speed := 900.0
@export var special_dash_time := 0.25
@export var special_cooldown_time := 15.0
var special_cooldown := false
@export var block_reduction := 0.6


# UI

@onready var health_label = get_tree().current_scene.get_node(
	"UI/HUD/BottomUI/P" + str(player_id) + "Anchor/P" + str(player_id) + "_HUD/HealthLabel"
)

@onready var stock1 = get_tree().current_scene.get_node(
	"UI/HUD/BottomUI/P1Anchor/P1_HUD/StockContainer/Stock1"
)

@onready var stock2 = get_tree().current_scene.get_node(
	"UI/HUD/BottomUI/P1Anchor/P1_HUD/StockContainer/Stock2"
)

@onready var stock3 = get_tree().current_scene.get_node(
	"UI/HUD/BottomUI/P1Anchor/P1_HUD/StockContainer/Stock3"
)


# READY

func _ready():

	GameManager.register_player(self)

	player_number.text = "P" + str(player_id)

	match player_id:
		1: player_number.modulate = Color.RED
		2: player_number.modulate = Color.BLUE
		3: player_number.modulate = Color.YELLOW
		4: player_number.modulate = Color.GREEN

	var spawn_point = get_tree().current_scene.get_node(
		"SpawnPoints/SpawnP" + str(player_id)
	)

	global_position = spawn_point.global_position
	respawn_position = spawn_point.global_position

	light_hitbox.monitoring = false
	heavy_hitbox.monitoring = false
	special_hitbox.monitoring = false

	light_hitbox.body_entered.connect(_on_light_attack_hit)
	heavy_hitbox.body_entered.connect(_on_heavy_attack_hit)

	update_health_ui()
	update_stock_ui()

	audio_hit_light.bus = "SFX"
	audio_hit_heavy.bus = "SFX"


# PHYSICS

func _physics_process(delta):

	if dead:
		return

	# GRAVEDAD
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_left = max_jumps

	# BLOQUEO
	blocking = Input.is_action_pressed("block") and !attacking

	if blocking:
		anim.play("Block")

	# SALTO (CON AUDIO)
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = jump_force
		jumps_left -= 1

		if audio_jump and MusicManager.sfx_volume > 0:
			audio_jump.play()

	# MOVIMIENTO
	var direction := 0

	if can_move:
		if Input.is_action_pressed("left"):
			direction = -1
		if Input.is_action_pressed("right"):
			direction = 1

	if direction != 0:
		facing_direction = direction
		$AnimatedSprite2D.flip_h = direction < 0
		$Hitboxes.scale.x = direction

	# MOVIMIENTO FINAL
	if !attacking and !stunned:
		var final_speed = speed
		if blocking:
			final_speed *= 0.4
		velocity.x = direction * final_speed
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 30)

	move_and_slide()

	# ATAQUES
	if Input.is_action_just_pressed("light_attack") and !attacking and !blocking:
		light_attack()

	if Input.is_action_just_pressed("heavy_attack") and !attacking:
		heavy_attack()

	if Input.is_action_just_pressed("specialattack") and !attacking and !special_cooldown:
		special_attack()

	update_animations(direction)

	if global_position.y > 2000:
		die()


# ATAQUES

func light_attack():
	attacking = true
	anim.play("LightAttack")

	if hit_light_sfx and MusicManager.sfx_volume > 0:
		hit_light_sfx.play()

	light_hitbox.monitoring = true
	await get_tree().create_timer(0.15).timeout
	light_hitbox.monitoring = false

	await get_tree().create_timer(0.15).timeout
	attacking = false


func heavy_attack():
	attacking = true
	anim.play("HeavyAttack")

	if hit_heavy_sfx and MusicManager.sfx_volume > 0:
		hit_heavy_sfx.play()

	heavy_hitbox.monitoring = true
	await get_tree().create_timer(0.3).timeout
	heavy_hitbox.monitoring = false

	await get_tree().create_timer(0.25).timeout
	attacking = false


func special_attack():
	if special_cooldown:
		return

	attacking = true
	special_cooldown = true

	anim.play("SpecialAttack")

	if audio_special and MusicManager.sfx_volume > 0:
		audio_special.play()

	velocity.x = facing_direction * special_dash_speed

	special_hitbox.monitoring = true
	await get_tree().create_timer(special_dash_time).timeout
	special_hitbox.monitoring = false

	attacking = false

	await get_tree().create_timer(special_cooldown_time).timeout
	special_cooldown = false


# HIT

func _on_light_attack_hit(body):
	if body != self and body.has_method("take_damage"):
		body.take_damage(light_damage, facing_direction)

func _on_heavy_attack_hit(body):
	if body != self and body.has_method("take_damage"):
		body.take_damage(heavy_damage, facing_direction)


# DAMAGE

func take_damage(amount, attack_direction):

	if !can_take_damage:
		return

	# ✔ BLOQUEO PRIMERO (ESTO ES LO IMPORTANTE)
	if blocking:
		amount *= block_reduction
		velocity.x *= 0.3

	hp -= amount
	if hp < 0:
		hp = 0

	var missing_hp = max_hp - hp

	var knockback_strength = lerp(
		base_knockback,
		max_knockback,
		float(missing_hp) / float(max_hp)
	)

	var dir = sign(attack_direction)
	if dir == 0:
		dir = facing_direction

	var knock_dir = Vector2(dir, knockback_angle_y).normalized()
	velocity = knock_dir * knockback_strength

	stunned = true
	can_take_damage = false

	update_health_ui()

	await get_tree().create_timer(0.25).timeout
	stunned = false

	await get_tree().create_timer(0.15).timeout
	can_take_damage = true

	if hp <= 0:
		die()


# UI

func update_health_ui():
	if health_label:
		health_label.text = str(hp) + " HP"

func update_stock_ui():
	if stock1:
		stock1.visible = stocks >= 1
	if stock2:
		stock2.visible = stocks >= 2
	if stock3:
		stock3.visible = stocks >= 3


# DEATH

func die():
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO
	stocks -= 1

	update_stock_ui()

	
	#  CONFETI EN EL CENTRO
	
	if confetti_scene:
		var confetti = confetti_scene.instantiate()
		get_tree().current_scene.add_child(confetti)

		
		confetti.play_confetti()

	
	#  SONIDO MUERTE / CONFETI
	
	if audio_death and MusicManager.sfx_volume > 0:
		audio_death.play()

	update_stock_ui()

	
	#  CHECK GAME OVER
	
	if stocks <= 0:
		GameManager.check_winner()
		queue_free()
		return

	await get_tree().create_timer(1.0).timeout
	respawn()

func respawn():
	global_position = respawn_position
	hp = max_hp
	jumps_left = max_jumps

	velocity = Vector2.ZERO
	dead = false
	stunned = false
	attacking = false

	await get_tree().create_timer(2.0).timeout
	can_take_damage = true


# ANIM

func update_animations(direction):
	if dead or attacking:
		return

	if !is_on_floor():
		anim.play("Jump")
	elif direction != 0:
		anim.play("Walking")
	else:
		anim.play("Idle")
	if blocking:
		anim.play("Block")
		return
