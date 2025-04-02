extends Node2D

@export var flight_frequency = 0.05
@export var flight_magnatude = 100
@export var flight_speed = 30

@onready var spawn_range = $SpawnRange
@onready var bat_scene = preload("res://Entities/Enemy/Bats/Bat.tscn")

var in_range = false

func _ready() -> void:
	for body in spawn_range.get_overlapping_bodies():
		if body.is_in_group("player"):
			in_range = true

func spawn_bat():
	print("spawning bat")
	var currBat = bat_scene.instantiate()
	currBat.flight_frequency = flight_frequency
	currBat.flight_magnatude = flight_magnatude
	currBat.flight_speed = flight_speed

func _on_timer_timeout() -> void:
	spawn_bat()

func _on_spawn_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true

func _on_spawn_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
