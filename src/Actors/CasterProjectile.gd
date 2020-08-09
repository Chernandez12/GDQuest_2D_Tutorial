extends "res://src/Actors/Actor.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bullet_speed = 500
var lifetime = 2

func _physics_process(delta: float) -> void:
	move_and_collide(_velocity.normalized() * bullet_speed * delta)
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	print("TEST")
	
func spawn(position):
	self.global_position = position - Vector2(100, 0)
	_velocity = (global.get("player").global_transform.origin - self.global_transform.origin)
	rotation = global.get("player").global_transform.origin.angle_to(self.global_transform.origin)
	
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
