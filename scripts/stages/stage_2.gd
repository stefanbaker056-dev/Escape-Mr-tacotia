extends Node3D

# Stage 2 Manager - Swinging Axe Platform
# Goal: Walk across platform while dodging 3 swinging axes, then reach exit over lava

@export var stage_number: int = 2
@export var platform_length: float = 15.0
@export var axe_swing_speed: float = 2.0  # Time for one complete swing in seconds

var is_complete: bool = false
var spawn_point: Marker3D
var finish_area: Area3D
var player: CharacterBody3D
var lava_hazard: Node3D
var platform: Node3D
var axes: Array[Node3D] = []
var death_sound: AudioStreamPlayer3D
var lava_sound: AudioStreamPlayer3D
var axe_hit_sound: AudioStreamPlayer3D

func _ready():
	# Get references to important nodes
	spawn_point = $SpawnPoint
	finish_area = $FinishArea
	player = get_node("/root/Main/Player")
	lava_hazard = $LavaHazard
	platform = $Platform
	death_sound = $DeathSound
	axe_hit_sound = $AxeHitSound
	
	# Get all the swinging axes
	axes = [$Axe1, $Axe2, $Axe3]
	
	# Connect finish area signal
	if finish_area:
		finish_area.body_entered.connect(_on_finish_area_entered)
	
	# Set up lava hazard
	if lava_hazard:
		lava_hazard.body_entered.connect(_on_lava_entered)
	
	print("Stage %d ready - Dodge 3 swinging axes!" % stage_number)
	
	# Spawn player at start
	if spawn_point and player:
		player.respawn(spawn_point.global_position)
	
	# Start lava ambient sound loop
	if lava_sound:
		lava_sound.play()

func _physics_process(delta):
	"""Update swinging axes positions"""
	if not is_complete:
		for i in range(axes.size()):
			var axe = axes[i]
			if axe:
				# Calculate swing position based on time
				var time_offset = (i * PI * 2.0 / 3.0)  # Stagger axes
				var swing_amount = sin(get_tree().get_elapsed_time() * PI * 2.0 / axe_swing_speed + time_offset)
				# Swing between -1 and 1 (radians)
				axe.rotation.z = swing_amount * 0.8

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

func _check_axe_collision(axe_position: Vector3):
	"""Check if player is hit by an axe"""
	if player and player.is_alive:
		var distance = player.global_position.distance_to(axe_position)
		if distance < 1.5:  # Collision radius
			player.die()
			if axe_hit_sound:
				axe_hit_sound.play()
			print("Hit by axe! Respawning...")
			await get_tree().create_timer(1.5).timeout
			if spawn_point:
				player.respawn(spawn_point.global_position)

func complete_stage():
	"""Mark stage as complete and advance"""
	is_complete = true
	print("Stage %d complete! Well done!\" % stage_number)
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
