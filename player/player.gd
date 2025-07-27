extends CharacterBody3D

@export_category("Player Properties")

@export var SPEED : float = 5.5

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        # Godot에서는 right hand rule을 사용하기 때문에
        # 반시계 방향이 양의 방향으로 지정되어있음
        rotation_degrees.y -= event.relative.x * 0.125
        %Camera3D.rotation_degrees.x -= event.relative.y * 0.125
        %Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80.0, 80.0)
    elif event.is_action_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
    var input_direction_2D : Vector2 = Input.get_vector(
        "move_left", "move_right", "move_foward", "move_backward"
    )
    var input_direction_3D := Vector3(input_direction_2D.x, 0.0, input_direction_2D.y)
    var direction := transform.basis * input_direction_3D
    
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
    
    velocity.y -= 20.0 * delta
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = 10.0
    elif Input.is_action_just_released("jump") and velocity.y > 0.0 :
        velocity.y = 0.0
    
    move_and_slide()
    
    if Input.is_action_pressed("shoot") and %Timer.is_stopped():
        shoot_bullet()


func shoot_bullet():
    const BULLET_3D = preload("res://player/bullet_3d.tscn")
    var new_bullet = BULLET_3D.instantiate()
    %Marker3D.add_child(new_bullet)
    
    new_bullet.global_transform = %Marker3D.global_transform
    
    %Timer.start()
    
    %AudioStreamPlayer.play()
