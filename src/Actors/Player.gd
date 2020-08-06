extends Actor

export var stomp_impulse: = 1000.0

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var attack = get_node("icon")

var bullet = preload("res://src/Objects/Bullet.tscn")
var can_fire = true

export var rate_of_fire = 0.5

func _process(delta):
	if Input.is_action_pressed("shoot") and can_fire:
		can_fire = false
		var bullet_instance = bullet.instance()
		get_parent().add_child(bullet_instance)
		bullet_instance.global_position = get_node("Position2D").get_global_position()
		if get_node("icon").flip_h == true:
			bullet_instance.global_position.x = get_node("Position2D").get_global_position().x - 278.0
		print(bullet_instance.global_position)
#		print("Bitch: ", get_node("Position2D").get_global_position().x)
		
		yield(get_tree().create_timer(rate_of_fire), "timeout")
		can_fire = true

	if Input.is_action_pressed("move_left"):
		attack.position.x = -105
		global.facing_right = false
		get_node("icon").flip_h = true
	if Input.is_action_pressed("move_right"):
		attack.position.x = 105
		global.facing_right = true
		get_node("icon").flip_h = false
	

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	global.lives -= 1

	get_parent().get_node("CanvasLayer/CanvasLayer/HUD2/Lives").update_counter(str(global.lives))
	queue_free()
	#if global.lives == 0:
	#	queue_free()

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
 
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0
		if Input.is_action_just_pressed("jump") and is_on_floor()
		else 0.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2: 
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out
