extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

func _on_Coin_body_entered(body: PhysicsBody2D) -> void:
	global.coins += 1
	#var update = "Coins: " + str(global.coins)
	get_parent().get_parent().get_node("CanvasLayer/CanvasLayer/HUD/Counter").update_counter(str(global.coins))
	#get_parent().get_parent().get_node("CanvasLayer/CanvasLayer/HUD/Counter").update_counter("COINS = "+str(global.coins))
	anim_player.play("fade_out")
