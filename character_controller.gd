class_name Player extends CharacterBody2D

var isHandlingInput = true
var isAffectedByGravity = true

var MAX_FALL_SPEED: float = -200
var ACCELERATION: float = 25
var MAX_SPEED: float = 400
var GRAVITY: float = 700
var FRICTION: float = 16
var AIR_RESISTANCE: float = 7

var max_jumps := 1
var jumps := 1
var jump_buffer := false
var jump_buffer_time := 0.4
var JUMP_HEIGHT: float = -350
var JUMP_SENSITIVITY: float = 140
var jump_y_pos = 0

func getgravity(vel: Vector2):
	if vel.y < 0:
		return GRAVITY
	return GRAVITY * 1.6
# Source "Lerp smoothing is broken" - https://www.youtube.com/watch?v=LSNQuFEDOyQ&t=2977s
# decay is a value from 0 to 25 || slow to fast
func exp_decay(a, b, decay, dt):
	return b + (a - b) * exp(-decay * dt)

func motion_smoothing(dt: float) -> void:
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = min(0, velocity.y + (JUMP_SENSITIVITY + (position.y - jump_y_pos)))
	if !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		if is_on_floor():
			velocity.x = exp_decay(velocity.x, float(0), FRICTION, dt)
		else:
			velocity.x = exp_decay(velocity.x, float(0), AIR_RESISTANCE, dt)
			
func jump() -> void:
	velocity.y += JUMP_HEIGHT
	jump_y_pos = position.y
	jumps -= 1

func _physics_process(delta):
	velocity.y += getgravity(velocity) * delta
	if is_on_floor():
		jumps = max_jumps
	if isHandlingInput:
		if Input.is_action_just_pressed("jump"):
			if is_on_floor() or jump_buffer:
				jump()
			else:
				jump_buffer = true
				get_tree().create_timer(jump_buffer_time).timeout.connect(on_jump_buffer_timeout)
	
		if Input.is_action_pressed("left"):
			velocity.x = max(-MAX_SPEED, velocity.x - ACCELERATION / (int(!is_on_floor()) + 1))
		elif Input.is_action_pressed("right"):
			velocity.x = min(MAX_SPEED, velocity.x + ACCELERATION / (int(!is_on_floor()) + 1))
		
		motion_smoothing(delta)
		
		move_and_slide()
		
func on_jump_buffer_timeout() -> void:
	jump_buffer = false
