extends CharacterBody2D

@export var walk_speed: float = 180.0
@export var run_speed: float = 280.0
@export var jump_force: float = 420.0
@export var min_jump_force: float = 250.0
@export var max_jump_hold_time: float = 0.2
@export var gravity: float = 900.0
@export var fast_fall_gravity: float = 1700.0
@export var wall_slide_speed: float = 5.0
@export var wall_slide_mod: float = 40.0
@export var wall_jump_force: Vector2 = Vector2(320, -360)
@export var acceleration: float = 1500.0
@export var air_acceleration: float = 750.0
@export var friction: float = 1200.0
@export var air_friction: float = 300.0

@onready var left_cast = $PlayerCollider/LeftCast
@onready var right_cast = $PlayerCollider/RightCast
@onready var ground_hitbox = $G_Hitbox
@onready var air_hitbox = $A_Hitbox
@onready var sprite = $Sprite
@onready var invul_timer = $InvulTimer
@onready var wall_slide_timer = $WallSlideTimer
@onready var anim = $AnimationPlayer

var is_running: bool = false
var on_wall: bool = false
var can_wall_jump: bool = false
var wall_sliding = false
var jump_time: float = 0.0
var is_jumping: bool = false
var direction: int = 1  # 1 for right, -1 for left
var just_wall_jumped: bool = false
var attacking = false

var health = 3

func _physics_process(delta):
	var direction_input = Input.get_axis("Left", "Right")
	is_running = Input.is_action_pressed("Run")
	var target_speed = (run_speed if is_running else walk_speed) * direction_input
	var current_acceleration = air_acceleration if not is_on_floor() else acceleration
	var current_friction = air_friction if not is_on_floor() else friction
	Global.health = health
	
	if attacking:
		direction_input = 0
		#velocity.x = move_toward(velocity.x, 0, current_friction * delta)


	if direction_input:
		anim.play("running")
		velocity.x = move_toward(velocity.x, target_speed, current_acceleration * delta)
	else:
		if !attacking:
			anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, current_friction * delta)

	if not is_on_floor():
		anim.play("Jump")
		if velocity.y > 0:
			velocity.y += fast_fall_gravity * delta
		else:
			velocity.y += gravity * delta
	
	on_wall = player_on_wall() and not is_on_floor()

	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = -jump_force
			is_jumping = true
			jump_time = 0.0
		elif on_wall:
			just_wall_jumped = true
			if left_cast.is_colliding():
				velocity = Vector2(wall_jump_force.x, wall_jump_force.y)
			else:
				velocity = Vector2(-wall_jump_force.x, wall_jump_force.y)
			is_jumping = false

	if on_wall and not just_wall_jumped:
		if velocity.y > 50:
			if (left_cast.is_colliding() and direction_input < 0) or (right_cast.is_colliding() and direction_input > 0):
				if not wall_sliding:  
					wall_slide_timer.start()
					wall_sliding = true
				var time_ratio = (wall_slide_timer.wait_time - wall_slide_timer.time_left) / wall_slide_timer.wait_time
				velocity.y = lerp(wall_slide_speed, wall_slide_speed * wall_slide_mod, time_ratio)
				velocity.y = clamp(velocity.y, wall_slide_speed, wall_slide_speed* wall_slide_mod)

				var side = 1 if left_cast.is_colliding() else -1
				adjust_direction(side)
	else:
		if wall_sliding:
			wall_sliding = false
			wall_slide_timer.stop()

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
		if direction > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

	
	if just_wall_jumped:
		if left_cast.is_colliding() and sprite.flip_h:
			sprite.flip_h = false
			air_hitbox.scale.x = 1
			ground_hitbox.scale.x = 1
		elif right_cast.is_colliding() and !sprite.flip_h:
			sprite.flip_h = true
			air_hitbox.scale.x = -1
			ground_hitbox.scale.x = -1
		just_wall_jumped = false
	
	if !invul_timer.is_stopped():
		sprite.modulate = Color(1, 1, 1, .5)
	else:
		sprite.modulate = Color(1, 1, 1, 1)
	
	move_and_slide()


func player_on_wall():
	return left_cast.is_colliding() or right_cast.is_colliding()

func attack():
	if is_on_floor():
		attacking = true
		# Ground attack animation
		anim.play("swing")
	else:
		# Air attack animation
		attack_air()
		

func attack_ground():
	for body in ground_hitbox.get_overlapping_bodies():
		if body.has_method("take_damage") and !body.is_in_group("player"):
			HitStop.freeze_frame(.1)
			body.take_damage(1)
	pass

func attack_air():
	for body in air_hitbox.get_overlapping_bodies():
		if body.has_method("take_damage") and !body.is_in_group("player"):
			HitStop.freeze_frame(.1)
			body.take_damage(1)
	pass

func take_damage(damage_taken : int):
	if invul_timer.is_stopped():
		print(health)
		health = health - damage_taken
		invul_timer.start()
		print(health)

func get_health():
	return health

func adjust_direction(direction):
	air_hitbox.scale.x = direction
	ground_hitbox.scale.x = direction
	if direction > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swing":
		attacking = false
