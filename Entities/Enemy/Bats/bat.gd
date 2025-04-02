extends CharacterBody2D

@export var flight_frequency = 0.05
@export var flight_magnatude = 100
@export var flight_speed = 30

@onready var death_emit = $DeathParticles
@onready var sprite = $Bat

var health = 1

func _physics_process(delta: float) -> void:
	velocity.y = sin(global_position.x * flight_frequency) * flight_magnatude
	velocity.x = flight_speed
	move_and_slide()
	pass

func take_damage(damage_taken : int):
	health = health - damage_taken
	if(health <= 0):
		death()

func death():
	velocity = Vector2(0,0)
	death_emit.restart()
	death_emit.emitting = true  
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 0.2)
	var death_timer = Timer.new()
	add_child(death_timer)
	death_timer.wait_time = 1.0
	death_timer.one_shot = true
	death_timer.connect("timeout", Callable(self, "queue_free"))
	death_timer.start()
