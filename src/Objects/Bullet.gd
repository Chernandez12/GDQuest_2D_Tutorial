extends RigidBody2D

export var projectile_speed = 500
export var lifetime = 2
var velocity = Vector2.ZERO
var direction = 1

func _physics_process(delta):
	velocity.y += global.gravity * delta
	get_node(".").set_linear_velocity(velocity)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if global.facing_right:
		direction = 1
		rotation = deg2rad(180)
	else:
		direction = -1
		rotation = deg2rad(0)
	velocity = Vector2(projectile_speed * direction, -400)
	set_physics_process(true)
	SelfDestruct()
	
func SelfDestruct():
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()


func _on_Bullet_body_entered(body):
	self.hide()
