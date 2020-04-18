extends KinematicBody2D

export (int) var speed := 80

# reference to SimpleAnimationController.gd
var animation_controller

func _ready() -> void:
	animation_controller = $AnimatedSprite

func read_input() -> Vector2:
	var input := Vector2()
	if Input.is_action_pressed('player_right'):
		input.x += 1
	if Input.is_action_pressed('player_left'):
		input.x -= 1
	if Input.is_action_pressed('player_down'):
		input.y += 1
	if Input.is_action_pressed('player_up'):
		input.y -= 1
	return input.normalized()

func _physics_process(_delta: float) -> void:
	var velocity := read_input() * speed
	move_and_slide(velocity)
	
	if animation_controller:
		animation_controller.set_velocity_vector(velocity)
	
	
