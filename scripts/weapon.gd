extends Area2D

@export var SPEED = 600
@export var RANGE = 600

@onready var sprite = get_node("Sprite2D")

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if get_global_mouse_position().x < global_position.x:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
