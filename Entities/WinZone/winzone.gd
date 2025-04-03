extends Area2D

@export var level_select_scene: String = "res://Main Menu/MainMenu.tscn"

@onready var car_sprite = $Car
@onready var anim = $AnimationPlayer
@onready var smoke_emitter = $Car/Smoke

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.queue_free()
		print("Player entered WinZone")
		anim.play("win")
		smoke_emitter.emitting = true  
		await anim.animation_finished
		#fade to black maybe?
		get_tree().change_scene_to_file(level_select_scene)
