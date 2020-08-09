extends RigidBody2D

#extends "res://src/Actors/Actor.gd"

export var projectile_speed = 200
export var lifetime = 2
var velocity = Vector2()
var player = global.get("player")

func _physics_process(delta: float) -> void:
	#ACTIVATE LINE BELOW TO MAKE PROJECTILE FOLLOW PLAYER
	#velocity = global_position.direction_to(global.get("player").global_position)
	get_node(".").set_linear_velocity(velocity * projectile_speed)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if is_instance_valid( player ):
		velocity = (self.global_position - player.global_position).normalized()
		set_physics_process(true)
		print("ENEMY SHOT")
	
func spawn(position):
	if is_instance_valid( player ):
		if global.get("player").global_position.x - position.x < 0:
			self.global_position = position - Vector2(100, 0)
		else:
			self.global_position = position - Vector2(-100, 0)
		rotation = global.get("player").global_transform.origin.angle_to(self.global_transform.origin)
		velocity = global_position.direction_to(global.get("player").global_position)
		yield(get_tree().create_timer(lifetime), "timeout")
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_CasterProjectile_body_entered(body):
	print("Hit")
	self.hide()
