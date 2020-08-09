extends "res://src/Actors/Actor.gd"


onready var player = global.get("player")
onready var object = get_node("Sprite")
var enemy_speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dir = (object.global_position - global_position)
