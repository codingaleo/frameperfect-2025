extends Area2D

enum FruitType {
	WALK_THROUGH_PRESET,
	SPEED_PRESET,
	INVINCIBILITY_PRESET,
	NONE
}

@export var buff_type : FruitType = FruitType.SPEED_PRESET
@export var buff_duration : float = 8.0
@export var respawn_time : float = 5.0     # set to 0.0 for no respawn

@onready var respawn_timer = $"Respawn Timer"
@onready var timer = $Timer
@onready var powerupsfx = $powerupsfx

var player : CharacterBody2D
var player_sprite : AnimatedSprite2D
var player_text : Label
var player_speed : float
var player_buff_text : Label

var eaten : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().current_scene.find_child("Player", true, false)
	player_sprite = player.find_child("Player Sprite")
	player_text = player.find_child("Player Text")
	player_buff_text = player.find_child("Buff Text")
	player_speed = player.speed
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not timer.is_stopped():
		player_buff_text.text = str(int(timer.time_left))


func _on_body_entered(body):
	if eaten == false:
		powerupsfx.play()
		match buff_type:
			FruitType.SPEED_PRESET:
				player_text.text ="I feel fast!"
				player.speed = player_speed * 2
				player.current_boost = FruitType.SPEED_PRESET
			FruitType.WALK_THROUGH_PRESET:
				player_text.text = "yum"
				player.current_boost = FruitType.WALK_THROUGH_PRESET
			FruitType.INVINCIBILITY_PRESET:
				player_text.text = "I'm invincible!"
				player.current_boost = FruitType.INVINCIBILITY_PRESET
		timer.start(buff_duration)
		self.visible = false
	eaten = true


func _on_timer_timeout():
	if respawn_time != 0.0:
		respawn_timer.start(respawn_time)
	player_buff_text.text = ""
	match buff_type:
		FruitType.SPEED_PRESET:
			player.speed = player_speed
			player_text.text = ""
		FruitType.WALK_THROUGH_PRESET:
			player_text.text = ""
		FruitType.INVINCIBILITY_PRESET:
			player_text.text = ""
	player.current_boost = FruitType.NONE
	


func _on_respawn_timer_timeout():
	eaten = false
	self.visible = true
	respawn_timer.stop()
