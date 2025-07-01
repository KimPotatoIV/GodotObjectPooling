extends CharacterBody2D

##################################################
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		_fire_bullet()

##################################################
func _fire_bullet() -> void:
	var bullet = OP.get_bullet()
	bullet.global_position = global_position
