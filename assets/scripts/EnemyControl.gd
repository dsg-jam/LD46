extends KinematicBody2D

export var health = 100
export var damage = 20
export var speed = 50
export var combat_speed = 1 # Time interval in which enemy hurts the companion

var time_combat = INF # Time since last damage
var is_companion_alive = true

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var count_frames = $Sprite.get_hframes() * $Sprite.get_vframes()
	rng.randomize()
	var select_frame = rng.randi_range(0, count_frames-1)
	$Sprite.set_frame(select_frame)
	pass



func _physics_process(delta):
	if is_companion_alive:
		var dir = ($"../Companion".position - position).normalized()
		var is_collision = move_and_collide(dir*speed*delta)

		if is_collision:
			var collider = is_collision.get_collider()
			if collider.get_name() == "Companion" and time_combat >= combat_speed:
				if collider.reduce_health(damage):
					time_combat = 0
				else:
					is_companion_alive = false
					collider.queue_free()
			else:
				time_combat += delta
	else:
		print("You've lost the game. Companion died :(")
		queue_free()
