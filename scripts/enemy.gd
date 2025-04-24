extends Node2D

@onready var timer = $Enemy/Area2D/Timer
@onready var ray_cast_l = $Enemy/RayCastL
@onready var ray_cast_r = $Enemy/RayCastR
@onready var animated_sprite_2d = $Enemy/AnimatedSprite2D
@onready var audio_stream_player_2d = $Enemy/AudioStreamPlayer2D

enum FruitType {
	WALK_THROUGH_PRESET,
	SPEED_PRESET,
	INVINCIBILITY_PRESET,
	NONE
}

var player
var player_sprite
var player_text
var music
var dead : bool = false

@export var speed = 60
@export var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().current_scene.find_child("Player", true, false)
	music = get_tree().current_scene.find_child("Music")
	player_sprite = player.find_child("Player Sprite")
	player_text = player.find_child("Player Text")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_r.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_l.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	position.x += speed * delta * direction
	
func _on_area_2d_body_entered(body):
	if body.name == "Player" and not player.current_boost == FruitType.INVINCIBILITY_PRESET and not dead:
		player.dead = true
		player_sprite.play("hit")
		player_text.text = ":/"
		audio_stream_player_2d.play()
		music.stop()
		timer.start()
		dead = true


func _on_timer_timeout():
	get_tree().reload_current_scene()
