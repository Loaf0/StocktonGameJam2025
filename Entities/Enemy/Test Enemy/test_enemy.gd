extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 900.0
const JUMPSPEED = 500.0

@onready var right_floor_cast = $RightFloorCast
@onready var left_floor_cast = $LeftFloorCast
@onready var turn_timer = $TurnTimer
@onready var hitbox = $hitbox
@onready var sprite = $"Image2025-03-30164258789-removebg-preview"
@onready var detect = $"Dectection Box"

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
			if jumped == false:
				jumped = true
				target_direction = player.global_position - global_position
				velocity.x = target_direction.x*JUMPSPEED / 600
				velocity.y = -JUMPSPEED
				sprite.frame = 1
			elif is_on_floor():
				jumped = false
				current_state = states.MOVING
			
	
		 
	if health <= 0:
		death()
	
	for body in hitbox.get_overlapping_bodies():
		if body.has_method("take_damage") and body.is_in_group("player"):
			body.take_damage(1)
	move_and_slide()
	
	sprite.flip_h = true if direction == 1 else false

func take_damage(damage_taken : int):
	health = health - damage_taken

func death():
	queue_free()


func _on_dectection_box_area_entered(area: Area2D) -> void:
	current_state = states.JUMPING
	player = area
