extends Node2D

@export var flight_frequency = 0.05
@export var flight_magnatude = 100
@export var flight_speed = 30
@export var spawn_frequency = 5.0

@onready var bat_spawn_timer = $Timer
@onready var spawn_range = $SpawnRange
@onready var bat_scene = preload("res://Entities/Enemy/Bats/Bat.tscn")

var in_range = false

func _ready() -> void:
	bat_spawn_timer.wait_time = spawn_frequency
	for body in spawn_range.get_overlapping_bodies():
		if body.is_in_group("player"):
			in_range = true

func spawn_bat():
	print("spawning bat")
	var currBat = bat_scene.instantiate()
	currBat.flight_frequency = flight_frequency
	currBat.flight_magnatude = flight_magnatude
	currBat.flight_speed = flight_speed
	add_child(currBat)

func _on_timer_timeout() -> void:
	if in_range:
		spawn_bat()

func _on_spawn_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		print("inrange")

func _on_spawn_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
		print("outrange")
		
