extends RigidBody2D

@export var launch_force := 500.0
@export var damage := 15

# Tiempo quieto antes de desaparecer
@export var idle_time := 3.0

var still_timer := 0.0

func _ready():

	contact_monitor = true
	max_contacts_reported = 10

	body_entered.connect(_on_body_entered)

func launch(from_left := true):

	var angle = deg_to_rad(45)

	var direction : Vector2

	if from_left:

		direction = Vector2(
			cos(angle),
			-sin(angle)
		)

	else:

		direction = Vector2(
			-cos(angle),
			-sin(angle)
		)

	apply_impulse(direction * launch_force)

func _physics_process(delta):

	# Elimina el zapato si cae fuera del mapa
	if global_position.y > 1200:
		queue_free()

	# Detecta si casi no se mueve
	if linear_velocity.length() < 15:

		still_timer += delta

		# Desaparece después de estar quieto
		if still_timer >= idle_time:
			queue_free()

	else:

		# Se resetea si vuelve a moverse
		still_timer = 0.0

func _on_body_entered(body):

	if body.has_method("take_damage"):

		body.take_damage(damage)
