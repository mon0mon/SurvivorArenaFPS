extends Area3D

const SPEED :float = 10.0
const RANGE :float = 40.0

var travelled_distance :float = 0.0

func _physics_process(delta: float) -> void:
    position += -transform.basis.z * SPEED * delta
    travelled_distance += SPEED * delta
    if travelled_distance > RANGE:
        queue_free()


func _on_body_entered(body: Node3D) -> void:
    queue_free()
    if body.has_method("take_damage"):
        body.take_damage()
