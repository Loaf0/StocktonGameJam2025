extends Node2D


@onready var collect_sound = preload("res://Sounds/powerUp.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		MusicPlayer.play_FX(collect_sound)
		body.health = body.health + 1 if body.health < 3 else body.health
		Global.score += 100
		queue_free()
