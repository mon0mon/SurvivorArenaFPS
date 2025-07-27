extends Node3D

@onready var label: Label = %Label

var player_score = 0

func increase_score() -> void:
    player_score += 1
    label.text = "Score : " + str(player_score)


func do_poof(mob_global_position: Vector3) -> void:
    const SMOKE_PUFF = preload("res://mob/smoke_puff/smoke_puff.tscn")
    var poof = SMOKE_PUFF.instantiate()
    add_child(poof)
    poof.global_position = mob_global_position


func _on_mob_spawner_3d_mob_spawned(mob: Node3D) -> void:
    do_poof(mob.global_position)
    mob.died.connect(func on_mob_died() -> void:
        increase_score()
        do_poof(mob.global_position)
    )


func _on_kill_plane_body_entered(body: Node3D) -> void:
    get_tree().reload_current_scene.call_deferred()
