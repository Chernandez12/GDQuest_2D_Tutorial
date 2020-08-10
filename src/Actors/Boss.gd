extends "res://src/Actors/Actor.gd"

export var health = 10
onready var player = global.get("player")
var can_fire = true
var timer = Timer.new()
const bullet = preload("res://src/Actors/BossProjectile.tscn")

var stunned = false
var stunTime = 0.4
var knockBackTimer = Timer.new()
var knockBackVector = Vector2(600, -600)

func _process(delta):
	if is_instance_valid( player ):
		if abs(self.global_transform.origin.x - player.global_transform.origin.x) > 400 and can_fire:
			timer.start()
			can_fire = false
	
func fire():
	can_fire = true
	timer.set_wait_time(rand_range(0.75, 2))
	var projectile = bullet.instance()
	get_parent().add_child(projectile)
	projectile.spawn(self.global_position)

func _ready():
	timer.set_wait_time(rand_range(0.5, 1.5))
	timer.connect("timeout", self, "fire") 
	add_child(timer)
	
	set_physics_process(true)
	_velocity.x = -speed.x
	knockBackTimer.set_wait_time(stunTime)
	knockBackTimer.connect("timeout", self, "_on_knockBackTimer_timeout") 
	knockBackTimer.set_one_shot(true)
	add_child(knockBackTimer)
	
func _on_knockBackTimer_timeout():
	stunned = false
	_velocity.x = -speed.x

func stop():
	pass
