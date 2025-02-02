extends Node2D

@onready var fx_sprite = $MoveFx  # Referensi ke AnimatedSprite2D

func play(animation_name: String):
	if fx_sprite:
		fx_sprite.play(animation_name)

func stop():
	if fx_sprite:
		fx_sprite.stop()

func set_flip_h(flip: bool):
	if fx_sprite:
		fx_sprite.flip_h = flip

func is_playing() -> bool:
	if fx_sprite:
		return fx_sprite.animation != "" and not fx_sprite.is_playing()
	return false
