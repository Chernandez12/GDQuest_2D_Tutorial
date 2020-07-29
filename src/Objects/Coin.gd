extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

func _on_Coin_body_entered(body: PhysicsBody2D) -> void:
	global.coins += 1
	
	print("Coins = ", global.coins)
	anim_player.play("fade_out")
