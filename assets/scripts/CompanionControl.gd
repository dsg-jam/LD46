extends KinematicBody2D

const math_utils := preload("math_utils.gd")

export var speed: float = 15
export var max_distance: float = 100
export var checkpoint_size: float = 5
export var sleep_time_min: float = .5
export var sleep_time_max: float = 5

var rng = RandomNumberGenerator.new()
var target: Vector2

onready var health_bar = get_node("HealthBar")
onready var animation_controller = $AnimatedSprite

func _ready():
	rng.randomize()
	choose_target()

func choose_target() -> void:
	target = math_utils.randvec_with_radius_range(rng, 0, max_distance)

func has_reached_target() -> bool:
	return (target - position).length() <= speed

var is_sleeping: bool
var sleep_time_left: float

func _physics_process(delta):
	if is_sleeping:
		# currently sleeping
		animation_controller.set_velocity_vector(Vector2.ZERO)
		sleep_time_left -= delta
		if sleep_time_left >= 0:
			return
		
		is_sleeping = false
		choose_target()
	
	var dir := (target - self.position).normalized()
	var movement = dir * speed * delta
	var collision := move_and_collide(movement)
	if collision:
		animation_controller.set_velocity_vector(Vector2.ZERO)
		choose_target()
		return

	animation_controller.set_velocity_vector(movement)
	
	if has_reached_target():
		sleep_time_left = rng.randf_range(sleep_time_min, sleep_time_max)
		is_sleeping = true


func _on_HealthBar_is_dead():
	$"../CanvasLayer/GameOverUI".visible = true
