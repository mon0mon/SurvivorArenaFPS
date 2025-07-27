extends RigidBody3D

signal died()

@export_category("Mob Properties")
@export var health: int = 3
@export var speed: float = randf_range(2.0, 4.0)

@onready var bat_model: Node3D = %bat_model
@onready var player: Node3D = get_node("/root/Game/Player")
@onready var timer: Timer = %Timer
@onready var hurt_sound: AudioStreamPlayer3D = %HurtSound
@onready var die_sound: AudioStreamPlayer3D = %DieSound

func _physics_process(delta: float) -> void:
    var direction: Vector3 = _calculate_toward_player()
    direction.y = 0.0
    
    linear_velocity = direction * speed
    
    # Godot은 오른손 좌표계를 사용하기 때문에, Z축의 + 방향이 스크린 방향과 가까워짐
    # 따라서 Vector3.FORWARD(0, 0, -1)을 사용하면, 몹이 플레이어를 등지게 됨
    # 이 경우 Vector3.BACK(0, 0, 1)이나 Vector3.MODEL_FRONT(0, 0, 1)을 사용하게끔 해야함
    bat_model.rotation.y = Vector3.MODEL_FRONT.signed_angle_to(direction, Vector3.UP)


func take_damage() -> void:
    if health == 0:
        return
    
    bat_model.hurt()
    hurt_sound.play()
    health -= 1
    
    if health == 0:
        set_physics_process(false)
        gravity_scale = 1.0
        
        var away_from_player_direction: Vector3 = -1.0 * _calculate_toward_player()
        var random_upward_force = Vector3.UP * randf_range(1.0, 5.0)
        
        apply_central_impulse(away_from_player_direction * 10.0 + random_upward_force)
        
        timer.start()
        die_sound.play()


func _calculate_toward_player() -> Vector3:
        return global_position.direction_to(player.global_position)


func _on_timer_timeout() -> void:
    died.emit()
    queue_free()
