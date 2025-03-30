extends Area2D

@export var follow_target: CharacterBody2D
@export var max_speed = 200
@export var min_speed = 150
@export var max_distance = 500

func _ready() -> void:
	if !follow_target:
		print("Trying to find player node")
		follow_target = find_player_node(get_tree().root)

func _process(delta: float) -> void:
	if not follow_target:
		return
	
	var distance = global_position.distance_to(follow_target.global_position)
	var speed_factor = clamp(distance / max_distance, 0.0, 1.0) 
	var speed = lerp(min_speed, max_speed, speed_factor)
	
	global_position.x += 1 * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(100)

func find_player_node(node: Node) -> CharacterBody2D:
	if node is CharacterBody2D:
		return node
	for child in node.get_children():
		var result = find_player_node(child)
		if result:
			return result
	return null
