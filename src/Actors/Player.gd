extends Actor

export var stomp_impulse: = 1000.0
var dashing: = false
export var can_dash: = true

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var attack_player: AnimationPlayer = get_node("yuvia/MeleeDetector/Swipe/AnimationPlayer")
onready var attack = get_node("yuvia/MeleeDetector")
onready var yuvia = get_node("yuvia")

var knocked_back = false
var knock_back_dir = 1
var knock_back_Vect = Vector2(800, -600)

var invincible = false
var last_hit_enemy

var facing_left = 1

func _ready():
	global.set("player", self)
	play_audio("res://assets/Sounds/Yuvia's Lament.wav")
	
func _process(delta):

	if Input.is_action_pressed("move_left"):
		anim_player.play("moving")
		yuvia.scale.x = -0.2
	if Input.is_action_pressed("move_right"):
		anim_player.play("moving")
		yuvia.scale.x = 0.2
	if Input.is_action_just_pressed("attack"):
		attack_player.play("melee")
		play_audio("res://assets/Sounds/SFX/swing.wav")
	if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
		anim_player.play("idle")
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		anim_player.play("idle")
	if _velocity.y < 0:
		anim_player.play("jump")
	elif _velocity.y > 0:
		anim_player.play("falling")

func play_audio(sound):
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load(sound)
	player.play()

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	#_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	print("Attack")
	
func on_death():
	global.lives = 5
	get_parent().get_node("CanvasLayer/CanvasLayer/HUD2/Lives").update_counter(str(global.lives))
	self.global_position = Vector2(450, 300)
	self._velocity = Vector2.ZERO
	# Add animations / Screen transitions / SFX here

func hurt(body: PhysicsBody2D) -> void:
	if not invincible and is_instance_valid(body):
		print("INVINCIBLE") #Play animation / effects here
		attack_player.play("damage")
		global.lives -= 1
		invincible = true
		knocked_back = true

		if self.global_transform.origin.x < body.global_transform.origin.x:
			knock_back_dir = -1
			print("right")
		else:
			knock_back_dir = 1
			print("left")
	
		$knockedBackTimer.start()
		$playerInvincibilityTimer.start()
		_velocity.x = knock_back_Vect.x * knock_back_dir
		_velocity.y = knock_back_Vect.y
	
		get_parent().get_node("CanvasLayer/CanvasLayer/HUD2/Lives").update_counter(str(global.lives))
		#queue_free()
		if global.lives == 0:
			on_death()
			
func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	last_hit_enemy = body
	hurt(body)

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()

	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

	if Input.is_action_just_pressed("dash") and can_dash and not knocked_back:
		dashing = true
		play_audio("res://assets/Sounds/SFX/dash.wav")
		dash()


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0
		if Input.is_action_just_pressed("jump") and is_on_floor()
		else 0.0
	)

func dash():
	can_dash = false
	speed.x = 1100.0
	$dashTimer.start()

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity

	if not knocked_back:
		out.x = speed.x * direction.x
		if direction.y == -1.0:
			out.y = speed.y * direction.y
		if is_jump_interrupted:
			out.y = 0.0

	out.y += gravity * get_physics_process_delta_time()
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out

func _on_dashTimer_timeout():
	speed.x = 400.0
	dashing = false
	$dashCooldownTimer.start()
	can_dash = false

func _on_dashCooldownTimer_timeout():
	can_dash = true
	play_audio("res://assets/Sounds/SFX/dash_meter.wav")

func _on_knockedBackTimer_timeout():
	knocked_back = false

func _on_MeleeDetector_area_entered(area):
	knocked_back = true
	$knockedBackTimer.start()

	_velocity.x = knock_back_Vect.x * facing_left * 0.25
	_velocity.y = knock_back_Vect.y * 0.5

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	anim_player.play("idle")


func _on_playerInvincibilityTimer_timeout():
	invincible = false
	if get_node("yuvia/EnemyDetector").get_overlapping_bodies().size() != 0:
		hurt(last_hit_enemy)
