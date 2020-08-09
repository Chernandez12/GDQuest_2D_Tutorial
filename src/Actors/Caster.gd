extends "res://src/Actors/Actor.gd"

onready var player = global.get("player")
var can_fire = true
var timer = Timer.new()
const bullet = preload("res://src/Actors/CasterProjectile.tscn")

func _process(delta):
	if global.get("player").global_position.x - self.global_position.x > 0:
		get_node("Sprite").flip_h = true
	else:
		get_node("Sprite").flip_h = false
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

func stop():
	pass
