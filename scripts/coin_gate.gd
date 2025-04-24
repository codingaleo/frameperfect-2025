extends Node2D

@export var coins_needed_to_pass : int

var player
var player_sprite
var player_text
var passable : bool = false
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D
@onready var coin_amount_text = $"Coin Amount Text"

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().current_scene.find_child("Player", true, false)
	player_sprite = player.find_child("Player Sprite")
	player_text = player.find_child("Player Text")
	coin_amount_text.text = str(coins_needed_to_pass)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var coins = player.coins
	if coins >= coins_needed_to_pass:
		passable = true
		collision_shape_2d.disabled = true
		self.find_child("Block").modulate = Color(1, 1, 1, 0)
		self.find_child("Coin").modulate = Color(1, 1, 1, 0.5)
	else:
		collision_shape_2d.disabled = false
		self.find_child("Block").modulate = Color(1, 1, 1, 1)
		self.find_child("Coin").modulate = Color(1, 1, 1, 1)


func _on_area_2d_body_entered(body):
	if body == player and passable == false:
		player_text.text = "I need " + str(coins_needed_to_pass) + " coins to pass this wall."


func _on_area_2d_body_exited(body):
	if body == player:
		player_text.text = ""
