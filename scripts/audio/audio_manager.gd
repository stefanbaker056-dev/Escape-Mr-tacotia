extends Node

# Audio Manager - Handles all game audio and music

var background_music: AudioStreamPlayer
var current_stage: int = 0

func _ready():
	print("Audio Manager initialized")
	setup_background_music()

func setup_background_music():
	"""Set up background music player"""
	# Create audio player for background music
	background_music = AudioStreamPlayer.new()
	background_music.name = "BackgroundMusic"
	background_music.bus = &"Music"
	add_child(background_music)
	
	# Load and play gameplay music
	var music_path = "res://assets/sounds/music_gameplay.ogg"
	var music_stream = load(music_path)
	
	if music_stream:
		background_music.stream = music_stream
		background_music.volume_db = -5  # Slightly quieter so sound effects are heard
		background_music.bus = &"Master"
		background_music.play()
		print("Background music started")
	else:
		print("Warning: Background music not found at %s" % music_path)

func play_background_music(music_path: String):
	"""Play a specific background music track"""
	var music_stream = load(music_path)
	if music_stream:
		background_music.stream = music_stream
		background_music.play()
		print("Now playing: %s" % music_path)
	else:
		print("Failed to load music: %s" % music_path)

func stop_background_music():
	"""Stop background music"""
	if background_music:
		background_music.stop()

func set_music_volume(volume_db: float):
	"""Set background music volume (in dB)"""
	if background_music:
		background_music.volume_db = volume_db

func set_stage(stage_number: int):
	"""Called when stage changes - could change music based on stage"""
	current_stage = stage_number
	print("Audio Manager: Stage changed to %d" % stage_number)