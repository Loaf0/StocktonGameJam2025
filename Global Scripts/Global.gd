extends Node

var score = 0
var health = 3

var volume = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
