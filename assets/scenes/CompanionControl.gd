extends KinematicBody2D

export var health = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func reduce_health(amount):
	health -= amount
	print(health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
