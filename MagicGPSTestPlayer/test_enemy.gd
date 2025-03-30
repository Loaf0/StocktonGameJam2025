extends CharacterBody2D

const SPEED = 300.0
const GRAVITY = 900.0

@onready var right_floor_cast = $RightFloorCast
@onready var left_floor_cast = $LeftFloorCast
@onready var turn_timer = $TurnTimer

var direction = 1
var health = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
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
		
	if health <= 0:
		death()
	
	move_and_slide()

func take_damage(damage_taken : int):
	health = health - damage_taken

func death():
	queue_free()
