extends Control

@onready var car = $Car

# Shaking parameters
@export var shake_intensity: float = 10.0  # How much the car shakes (can adjust for stronger/weaker shaking)
@export var shake_frequency: float = 0.05  # How frequent the shaking happens (lower value = faster shaking)

var shake_timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shake_timer += delta
	
	# Apply random shaking every frame based on the timer
	if shake_timer >= shake_frequency:
		var shake_x = randf_range(-shake_intensity, shake_intensity)
		var shake_y = randf_range(-shake_intensity, shake_intensity)
		car.position += Vector2(shake_x, shake_y)  # Apply the shake to the car position
		shake_timer = 0  # Reset the timer
