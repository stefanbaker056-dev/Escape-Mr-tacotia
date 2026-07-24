extends CharacterBody3D

# Player Controller - Handles player movement and parkour mechanics

@export var speed: float = 5.0
@export var jump_force: float = 10.0
@export var gravity: float = 9.8
@export var acceleration: float = 5.0

var is_alive: bool = true
var current_stage: int = 0
var jump_sound: AudioStreamPlayer3D
var land_sound: AudioStreamPlayer3D
var was_on_floor: bool = false

func _ready():
	# Set up collision shape if not already present
	if not has_node("CollisionShape3D"):
		var collision_shape = CollisionShape3D.new()
		var capsule_shape = CapsuleShape3D.new()
		capsule_shape.radius = 0.4
		capsule_shape.height = 2.0
		collision_shape.shape = capsule_shape
		add_child(collision_shape)
	
	# Set up jump and landing sounds
	jump_sound = AudioStreamPlayer3D.new()
	jump_sound.name = "JumpSound"
	jump_sound.stream = load("res://assets/sounds/jump.ogg")
	jump_sound.volume_db = 3
	add_child(jump_sound)
	
	land_sound = AudioStreamPlayer3D.new()
	land_sound.name = "LandSound"
	land_sound.stream = load("res://assets/sounds/land.ogg")
	land_sound.volume_db = 2
	add_child(land_sound)
	
	was_on_floor = is_on_floor()
	print("Player spawned at: ", global_position)

func _physics_process(delta):
	if not is_alive:
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get input
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.z = Input.get_axis("ui_up", "ui_down")
	input_vector = input_vector.normalized()
	
	# Move player
	if input_vector != Vector3.ZERO:
		velocity.x = input_vector.x * speed
		velocity.z = input_vector.z * speed
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)
	
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
		play_jump_sound()
	
	# Landing sound
	if is_on_floor() and not was_on_floor and velocity.y <= 0:
		play_land_sound()
	
	was_on_floor = is_on_floor()
	move_and_slide()

func play_jump_sound():
	"""Play jump sound effect"""
	if jump_sound and jump_sound.stream:
		jump_sound.play()

func play_land_sound():
	"""Play landing sound effect"""
	if land_sound and land_sound.stream:
		land_sound.play()

func die():
	"""Player dies - handle respawn"""
	is_alive = false
	print("Player died!")
	# Will be handled by stage manager for respawn

func respawn(spawn_pos: Vector3):
	"""Respawn player at given position"""
	is_alive = true
	global_position = spawn_pos
	velocity = Vector3.ZERO
	print("Player respawned at: ", spawn_pos)

func freeze_player():
	"""Admin command: Freeze the player"""
	velocity = Vector3.ZERO
	print("Player frozen!")

func make_player_fly():
	"""Admin command: Make player fly"""
	print("Player is flying!")
	# Flying mechanics

func fling_player(direction: Vector3, force: float):
	"""Admin command: Fling player in a direction"""
	velocity = direction * force
	print("Player flung with force: ", force)

func explode_player():
	"""Admin command: Explode player"""
	die()
	print("Player exploded!")