extends KinematicBody2D

export var speed = 10

var rng = RandomNumberGenerator.new()

onready var health_bar = get_node("HealthBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()




func _physics_process(_delta):
	#var dir = Vector2(rng.randi_range(-10,10), rng.randi_range(-10,10)).normalized()
	#move_and_collide(dir*speed*delta)
	pass


func _on_HealthBar_is_dead():
	$"../CanvasLayer/GameOverUI".visible = true
