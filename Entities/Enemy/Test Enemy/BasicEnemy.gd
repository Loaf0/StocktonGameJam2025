extends CharacterBody2D

const SPEED = 70.0
const GRAVITY = 900.0

@onready var right_floor_cast = $RightFloorCast
@onready var left_floor_cast = $LeftFloorCast
@onready var turn_timer = $TurnTimer
@onready var hitbox = $hitbox
@onready var sprite = $Quadtopus
@onready var death_emit = $DeathParticles

enum states {
	MOVING,
	IDLE,
	DEATH
}

var current_state = states.MOVING

var direction = 1
var health = 1
var dying = false

var player = null

func _physics_process(delta: float) -> void:
	if not is_on_floor() and current_state != states.DEATH:
		velocity.y += GRAVITY * delta
	
	if health <= 0:
		current_state = states.DEATH
	
	match current_state:
		states.DEATH:
			sprite.frame = 0
			if !dying:
				death()
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
	
	if current_state != states.DEATH:
		for body in hitbox.get_overlapping_bodies():
			if body.has_method("take_damage") and body.is_in_group("player"):
				body.take_damage(1)
	move_and_slide()
	
	sprite.flip_h = true if direction == 1 else false

func take_damage(damage_taken : int):
	health = health - damage_taken

func death():
	dying = true
	velocity = Vector2(0,0)
	# hopefully please just show death particles
	death_emit.restart()
	death_emit.emitting = true  
	# fade out enemy
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 0.2)
	# despawn enemy
	var death_timer = Timer.new()
	add_child(death_timer)
	death_timer.wait_time = 1.0
	death_timer.one_shot = true
	death_timer.connect("timeout", Callable(self, "queue_free"))
	death_timer.start()
