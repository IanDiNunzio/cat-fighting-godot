extends CanvasLayer

# =========================
# ANCHORS
# =========================
@onready var p1_anchor = $HUD/BottomUI/P1Anchor
@onready var p2_anchor = $HUD/BottomUI/P2Anchor
@onready var p3_anchor = $HUD/BottomUI/P3Anchor
@onready var p4_anchor = $HUD/BottomUI/P4Anchor

# =========================
# JUGADORES
# =========================
@export var player_count := 2

# =========================
# READY
# =========================
func _ready():

	update_player_columns()

# =========================
# COLUMNAS
# =========================
func update_player_columns():

	p1_anchor.visible = player_count >= 1
	p2_anchor.visible = player_count >= 2
	p3_anchor.visible = player_count >= 3
	p4_anchor.visible = player_count >= 4
