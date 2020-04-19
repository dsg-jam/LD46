extends KinematicBody2D

var health = 100
var damage = 1
var speed = 50
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	var count_frames = $Sprite.get_hframes() * $Sprite.get_vframes()
	rng.randomize()
	var select_frame = rng.randi_range(0, count_frames-1)
	$Sprite.set_frame(select_frame)
	pass



func _physics_process(delta):

	var dir = ($"../Companion".position - position).normalized()
	var is_collision = move_and_collide(dir*speed*delta)

	if is_collision:
		print("Companion lost a health unit")
