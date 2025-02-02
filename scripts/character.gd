extends CharacterBody2D

@export var speed = 300

@onready var animated_sprite = $AnimatedSprite2D
@onready var animated_fx = $FxAnimated

@export var dash_speed = 800
@export var dash_duration = 0.3
@export var dash_cooldown = 2.0
var is_dashing = false
var can_dash = true
var dash_direction = Vector2.ZERO

func _ready():
	animated_sprite.play("idle")
	animated_fx.hide()  # Sembunyikan efek langkah di awal

func _physics_process(_delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_forward", "move_backward")
	direction = direction.normalized()
	
	# Dash dengan syarat ada input movement
	if Input.is_action_just_pressed("dashing") and can_dash and direction != Vector2.ZERO:
		start_dash(direction)
	
	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		velocity = direction * speed
	
	# Flip sprite
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
	
	# Kondisi untuk state berjalan
	if direction != Vector2.ZERO and !is_dashing:
		# Animasi berjalan
		animated_sprite.play("move")
		
		# Tampilkan efek langkah
		if !animated_fx.visible:
			animated_fx.show()
			animated_fx.flip_h = animated_sprite.flip_h
		if direction.x < 0 :
			animated_fx.position.x = abs(animated_fx.position.x)
		else :
			animated_fx.position.x = -abs(animated_fx.position.x)
		animated_fx.play("move_fx")  # Mainkan animasi efek langkah
	else:
		# Animasi idle
		animated_sprite.play("idle")
		
		# Sembunyikan efek langkah
		if animated_fx.visible:
			animated_fx.hide()
			animated_fx.stop()  # Hentikan animasi efek langkah
	
	move_and_slide()

func start_dash(direction: Vector2):
	is_dashing = true
	can_dash = false
	dash_direction = direction.normalized()
	
	await get_tree().create_timer(dash_duration).timeout
	end_dash()
	
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func end_dash():
	is_dashing = false
	velocity = Vector2.ZERO
