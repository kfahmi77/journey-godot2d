extends CharacterBody2D

@export var speed = 300

@onready var character_sprite = $AnimatedSprite2D
@onready var move_fx = $CharacterVfx/MoveVfx
@onready var dash_fx =$CharacterVfx/DashVfx
@onready var character_fx = $CharacterVfx

@export var dash_speed = 800
@export var dash_duration = 0.3
@export var dash_cooldown = 2.0
var is_dashing = false
var can_dash = true
var dash_direction = Vector2.ZERO

func _ready():
	character_sprite.play("idle")
	dash_fx.hide()
	move_fx.hide()  # Sembunyikan efek langkah di awal

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
	
	# Flip sprite dan dash effect
	if direction.x != 0:
		character_sprite.flip_h = direction.x < 0
		dash_fx.flip_h = direction.x < 0
	
	# Kondisi untuk animasi
	if is_dashing:
		# Animasi dash
		dash_fx.show()
		dash_fx.play("dash_vfx")
		move_fx.hide()
		move_fx.stop()
	elif direction != Vector2.ZERO:
		# Animasi berjalan
		character_sprite.play("move")
		dash_fx.hide()
		
		# Tampilkan efek langkah
		if !move_fx.visible:
			move_fx.show()
			move_fx.flip_h = character_sprite.flip_h
		if direction.x < 0:
			character_fx.position.x = abs(character_fx.position.x)
		else:
			character_fx.position.x = -abs(character_fx.position.x)
		move_fx.play("move_fx")  # Mainkan animasi efek langkah
	else:
		# Animasi idle
		character_sprite.play("idle")
		dash_fx.hide()
		
		# Sembunyikan efek langkah
		if move_fx.visible:
			move_fx.hide()
			move_fx.stop()  # Hentikan animasi efek langkah
	
	move_and_slide()

func start_dash(direction: Vector2):
	is_dashing = true
	can_dash = false
	dash_direction = direction.normalized()
	
	# Play dash animation
	dash_fx.show()
	dash_fx.play("dash_vfx")
	
	await get_tree().create_timer(dash_duration).timeout
	end_dash()
	
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func end_dash():
	is_dashing = false
	velocity = Vector2.ZERO
	dash_fx.hide()
