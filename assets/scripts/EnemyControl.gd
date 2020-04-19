extends KinematicBody2D

var health = 100
var damage = 1
var speed = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _physics_process(delta):
	

	var dir = ($"../Companion".position - position).normalized()
	var is_collision = move_and_collide(dir*speed*delta)

	if is_collision:
		print("Companion lost a health unit")
