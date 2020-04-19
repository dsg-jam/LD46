extends AnimatedSprite

export var anim_move: String
export var anim_idle: String

# move speed required to transition to the 'moving' animation state
export var move_velocity_threshold: float = 10
# move velocity is multiplied by this factor to get the animation speed
export var move_speed_factor: float = 1 / 40.0

var initial_flip_h: bool

func _ready():
	initial_flip_h = self.flip_h

func _maybe_set_animation(target: String) -> void:
	if self.animation != target:
		# using this setter resets the frame back to 1 so we only set it when we have to
		self.animation = target

# Control the animation state and speed based on the velocity.
func set_velocity(velocity: float) -> void:
	if velocity < move_velocity_threshold:
		self.speed_scale = 1
		_maybe_set_animation(anim_idle)
		return
		
	self.speed_scale = velocity * move_speed_factor
	_maybe_set_animation(anim_move)

func set_velocity_vector(velocity: Vector2) -> void:
	set_velocity(velocity.length())
	# (initial state) XOR (flip now)
	self.flip_h = initial_flip_h != (velocity.x < 0)
