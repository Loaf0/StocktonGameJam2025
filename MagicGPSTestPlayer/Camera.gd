extends Camera2D

@export var follow_target: CharacterBody2D

var following := false
@export var follow_range: float = 20.0
@export var follow_speed: float = 6.0
@export var follow_offset: Vector2 = Vector2(20, 0)
var target_location: Vector2

func _ready() -> void:
	if !follow_target:
		print("Trying to find player node")
		follow_target = find_player_node(get_tree().root)
	if !follow_target:
		print("ERROR: Camera is not targeted properly")
	else:
		print("Player Found")

func _process(delta: float) -> void:
	if !follow_target:
		follow_target = find_player_node(get_tree().root)
		return

	target_location = follow_target.global_position + follow_offset
	position = position.lerp(target_location, follow_speed * delta)

func find_player_node(node: Node) -> CharacterBody2D:
	if node is CharacterBody2D:
		return node
	for child in node.get_children():
		var result = find_player_node(child)
		if result:
			return result
	return null
