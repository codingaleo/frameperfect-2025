extends Sprite2D

@export var mode : Mode = Mode.WALK_THROUGH_FRUIT_MODE
@export var pressure_plate : PressurePlate

var player
var player_sprite
var player_text

enum Mode {
	WALK_THROUGH_FRUIT_MODE,
	PRESSURE_PLATE_MODE
}

enum FruitType {
	WALK_THROUGH_PRESET,
	SPEED_PRESET,
	INVINCIBILITY_PRESET,
	NONE
}

@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().current_scene.find_child("Player", true, false)
	player_sprite = player.find_child("Player Sprite")
	player_text = player.find_child("Player Text")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if mode == Mode.PRESSURE_PLATE_MODE:
		#print(self.get_self_modulate())
	if mode == Mode.WALK_THROUGH_FRUIT_MODE:
		var current_boost = player.current_boost
		if current_boost != FruitType.NONE:
			if current_boost == FruitType.WALK_THROUGH_PRESET:
				enable_passthrough()
		else:
			disable_passthrough()
	elif mode == Mode.PRESSURE_PLATE_MODE:
		if pressure_plate.pressed == true:
			enable_passthrough()
		else:
			disable_passthrough()

func enable_passthrough():
	collision_shape_2d.disabled = true
	self.modulate = Color(1, 1, 1, 0.5)

func disable_passthrough():
	collision_shape_2d.disabled = false
	self.modulate = Color(1, 1, 1, 1)
