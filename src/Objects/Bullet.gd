extends RigidBody2D

var projectile_speed = 400
var lifetime = 1

func _process(delta):
	global_position.x += projectile_speed * delta

# Called when the node enters the scene tree for the first time.
func _ready():
	#apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
	SelfDestruct()
	
func SelfDestruct():
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()


func _on_Bullet_body_entered(body):
	self.hide()
