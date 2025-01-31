extends CharacterBody2D

@export var speed = 300

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# Memastikan animasi "move" diputar saat game dimulai
	animated_sprite.play("move")

func _physics_process(delta):
	# Get input direction
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_forward", "move_backward")
	direction = direction.normalized()
	
	velocity = direction * speed
	
	# Mengatur arah sprite
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
	
	# Mengatur animasi
	if direction != Vector2.ZERO:
		animated_sprite.play("move")
	else:
		# Opsional: jika ada animasi idle
		# animated_sprite.play("idle")
		# Jika tidak ada animasi idle, tetap putar "move"
		animated_sprite.play("idle")
	
	move_and_slide()
