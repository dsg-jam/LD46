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
		game_over()
		return false
	return true

func game_over():
	$"../CanvasLayer/GameOverUI".visible = true

func _physics_process(_delta):
	#var dir = Vector2(rng.randi_range(-10,10), rng.randi_range(-10,10)).normalized()
	#move_and_collide(dir*speed*delta)
	pass
