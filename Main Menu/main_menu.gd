extends Control

@onready var car = $StartScreen/Car
@onready var level_select = $LevelSelect

# Shaking parameters
@export var shake_intensity: float = 5.0
@export var shake_frequency: float = 0.05

var shake_timer: float = 0.0
var original_position

func _ready() -> void:
	original_position = car.position
	pass

func _process(delta: float) -> void:
	shake_timer += delta
	
	# Apply random shaking every frame based on the timer
	if shake_timer >= shake_frequency:
		var shake_x = randf_range(-shake_intensity, shake_intensity)
		var shake_y = randf_range(-shake_intensity, shake_intensity)
		car.position = original_position + Vector2(shake_x, shake_y)
		shake_timer = 0

func _on_start_pressed() -> void:
	#level_select.show()
	var level_scene = "res://Levels/TestLevel/level.tscn"
	get_tree().change_scene_to_file(level_scene)

func _on_options_pressed() -> void:
	#bring to options
	pass # Replace with function body.

func _on_exit_game_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

func _on_level_select_exit_pressed() -> void:
	level_select.show()

func _on_level_1_pressed() -> void:
	var level_scene = "res://Levels/TestLevel/level.tscn"
	get_tree().change_scene_to_file(level_scene)
