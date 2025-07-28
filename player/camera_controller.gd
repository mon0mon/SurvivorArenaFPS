extends Node3D

@export_category("Mouse Settings")
@export var MOUSE_VERTICAL_SENSITIVITY = 0.005
@export var MOUSE_HORIZONTAL_SENSITIVITY = 0.005

@onready var player: PlayerController = $".."
@onready var camera_controller_anchor: Marker3D = %CameraControllerAnchor

var mouse_input: Vector2
var input_rotation: Vector2

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        # Godot에서는 right hand rule을 사용하기 때문에
        # 반시계 방향이 양의 방향으로 지정되어있음
        mouse_input.x += -event.screen_relative.x * MOUSE_VERTICAL_SENSITIVITY
        mouse_input.y += -event.screen_relative.y * MOUSE_HORIZONTAL_SENSITIVITY
    elif event.is_action_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(delta: float) -> void:
    input_rotation.x = clampf(input_rotation.x + mouse_input.y, deg_to_rad(-90), deg_to_rad(85))
    input_rotation.y += mouse_input.x
    
    # rotate camera controller (up/down)
    camera_controller_anchor.transform.basis = Basis.from_euler(Vector3(input_rotation.x, 0.0, 0.0))
    
    # rotate player (left/right)
    player.global_transform.basis = Basis.from_euler(Vector3(0.0, input_rotation.y, 0.0))
    
    global_transform = camera_controller_anchor.get_global_transform_interpolated()
    
    mouse_input = Vector2.ZERO
