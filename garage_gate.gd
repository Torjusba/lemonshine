extends Node3D
class_name GarageGate

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_open: bool = false

func open() -> void:
	if not is_open:
		animation_player.play("ArmatureAction")

func close() -> void:
	if is_open:
		animation_player.play_backwards("ArmatureAction")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var active_player: Node3D = null


func _on_player_service_area_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		print("player in front of door")
		active_player = body
		if is_open:
			close()
		else:
			open()


func _on_player_service_area_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		print("player left the door")
		active_player = null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Animation finished: ", anim_name)
	is_open = !is_open
