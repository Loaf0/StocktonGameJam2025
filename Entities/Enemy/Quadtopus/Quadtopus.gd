extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 900.0
const JUMP_SPEED = 500.0
const JUMP_HEIGHT = 150.0

@onready var right_floor_cast = $RightFloorCast
@onready var left_floor_cast = $LeftFloorCast
@onready var turn_timer = $TurnTimer
@onready var jump_timer = $JumpTimer
@onready var hitbox = $hitbox
@onready var sprite = $Quadtopus
@onready var detect = $"Detection Box"
@onready var death_emit = $DeathParticles

enum states {
	MOVING,
	JUMPING,
	IDLE
}

var current_state = states.MOVING

var direction = 1
var health = 1

var jumped = false
var player = null
var target_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if health <= 0:
		death()
		return
	
	match current_state:
		states.MOVING:
			sprite.frame = 0
			velocity.x = direction * SPEED
			if turn_timer.is_stopped():
				if direction == 1 and not right_floor_cast.is_colliding(): 
					direction = -1  
					turn_timer.start()
				elif direction == -1 and not left_floor_cast.is_colliding():
					direction = 1 
					turn_timer.start()
				elif is_on_wall():
					direction = -direction
					turn_timer.start()
					
		states.JUMPING:
			if not jumped:
				jumped = true
				target_direction = player.global_position - global_position
				direction = 1 if target_direction.x > 0 else -1  
				sprite.flip_h = direction == 1  

				var target_x = player.global_position.x
				var time_to_land = 2 * sqrt(2 * GRAVITY * JUMP_HEIGHT) / GRAVITY
				velocity.x = (target_x - global_position.x) / time_to_land
				velocity.y = -sqrt(2 * GRAVITY * JUMP_HEIGHT)

				sprite.frame = 1
			elif is_on_floor():
				jumped = false
				current_state = states.MOVING
	
	for body in hitbox.get_overlapping_bodies():
		if body.has_method("take_damage") and body.is_in_group("player"):
			body.take_damage(1)
	move_and_slide()
	
	sprite.flip_h = true if direction == 1 else false

func take_damage(damage_taken : int):
	health = health - damage_taken

func death():
	current_state = states.IDLE
	death_emit.emitting = true  
	sprite.rotation += 0.1 * direction
	var death_timer = Timer.new()
	add_child(death_timer)
	death_timer.wait_time = 1.5  
	death_timer.one_shot = true
	death_timer.connect("timeout", Callable(self, "queue_free"))
	death_timer.start()

func _on_jump_timer_timeout() -> void:
	if player and detect.has_overlapping_bodies():
		current_state = states.JUMPING
	jump_timer.start(randf_range(1.0, 4.0))

func _on_detection_box_body_entered(body: Node2D) -> void:
	current_state = states.JUMPING
	player = body
