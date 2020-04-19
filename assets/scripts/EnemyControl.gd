extends KinematicBody2D

export var health = 100
export var damage = 20
export var speed = 50
export var combat_speed = 1 # Time interval in which enemy hurts the companion

var time_combat = INF # Time since last damage
var is_companion_alive = true

var rng = RandomNumberGenerator.new()
var companion
var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var count_frames = $Sprite.get_hframes() * $Sprite.get_vframes()
	rng.randomize()
	var select_frame = rng.randi_range(0, count_frames-1)
	$Sprite.set_frame(select_frame)
	companion = get_tree().current_scene.get_node("Companion")
	animation_player = $AnimationPlayer

func _physics_process(delta):
	if is_companion_alive:
		var dir = (companion.position - position).normalized()
		var is_collision = move_and_collide(dir*speed*delta)

		if is_collision:
			var collider = is_collision.get_collider()
			if collider.get_name() == "Companion" and time_combat >= combat_speed:
				if collider.reduce_health(damage):
					time_combat = 0
				else:
					is_companion_alive = false
			else:
				time_combat += delta
	else:
		pass
		#print("You've lost the game. Companion died :(")
		#queue_free()

func reduce_health(amount):
	health -= amount
	if health <= 0:
		return false
	
	animation_player.stop(true)
	animation_player.play("take_damage")
	return true
