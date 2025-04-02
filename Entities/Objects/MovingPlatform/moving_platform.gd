extends Node2D

@export var speed: float = 100.0
@export var wait_time: float = 1.0
@export var x_distance: float = 0.0
@export var y_distance: float = 0.0

var moving_to_end: bool = true
var waiting: bool = false

@onready var platform: AnimatableBody2D = $Platform
@onready var start_position: Vector2 = platform.position
@onready var end_position: Vector2 = start_position + Vector2(x_distance, y_distance)

func _process(delta):
	if waiting:
		return

	var target_position = end_position if moving_to_end else start_position
	var direction = (target_position - platform.position).normalized()
	var movement = direction * speed * delta

	if movement.length() >= platform.position.distance_to(target_position):
		platform.position = target_position
		moving_to_end = !moving_to_end
		waiting = true
		await get_tree().create_timer(wait_time).timeout
		waiting = false
	else:
		platform.position += movement
