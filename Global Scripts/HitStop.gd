extends Node

func freeze_frame(time: float = .15):
	Engine.time_scale = 0
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1

func slow_frame(time: float = .15):
	Engine.time_scale = .5
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1
