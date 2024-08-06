extends Node3D
class_name Movement3D

@export var is_active : bool = true
@export var handle_move_and_slide : bool = false
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var _parent : CharacterBody3D = get_parent()

func _physics_process(delta):
	if not is_active:
		return
		
	# Add the gravity.
	if not _parent.is_on_floor():
		_parent.velocity.y -= _gravity * delta
