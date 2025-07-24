extends Area2D

@onready var weapon = get_node("../Player/Pistol")
@onready var weapon_speed = weapon.SPEED
@onready var weapon_range = weapon.RANGE

var velocity = Vector2.RIGHT
@onready var player = get_node("../Player")
@onready var player_position = player.position

func _physics_process(delta):
	position += weapon_speed * velocity * delta
	if position.distance_to(player_position) > weapon_range:
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
