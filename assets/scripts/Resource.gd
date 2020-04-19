extends Node2D

var animation_player: AnimationPlayer

func fade_in() -> void:
	animation_player.play("fade_in")
	
func fade_out() -> void:
	animation_player.play_backwards("fade_in")

func _ready() -> void:
	animation_player = $AnimationPlayer

	fade_in()

func collect() -> int:
	return 1
