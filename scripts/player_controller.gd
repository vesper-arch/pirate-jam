extends CharacterBody2D

@export var SPEED = 250.0
@export var JUMP_VELOCITY = -450.0
@export var WEAPON_COOLDOWN = 1.0

signal shoot(bullet, direction, location)

@onready var Projectile = preload("res://scenes/projectile.tscn")
@onready var CDTimer = get_node("WeaponCooldown")
@onready var on_cooldown = false
	
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
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !on_cooldown:
			on_cooldown = true
			CDTimer.wait_time = WEAPON_COOLDOWN
			CDTimer.start()
			print("Weapon Cooldown Timer Started")
			shoot.emit(Projectile, rotation, position)

func _on_shoot(_bullet: Variant, direction: Variant, location: Variant) -> void:
	var spawned_projectile = Projectile.instantiate()
	var mouse_direction = get_local_mouse_position().angle()
	var Weapon_Shootpoint = get_node("Pistol/ShootPoint")
	owner.add_child(spawned_projectile)
	spawned_projectile.rotation = mouse_direction
	spawned_projectile.position = Weapon_Shootpoint.global_position
	spawned_projectile.velocity = spawned_projectile.velocity.rotated(mouse_direction)


func _on_weapon_cooldown_timeout() -> void:
	on_cooldown = false
