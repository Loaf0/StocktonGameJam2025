extends CanvasLayer


@onready var health_bar = $Control/Healthbar
@onready var score_label = $Control/Score

func _physics_process(delta: float) -> void:
	score_label.text = "Score : " + str(Global.score)
	health_bar.frame = clamp(Global.health, 0, 3)
	
	pass
