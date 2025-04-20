extends CanvasLayer


@onready var health_bar = $Control/Healthbar
@onready var score_label = $Control/Score
@onready var death_anim = $Control/Death

func _ready() -> void:
	death_anim.visible = true
	death_anim.frame = 20
	death_anim.play_backwards()
	
	await death_anim.animation_finished
	
	death_anim.visible = false

func _physics_process(delta: float) -> void:
	score_label.text = "Score : " + str(Global.score)
	health_bar.frame = clamp(Global.health, 0, 3)
	
	if Global.health <= 0 and !death_anim.visible:
		death_anim.visible = true
		death_anim.frame = 0
		death_anim.play()
		
		await death_anim.animation_finished
		
		Global.health = 3
		get_tree().reload_current_scene()
