extends KinematicBody2D

var health = 100
var damage = 1
var speed = 50
var rng = RandomNumberGenerator.new()
var time_combat = INF # Time since last damage
var combat_speed = 1 # Time interval in which enemy hurts the companion


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
		var collider = is_collision.get_collider()
		if collider.get_name() == "Companion" and time_combat >= combat_speed:
			collider.reduce_health(1)
			time_combat = 0
		else:
			time_combat += delta
