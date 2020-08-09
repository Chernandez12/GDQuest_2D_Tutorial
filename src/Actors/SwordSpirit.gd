extends "res://src/Actors/Actor.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	_velocity.x = -speed.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
		
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
