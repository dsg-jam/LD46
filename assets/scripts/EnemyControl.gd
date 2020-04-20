extends KinematicBody2D

export var health = 100
export var damage = 20
export var speed = 50
export var combat_speed = 1 # Time interval in which enemy hurts the companion
var target_position
var time_combat = INF # Time since last damage
var is_reassigned = false

onready var health_bar = get_node("HealthBar")

var rng = RandomNumberGenerator.new()
var companion
var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var count_frames = $Sprite.get_hframes() * $Sprite.get_vframes()
	rng.randomize()
	var select_frame = rng.randi_range(0, count_frames-1)
	damage = rng.randi_range(2, 5)
	health_bar.health = rng.randi_range(25, 75)
	health_bar.max_health = health_bar.health
	combat_speed = rng.randi_range(1, 3)
	$Sprite.set_frame(select_frame)
	companion = get_tree().current_scene.get_node("Companion")
	animation_player = $AnimationPlayer

func _physics_process(delta):
	var dir
	if is_reassigned:
		dir = (target_position - position).normalized()
	else:
		dir = (companion.position - position).normalized()
	var is_collision = move_and_collide(dir*speed*delta)
	if is_collision:
		var collider = is_collision.get_collider()
		if collider.get_name() == "Companion" and time_combat >= combat_speed:
			collider.health_bar.reduce_health(damage)
			time_combat = 0
		elif collider.is_in_group("turrets") and time_combat >= combat_speed:
			collider.health_bar.reduce_health(damage)
			time_combat = 0
		else:
			time_combat += delta



func _on_HealthBar_is_dead():
	queue_free()
