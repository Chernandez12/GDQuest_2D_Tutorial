extends RigidBody2D

export var projectile_speed = 400
export var lifetime = 1

func _process(delta):
	if global.facing_right:
		global_position.x += projectile_speed * delta
	else:
		global_position.x -= projectile_speed * delta

# Called when the node enters the scene tree for the first time.
func _ready():
	SelfDestruct()
	
func SelfDestruct():
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()


func _on_Bullet_body_entered(body):
	self.hide()
