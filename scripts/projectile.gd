extends Area2D

@export var speed = 600
var velocity = Vector2.RIGHT

func _physics_process(delta):
	position += speed * velocity * delta

func _on_body_entered(body: Node2D) -> void:
	queue_free()
