extends Node3D

# Stage 1 Manager - Simple block jumping over lava
# Goal: Jump across 4 blocks to reach the exit

@export var stage_number: int = 1
@export var lava_height: float = -2.0  # How far below is the lava?

var is_complete: bool = false
var spawn_point: Marker3D
var finish_area: Area3D
var player: CharacterBody3D
var lava_hazard: Node3D
var blocks: Array[Node3D] = []
var death_sound: AudioStreamPlayer3D
var lava_sound: AudioStreamPlayer3D

func _ready():
	# Get references to important nodes
	spawn_point = $SpawnPoint
	finish_area = $FinishArea
	player = get_node("/root/Main/Player")
	lava_hazard = $LavaHazard
	death_sound = $DeathSound
	lava_sound = $LavaHazard/LavaSound
	
	# Get all the block platforms
	blocks = [$Block1, $Block2, $Block3, $Block4]
	
	# Connect finish area signal
	if finish_area:
		finish_area.body_entered.connect(_on_finish_area_entered)
	
	# Set up lava hazard
	if lava_hazard:
		lava_hazard.body_entered.connect(_on_lava_entered)
	
	print("Stage %d ready - Jump across 4 blocks to escape!" % stage_number)
	
	# Spawn player at start
	if spawn_point and player:
		player.respawn(spawn_point.global_position)
	
	# Start lava ambient sound loop
	play_lava_ambient()

func _on_finish_area_entered(body):
	"""Called when player reaches the finish point"""
	if body == player and not is_complete:
		complete_stage()

func _on_lava_entered(body):
	"""Called when player touches lava"""
	if body == player and player.is_alive:
		player.die()
		
		# Play death sound
		if death_sound:
			death_sound.play()
		
		print("Fell into lava! Respawning...")
		await get_tree().create_timer(1.5).timeout
		if spawn_point and player:
			player.respawn(spawn_point.global_position)

func play_lava_ambient():
	"""Play lava ambient sound loop"""
	if lava_sound:
		lava_sound.play()

func complete_stage():
	"""Mark stage as complete and advance"""
	is_complete = true
	print("Stage %d complete! Well done!" % stage_number)
	# Signal to game manager
	var game_manager = get_node("/root/Main/GameManager")
	if game_manager:
		game_manager.next_stage()

func reset_stage():
	"""Reset the stage for retry"""
	is_complete = false
	print("Stage %d reset" % stage_number)
	if spawn_point and player:
		player.respawn(spawn_point.global_position)