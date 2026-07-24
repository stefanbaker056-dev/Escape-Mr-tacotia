extends Node

# Game Manager - Controls overall game flow and stage progression

var current_stage: int = 0
var total_stages: int = 25
var player: CharacterBody3D
var is_game_active: bool = false
var current_stage_scene: Node3D

# Restaurant areas
var dining_area: Node3D
var kitchen: Node3D
var storage_pantry: Node3D
var exterior: Node3D
var back_exit: Node3D

func _ready():
	print("Game Manager initialized")
	is_game_active = true
	start_game()
	
func start_game():
	"""Start the game from stage 1"""
	current_stage = 1
	is_game_active = true
	print("Game started! Welcome to Escape Mr. Taqueria")
	load_stage(current_stage)
	
func next_stage():
	"""Progress to the next stage"""
	current_stage += 1
	print("Stage %d/%d" % [current_stage, total_stages])
	
	if current_stage > total_stages:
		win_game()
	else:
		load_stage(current_stage)

func load_stage(stage_number: int):
	"""Load a specific stage"""
	print("Loading stage: %d" % stage_number)
	
	# Remove current stage if exists
	if current_stage_scene:
		current_stage_scene.queue_free()
	
	# Load the appropriate stage scene
	match stage_number:
		1:
			load_scene("res://scenes/stages/stage_1.tscn")
		2:
			load_scene("res://scenes/stages/stage_2.tscn")
		# Add more stages as they're created
		_:
			print("Stage %d not yet implemented" % stage_number)

func load_scene(scene_path: String):
	"""Load and instantiate a stage scene"""
	var stage_scene = load(scene_path)
	if stage_scene:
		current_stage_scene = stage_scene.instantiate()
		get_node("/root/Main").add_child(current_stage_scene)
		print("Loaded: %s" % scene_path)
	else:
		print("Failed to load: %s" % scene_path)

func win_game():
	"""Player successfully escaped!"""
	is_game_active = false
	print("CONGRATULATIONS! You've escaped Mr. Taqueria's Restaurant!")
	
func lose_game():
	"""Player failed - respawn or end game"""
	is_game_active = false
	print("You've been caught! Game Over!")

func get_current_restaurant_area() -> String:
	"""Determine which restaurant area we're in based on stage"""
	if current_stage == 0:
		return "dining_area"
	elif current_stage <= 8:
		return "kitchen"
	elif current_stage <= 16:
		return "storage_pantry"
	elif current_stage <= 24:
		return "exterior"
	else:
		return "back_exit"
