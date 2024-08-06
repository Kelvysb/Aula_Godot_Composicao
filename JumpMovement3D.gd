extends Movement3D
class_name JumpMovement3D

@export var jump_velocity = 4.5

func _physics_process(delta):
	if not is_active:
		return
		
	# Add the gravity.
	if not _parent.is_on_floor():
		_parent.velocity.y -= _gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and _parent.is_on_floor():
		_parent.velocity.y = jump_velocity
		
	if handle_move_and_slide:
		_parent.move_and_slide()
