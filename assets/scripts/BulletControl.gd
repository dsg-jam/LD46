extends KinematicBody2D

export var speed = 150
export var damage = 10

var enemy_body
var last_dir = Vector2(0, 0)
var resetted_timer = false

func _physics_process(delta):
	if resetted_timer:
		move_and_collide(last_dir*speed*delta)
	elif is_instance_valid(enemy_body):
		var dir = (enemy_body.position - position).normalized()
		last_dir = dir
		var is_collision = move_and_collide(dir*speed*delta)
		if is_collision:
			var collider = is_collision.get_collider()
			if collider.is_in_group("enemies"):
				if not collider.reduce_health(damage):
					collider.queue_free()
				queue_free()
			elif collider.is_in_group("resources"):
				collider.get_parent().remove()
				queue_free()
	else:
		$Timer.start(max(0.01, $Timer.get_time_left()-7))
		resetted_timer = true


func _on_Timer_timeout():
	queue_free()
