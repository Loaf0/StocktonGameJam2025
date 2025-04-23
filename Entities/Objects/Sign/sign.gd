extends Node2D

@export var interact_text = "You can use C to sprint, X to jump and Z to attack!"
@export var prompt_text = "Press V to Read"
@export var typing_speed = 0.03

var player_in_range = false
var is_typing = false
var is_reading = false
var current_index = 0

@onready var typing_timer = $TypingTimer
@onready var text_box = $Label

func _ready() -> void:
	text_box.hide()
	typing_timer.wait_time = typing_speed
	typing_timer.timeout.connect(_on_typing_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range or is_reading:
		text_box.show()

		if !is_typing and !is_reading:
			text_box.text = prompt_text

		if Input.is_action_just_pressed("Interact"):
			if is_typing:
				skip_typing()
			elif !is_reading:
				start_typing()
			else:
				end_reading()
	else:
		text_box.hide()

func _on_interaction_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_interaction_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		if !is_reading:
			reset_typing()
			text_box.hide()

func start_typing():
	is_typing = true
	is_reading = true
	current_index = 0
	text_box.text = ""
	typing_timer.start()

func skip_typing():
	typing_timer.stop()
	text_box.text = interact_text
	is_typing = false
	is_reading = true

func _on_typing_timer_timeout():
	if current_index < interact_text.length():
		text_box.text += interact_text[current_index]
		current_index += 1
	else:
		typing_timer.stop()
		is_typing = false
		is_reading = true

func reset_typing():
	typing_timer.stop()
	is_typing = false
	is_reading = false
	current_index = 0
	text_box.text = ""

func end_reading():
	reset_typing()
	text_box.hide()
