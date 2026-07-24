extends CharacterBody3D

# Player Controller - Handles player movement and parkour mechanics

@export var speed: float = 5.0
@export var jump_force: float = 10.0
@export var gravity: float = 9.8
@export var acceleration: float = 5.0

var is_alive: bool = true
var current_stage: int = 0

func _ready():
	# Set up collision shape if not already present
	if not has_node("CollisionShape3D"):
		var collision_shape = CollisionShape3D.new()
		var capsule_shape = CapsuleShape3D.new()
		capsule_shape.radius = 0.4
		capsule_shape.height = 2.0
		collision_shape.shape = capsule_shape
		add_child(collision_shape)
	
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
	
	move_and_slide()

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