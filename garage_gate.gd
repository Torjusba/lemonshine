extends Node3D
class_name GarageGate

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_open: bool = false
@onready var collision_shape_3d: CollisionShape3D = $Armature/Skeleton3D/StaticBody3D/CollisionShape3D

func open() -> void:
	if not is_open:
		animation_player.play("ArmatureAction")

func close() -> void:
	if is_open:
		animation_player.play_backwards("ArmatureAction")

func toggle() -> void:
	if is_open:
		close()
	else:
		open()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	is_open = !is_open
	collision_shape_3d.disabled = is_open
