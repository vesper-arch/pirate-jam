extends CharacterBody2D

@export var SPEED = 250.0
@export var JUMP_VELOCITY = -450.0

@onready var root_node = get_tree().get_root().get_node("Root")
@onready var projectile = load("res://scenes/projectile.tscn")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot(get_global_mouse_position() + global_position)
	
func shoot(mouse_pos: Vector2):
	var instance = projectile.instantiate()
	var target_rotation = mouse_pos.angle()
	instance.direction = target_rotation
	instance.spawn_position = global_position
	instance.spawn_rotation = target_rotation
	root_node.add_child.call_deferred(instance)
