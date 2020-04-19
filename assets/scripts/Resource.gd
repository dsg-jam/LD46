extends Node2D

var animation_player: AnimationPlayer

func fade_in() -> void:
	animation_player.play("fade_in")
	
func _ready() -> void:
	animation_player = $AnimationPlayer

	fade_in()

func _on_fade_out_finished(_name: String) -> void:
	queue_free()

func remove() -> void:
	animation_player.connect("animation_finished", self, "_on_fade_out_finished")
	animation_player.play_backwards("fade_in")

func collect() -> int:
	# remove collider immediately to avoid repeated detections
	$StaticBody2D.free()
	remove()
	
	# TODO yield random amount of resources
	return 2
