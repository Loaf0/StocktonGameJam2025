extends CharacterBody2D

@export var walk_speed: float = 250.0
@export var run_speed: float = 400.0
@export var jump_force: float = 420.0
@export var min_jump_force: float = 250.0
@export var max_jump_hold_time: float = 0.2
@export var gravity: float = 900.0
@export var fast_fall_gravity: float = 1700.0
@export var wall_slide_speed: float = 90.0
@export var wall_jump_force: Vector2 = Vector2(320, -360)
@export var acceleration: float = 1500.0
@export var air_acceleration: float = 800.0
@export var friction: float = 1500.0
@export var air_friction: float = 250.0

@onready var left_cast = $PlayerCollider/LeftCast
@onready var right_cast = $PlayerCollider/RightCast
@onready var ground_hitbox = $G_Hitbox
@onready var air_hitbox = $A_Hitbox

var is_running: bool = false
var on_wall: bool = false
var can_wall_jump: bool = false

var jump_time: float = 0.0
var is_jumping: bool = false
var direction: int = 1  # 1 for right, -1 for left
var just_wall_jumped: bool = false

func _physics_process(delta):
	var direction_input = Input.get_axis("Left", "Right")
	is_running = Input.is_action_pressed("Run")
	var target_speed = (run_speed if is_running else walk_speed) * direction_input
	var current_acceleration = air_acceleration if not is_on_floor() else acceleration
	var current_friction = air_friction if not is_on_floor() else friction

	if direction_input:
		velocity.x = move_toward(velocity.x, target_speed, current_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, current_friction * delta)

	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += fast_fall_gravity * delta
		else:
			velocity.y += gravity * delta

	on_wall = player_on_wall() and not is_on_floor()

	if on_wall:
		if velocity.y > 0:
			velocity.y = move_toward(velocity.y, wall_slide_speed, gravity * delta)
		if Input.get_axis("Left", "Right") != 0:
			can_wall_jump = true
		else:
			can_wall_jump = false

	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = -jump_force
			is_jumping = true
			jump_time = 0.0
		elif on_wall and can_wall_jump:
			just_wall_jumped = true
			velocity = Vector2(-wall_jump_force.x * direction, wall_jump_force.y)
			can_wall_jump = false
			is_jumping = false

	if is_jumping:
		jump_time += delta
		if Input.is_action_pressed("Jump") and jump_time < max_jump_hold_time:
			velocity.y -= (jump_force - min_jump_force) * delta
		else:
			is_jumping = false

	if Input.is_action_pressed("Attack"):
		attack()

	if is_on_floor() and direction_input != 0:
		direction = 1 if direction_input > 0 else -1
		if air_hitbox.scale.x != direction:
			air_hitbox.scale.x = direction
			ground_hitbox.scale.x = direction
	
	if just_wall_jumped:
		air_hitbox.scale.x = -air_hitbox.scale.x
		ground_hitbox.scale.x = -ground_hitbox.scale.x
		just_wall_jumped = false
	
	move_and_slide()

func player_on_wall():
	return left_cast.is_colliding() or right_cast.is_colliding()

func attack():
	if is_on_floor():
		# Ground attack animation
		for body in ground_hitbox.get_overlapping_bodies():
			if body.has_method("take_damage"):
				body.take_damage(1)
		pass
	else:
		# Air attack animation
		for body in air_hitbox.get_overlapping_bodies():
			if body.has_method("take_damage"):
				body.take_damage(1)
		pass
