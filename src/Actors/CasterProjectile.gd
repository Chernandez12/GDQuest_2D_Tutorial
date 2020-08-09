extends RigidBody2D

#extends "res://src/Actors/Actor.gd"

export var projectile_speed = 200
export var lifetime = 2
var velocity = Vector2()

func _physics_process(delta: float) -> void:
	#move_and_collide(_velocity.normalized() * projectile_speed * delta)
	get_node(".").set_linear_velocity(velocity * projectile_speed)
	#apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
	
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = (self.global_position - global.get("player").global_position).normalized()
	set_physics_process(true)
	print("ENEMY SHOT")
	
func spawn(position):
	self.global_position = position - Vector2(100, 0)
	#_velocity = (global.get("player").global_transform.origin - self.global_transform.origin)
	rotation = global.get("player").global_transform.origin.angle_to(self.global_transform.origin)
	velocity = global_position.direction_to(global.get("player").global_position)
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_CasterProjectile_body_entered(body):
	print("Fag Hit")
	self.hide()
