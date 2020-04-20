extends KinematicBody2D

export var speed = 150
export var damage = 10

var enemy_body
var last_dir = Vector2(0, 0)
var resetted_timer = false

func handle_collision(collision: KinematicCollision2D) -> void:
	if not collision:
		return

	var collider = collision.get_collider()
	if collider.is_in_group("enemies"):
		collider.health_bar.reduce_health(damage)
		queue_free()
	elif collider.is_in_group("resources"):
		collider.get_parent().remove()
		queue_free()

func _physics_process(delta):
	if not resetted_timer:
		if is_instance_valid(enemy_body):
			last_dir = (enemy_body.position - position).normalized()
		else:
			$Timer.start(max(0.01, $Timer.get_time_left()-7))
			resetted_timer = true

	var collision := move_and_collide(last_dir*speed*delta)
	handle_collision(collision)


func _on_Timer_timeout():
	queue_free()
