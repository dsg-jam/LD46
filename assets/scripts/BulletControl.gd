extends KinematicBody2D

export var speed = 150
export var damage = 10

var enemy_body

func _physics_process(delta):
	if is_instance_valid(enemy_body):
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
	else:
		queue_free()


func _on_Timer_timeout():
	queue_free()
