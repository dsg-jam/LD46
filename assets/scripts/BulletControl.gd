extends KinematicBody2D

export var speed = 150
export var damage = 10

var enemy_body

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var dir = (enemy_body.position - position).normalized()
	var is_collision = move_and_collide(dir*speed*delta)
	if is_collision:
		var collider = is_collision.get_collider()
		if collider.is_in_group("enemies"):
			if not collider.reduce_health(damage):
				collider.queue_free()
			queue_free()
		elif collider.is_in_group("resources"):
			collider.remove()
		


func _on_Timer_timeout():
	queue_free()
