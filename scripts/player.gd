extends CharacterBody2D

enum MovementState {
	IDLE,
	RUN,
	JUMP,
	DASH
}

# Movement parameters
@export var speed = 400.0                # Base run speed
@export var jump_velocity = -4000.0       # More powerful jump for Cuphead feel
@export var dash_speed = 400.0           # Dash speed
@export var dash_duration = 0.25         # How long dash lasts
@export var dash_cooldown = 1.0          # Time between dashes
@export var air_control = 4.0            # How much control you have in air
@export var dead : bool = false
@export var coins : int = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_state = MovementState.IDLE
var can_dash = true
var dash_direction = Vector2.RIGHT
var dash_timer = 0.0

@onready var coin_label = $"Camera2D/Label"
@onready var player_sprite := $"Player Sprite" as AnimatedSprite2D  # Changed to AnimatedSprite2D
@onready var timer := $Timer
@onready var music := $"../Music"
@onready var jumpsfx := $jumpsfx
@onready var dashsfx := $dashsfx  # Add a dash sound effect node

func _ready():
	timer.start(10.0)
	player_sprite.play("idle")  # Start with idle animation

func _physics_process(delta):
	if dead:
		return
	
	# Handle dash timing
	if dash_timer > 0:
		dash_timer -= delta
		if dash_timer <= 0:
			end_dash()
	
	# Apply gravity (except during dash)
	if current_state != MovementState.DASH:
		velocity.y += gravity * delta
	
	# Get input
	var direction = Input.get_axis("ui_left", "ui_right")
	var is_jumping = Input.is_action_just_pressed("ui_accept")
	var is_dashing = (Input.is_key_pressed(KEY_SHIFT) or Input.is_key_pressed(KEY_X)) and can_dash
	
	# State machine
	match current_state:
		MovementState.IDLE:
			handle_idle(direction, is_jumping, is_dashing, delta)
		MovementState.RUN:
			handle_run(direction, is_jumping, is_dashing, delta)
		MovementState.JUMP:
			handle_jump(direction, is_jumping, is_dashing, delta)
		MovementState.DASH:
			handle_dash(delta)
	
	# Apply movement
	move_and_slide()
	
	# Update sprite direction
	if direction != 0 and current_state != MovementState.DASH:
		player_sprite.flip_h = direction < 0
	
	# Update animations
	update_animations()

func handle_idle(direction, is_jumping, is_dashing, delta):
	# Apply friction
	velocity.x = move_toward(velocity.x, 0, speed * 8 * delta)
	
	# State transitions
	if direction != 0:
		current_state = MovementState.RUN
	if !is_on_floor():
		current_state = MovementState.JUMP
	if is_jumping and is_on_floor():
		perform_jump()
	if is_dashing and can_dash:
		perform_dash(direction)

func handle_run(direction, is_jumping, is_dashing, delta):
	# Apply movement
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, speed * 6 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 12 * delta)
	
	# State transitions
	if abs(velocity.x) < 10 and direction == 0:
		current_state = MovementState.IDLE
	if !is_on_floor():
		current_state = MovementState.JUMP
	if is_jumping and is_on_floor():
		perform_jump()
	if is_dashing and can_dash:
		perform_dash(direction)

func handle_jump(direction, is_jumping, is_dashing, delta):
	# Air control
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, speed * air_control * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * air_control * delta)
	
	# State transitions
	if is_on_floor():
		if abs(velocity.x) > 10:
			current_state = MovementState.RUN
		else:
			current_state = MovementState.IDLE
		
	if is_dashing and can_dash:
		perform_dash(direction)

func handle_dash(delta):
	# Dash movement is handled in perform_dash
	pass

func perform_jump():
	velocity.y = jump_velocity * 1.25
	current_state = MovementState.JUMP
	jumpsfx.play()

func perform_dash(direction):
	if direction == 0:
		dash_direction = Vector2.RIGHT if !player_sprite.flip_h else Vector2.LEFT
	else:
		dash_direction = Vector2(direction, 0).normalized()
	
	current_state = MovementState.DASH
	can_dash = false
	dash_timer = dash_duration
	velocity = dash_direction * dash_speed
	dashsfx.play()
	# Start dash cooldown timer
	get_tree().create_timer(dash_cooldown).connect("timeout", func(): can_dash = true)

func end_dash():
	if is_on_floor():
		if abs(velocity.x) > 10:
			current_state = MovementState.RUN
		else:
			current_state = MovementState.IDLE
	else:
		current_state = MovementState.JUMP
	# Reduce speed after dash
	velocity.x *= 0.5

func update_animations():
	match current_state:
		MovementState.IDLE:
			if player_sprite.animation != "idle": 
				player_sprite.play("idle")
		MovementState.RUN:
			if player_sprite.animation != "run":
				player_sprite.play("run")
		MovementState.JUMP:
			if player_sprite.animation != "jump":
				player_sprite.play("jump")
		MovementState.DASH:
			if player_sprite.animation != "dash":
				player_sprite.play("dash")

func _on_timer_timeout():
	if dead:
		get_tree().reload_current_scene()

func _on_music_finished():
	music.play()
