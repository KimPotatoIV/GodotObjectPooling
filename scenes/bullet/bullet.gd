extends Area2D

##################################################
const MOVING_SPEED: float = 50.0
const SCREEN_OFFSET: float = 64.0

var is_using_bullet: bool = false
var velocity: Vector2 = Vector2.ZERO

##################################################
func _ready() -> void:
	z_index = -1

##################################################
func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	
	if global_position.x < -SCREEN_OFFSET or \
	global_position.x > 640.0 + SCREEN_OFFSET or \
	global_position.y < -SCREEN_OFFSET or \
	global_position.y > 360.0 + SCREEN_OFFSET:
		set_using_bullet(false)

##################################################
func get_using_bullet() -> bool:
	return is_using_bullet

##################################################
func set_using_bullet(value: bool) -> void:
	is_using_bullet = value
	
	'''▼▼▼ 사용 여부에 따라 관련 연산들을 켜거나 끔 ▼▼▼'''
	visible = is_using_bullet
	monitoring = is_using_bullet
	set_physics_process(is_using_bullet)
	set_process(is_using_bullet)
	
	if is_using_bullet:
		var fire_angle: float = randf_range(0.0, TAU)
		velocity = Vector2.RIGHT.rotated(fire_angle) * MOVING_SPEED
