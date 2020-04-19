extends KinematicBody2D

export var health = 100
export var speed = 10

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()


func reduce_health(amount):
	health -= amount
	if health <= 0:
		return false
	return true


func _physics_process(delta):
	#var dir = Vector2(rng.randi_range(-10,10), rng.randi_range(-10,10)).normalized()
	#move_and_collide(dir*speed*delta)
	pass
