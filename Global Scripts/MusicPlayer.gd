extends AudioStreamPlayer

@onready var music = preload("res://Sounds/jazz piano but its triangle waves cause it sounds weird.wav")

func _ready() -> void:
	_play_music(music)

func _play_music(music: AudioStream):
	if stream == music:
		return
		
	stream = music
	
	play() 

func play_FX(stream: AudioStream):
	
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
