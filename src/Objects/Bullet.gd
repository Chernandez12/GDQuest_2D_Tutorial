extends RigidBody2D

export var projectile_speed = 500
export var lifetime = 0.5
var velocity = Vector2()
var direction = 1

func _physics_process(delta):
	global_position.x += projectile_speed * delta * direction
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if global.facing_right:
		direction = 1
		get_node("Particles2D").rotation_degrees = 180
	else:
		direction = -1
		get_node("Particles2D").rotation_degrees = -180
	set_physics_process(true)
	SelfDestruct()
	
func SelfDestruct():
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()


func _on_Bullet_body_entered(body):
	self.hide()
