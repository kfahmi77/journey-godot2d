extends CharacterBody2D

@export var speed = 300

@onready var animated_sprite = $AnimatedSprite2D
@onready var idle_timer = $IdleTimer

@export var dash_speed = 800  # Kecepatan dash
@export var dash_duration = 0.3  # Durasi dash
@export var dash_cooldown = 2.0  # Cooldown dash
var is_dashing = false  # Status sedang dash
var can_dash = true  # Apakah dash bisa dilakukan
var dash_direction = Vector2.ZERO  # Arah dash

func _ready():
	idle_timer.one_shot = true  # Timer hanya memicu sekali
	animated_sprite.play("idle")

func _physics_process(delta):
	# Get input direction
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_forward", "move_backward")
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("dashing") and can_dash:
		print("dash is pressed")
		start_dash(direction)
	
	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		velocity = direction * speed
	
	# Mengatur arah sprite
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
	
	# Mengatur animasi
	if direction != Vector2.ZERO:
		animated_sprite.play("move")
		idle_timer.stop()  # Hentikan timer jika ada input
	else:
		if idle_timer.is_stopped():
			idle_timer.start()  # Mulai timer jika tidak ada input
	
	move_and_slide()

func _on_idle_timer_timeout():
	print("Idle timer timeout triggered")
	animated_sprite.play("idle")
	
func start_dash(direction: Vector2):
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	
	is_dashing = true
	can_dash = false
	dash_direction = direction
	
	await get_tree().create_timer(dash_duration).timeout
	end_dash()
	
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true
	

func end_dash():
	is_dashing = false
	velocity = Vector2.ZERO
