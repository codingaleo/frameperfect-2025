extends CharacterBody2D

enum FruitType {
	WALK_THROUGH_PRESET,
	SPEED_PRESET,
	INVINCIBILITY_PRESET,
	NONE
}

@export var speed = 100.0
@export var jump_velocity = -300.0
@export var dead : bool = false
@export var current_boost : FruitType = FruitType.NONE      # Do not change in Inspector please ->
@export var coins : int = 0


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var coin_label = $"Camera2D/Label"
@onready var player_sprite := $"Player Sprite"
@onready var timer := $Timer
@onready var music := $"../Music"
@onready var jumpsfx := $jumpsfx

func _ready():
	timer.start(10.0)
	

func _physics_process(delta):
	if dead:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jumpsfx.play()
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction < 0:
			player_sprite.flip_h = true
		else:
			player_sprite.flip_h = false
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


func _on_timer_timeout():
	if dead:
		get_tree().reload_current_scene()


func _on_music_finished():
	music.play()
