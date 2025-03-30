extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var leg_sprite = $Legs
@onready var body_sprite = $Body

@onready var leg_anim = $LegsAnimPlayer
@onready var body_anim = $BodyAnimPlayer

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var move_direction := Input.get_axis("Left", "Right")
	if move_direction != 0:
		velocity.x = move_direction * SPEED
		leg_anim.play("Walk")
		spriteFlip(move_direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		leg_anim.play("Idle")
	
	var look_direction := Input.get_axis("Down", "Up")
	if look_direction:
		if look_direction == 1:
			body_anim.play("LookUp")
		elif look_direction == -1:
			body_anim.play("LookDown")
	else:
		body_anim.play("LookNeutral")

	move_and_slide()

func spriteFlip(flip_sprite : bool):
	leg_sprite.flip_h = flip_sprite
	body_sprite.flip_h = flip_sprite
