extends Node

export var deaths_reqd = 10

func _ready():
	pass
	
func _process(delta):
	#Reset Kill count before reaching arena area
	if global.get("player").global_position.x - self.global_position.x < 0:
		global.kills = 0
	#Player Blocked from entering from left
	if global.get("player").global_position.x - self.global_position.x > 10:
		get_node("StaticBody2D/CollisionShape2D").disabled = false
	else:
		get_node("StaticBody2D/CollisionShape2D").disabled = true
