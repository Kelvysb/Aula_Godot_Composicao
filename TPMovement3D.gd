extends Movement3D
class_name TPMovement3D

@export var speed = 5.0
@export var mouse_sensitivity = 0.05
@export var turn_speed = 10
@export var geometry : MeshInstance3D
@export var camera_initial_angle : float = -20
@export var spring_lenght : float = 4

var _pivot : SpringArm3D
var _camera : Camera3D

func _ready():
    _pivot = SpringArm3D.new()
    add_child(_pivot)
    _pivot.global_rotation.x = deg_to_rad(camera_initial_angle)
    _camera = Camera3D.new()
    _pivot.add_child(_camera)  
    _pivot.spring_length = spring_lenght  
    if not geometry:
        for child in _parent.get_children():
            if child is MeshInstance3D:
                geometry = child
                continue
    
func _input(event):
    if not is_active:
        return
    if event is InputEventMouseButton:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    elif Input.is_action_just_pressed("ui_cancel"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        _parent.rotate_y(deg_to_rad(-(event as InputEventMouseMotion).relative.x * mouse_sensitivity))
        geometry.rotate_y(deg_to_rad((event as InputEventMouseMotion).relative.x * mouse_sensitivity))
        _pivot.rotate_x(deg_to_rad(-(event as InputEventMouseMotion).relative.y * mouse_sensitivity))
        _pivot.rotation.x = deg_to_rad(clamp(rad_to_deg(_pivot.rotation.x), -90, 90))
        
        
func _physics_process(delta):
    if not is_active:
        return
        
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir = Input.get_vector("left", "right", "up", "down")
    var direction = (_parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        _parent.velocity.x = direction.x * speed
        _parent.velocity.z = direction.z * speed
        var prev_y = geometry.rotation.y
        geometry.look_at(Vector3(_parent.position.x, _parent.position.y + 1, _parent.position.z) + direction)
        var target_y = geometry.rotation.y
        geometry.rotation.y = lerp_angle(prev_y, target_y, delta * turn_speed)
    else:
        _parent.velocity.x = move_toward(_parent.velocity.x, 0, speed)
        _parent.velocity.z = move_toward(_parent.velocity.z, 0, speed)
    
    if handle_move_and_slide:
        _parent.move_and_slide()
