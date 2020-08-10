extends "res://src/Actors/Actor.gd"

export var health = 3
onready var player = global.get("player")
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
var can_fire = true
var timer = Timer.new()
const bullet = preload("res://src/Actors/CasterProjectile.tscn")

var stunned = false
var stunTime = 0.4
var knockBackTimer = Timer.new()
var knockBackVector = Vector2(400, -400)
var knockback = Vector2.ZERO

func _process(delta):
	if is_instance_valid( player ):
		if global.get("player").global_position.x - self.global_position.x > 0:
			get_node("CollisionShape2D/Sprite").flip_h = true
		else:
			get_node("CollisionShape2D/Sprite").flip_h = false
		if abs(self.global_transform.origin.x - player.global_transform.origin.x) > 400 and can_fire:
			timer.start()
			can_fire = false
			
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 60 * delta)
	knockback = move_and_slide(knockback)
	
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


func _on_CasterHitbox_area_entered(area):
	health -= 1
	anim_player.play("damage")
	print("CASTER DAMAGED")
	
	if global.get("player").global_position.x - self.global_position.x > 0:
		knockback = Vector2.LEFT * 150
	else:
		knockback = Vector2.RIGHT * 150
	
	if health == 0:
		print("CASTER DIED")
		self.queue_free()
