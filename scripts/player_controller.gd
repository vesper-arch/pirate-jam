extends CharacterBody2D

@export var SPEED = 250.0
@export var JUMP_VELOCITY = -450.0

signal shoot(bullet, direction, location)

@onready var Projectile = preload("res://scenes/projectile.tscn")

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
			shoot.emit(Projectile, rotation, position)

func _on_shoot(bullet: Variant, direction: Variant, location: Variant) -> void:
	var spawned_projectile = Projectile.instantiate()
	owner.add_child(spawned_projectile)
	spawned_projectile.rotation = direction
	spawned_projectile.position = location
	spawned_projectile.velocity = spawned_projectile.velocity.rotated(get_global_mouse_position().angle())
