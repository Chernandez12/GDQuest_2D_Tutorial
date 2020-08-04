extends "res://src/Actors/Actor.gd"

export var health = 3

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x

func _on_StompDetector_area_entered(area: Area2D) -> void:
	get_node("CollisionShape2D").disabled = true
	queue_free()

func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	health -= 1
	print(health)
	get_node("CollisionShape2D").disabled = true
	queue_free()
	#if health == 0:
	#	get_node("CollisionShape2D").disabled = true
	#	queue_free()

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

