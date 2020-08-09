extends "res://src/Actors/Actor.gd"

export var health = 3
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var player = global.get("player")

var stunned = false
var stunTime = 0.4
var knockBackTimer = Timer.new()
var knockBackVector = Vector2(600, -600)

func _ready() -> void:
	set_physics_process(true)
	_velocity.x = -speed.x
	knockBackTimer.set_wait_time(stunTime)
	knockBackTimer.connect("timeout", self, "_on_knockBackTimer_timeout") 
	knockBackTimer.set_one_shot(true)
	add_child(knockBackTimer)

func _on_StompDetector_area_entered(area: Area2D) -> void:
	health -= 1
	anim_player.play("damage_taken")
	print(health)
	
	_velocity = knockBackVector
	if self.global_transform.origin.x < player.global_transform.origin.x:
		_velocity.x *= -1
	knockBackTimer.start()
	
	#get_node("CollisionShape2D").disabled = true
	#queue_free()
	if health == 0:
		_velocity.x = 0
		anim_player.play("death")
		get_node("CollisionShape2D").disabled = true
		#queue_free()

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
		if _velocity.x < 300:
			get_node("CollisionShape2D").scale.x = 1
		else:
			get_node("CollisionShape2D").scale.x = -1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
func _on_knockBackTimer_timeout():
	stunned = false
	_velocity.x = -speed.x
func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	#health -= 1
	#anim_player.play("damage_taken")
	#print(health)
	#get_node("CollisionShape2D").disabled = true
	#queue_free()
	#if health == 0:
		#get_node("CollisionShape2D").disabled = true
		#queue_free()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	anim_player.play("idle")
