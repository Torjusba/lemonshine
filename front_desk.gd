extends Node3D

@onready var front_desk: Node3D = $"."
@onready var player_service_area: Area3D = $PlayerServiceArea
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var front_desk_original_material: Material = Material.new()  # placeholder
var highlight_material: Material = Material.new()  # placeholder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Front desk running")
	front_desk_original_material = mesh_instance_3d.get_active_material(0).duplicate()
	highlight_material = front_desk_original_material.duplicate()
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(1, 1, 0, 0.6)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var player_is_at_desk: bool = false

func _on_player_service_area_body_entered(body: Node3D) -> void:
	print("Body entered:", body)
	if body.name == "Player":
		player_is_at_desk = true
		print("Player is at desk")
		mesh_instance_3d.set_surface_override_material(0, highlight_material)
	pass # Replace with function body.


func _on_player_service_area_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_is_at_desk = false
		print("Player is no longer at desk")
		mesh_instance_3d.set_surface_override_material(0, front_desk_original_material)
