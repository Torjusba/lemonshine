extends Node3D
class_name TrashCan3D

@onready var player_service_area: Area3D = $PlayerServiceArea
@onready var trash_can_body: MeshInstance3D = $TrashCanBody

var original_material: Material = Material.new() # placeholder
var highlight_material: Material = Material.new() # placeholder


var active_player: Player = null
var coffee_cup: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Coffee maker running")
	original_material = trash_can_body.get_active_material(0).duplicate()
	highlight_material = original_material.duplicate()
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(1, 1, 0.4)

func _looks_at_desk(body: Node3D) -> bool:
	var pos_vec = (self.global_position - body.global_position).normalized()
	var direction = (-body.global_transform.basis.z) # Global forward direction
	return pos_vec.dot(direction) > 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player_interacting = active_player and _looks_at_desk(active_player)
	if player_interacting:
		trash_can_body.set_surface_override_material(0, highlight_material)
	else:
		trash_can_body.set_surface_override_material(0, original_material)

	if player_interacting and active_player.is_attempting_action:
		if active_player.currently_carrying:
			active_player.currently_carrying.queue_free()
			active_player.currently_carrying = null

func _on_player_service_area_body_entered(body: Node3D) -> void:
	if body.name.begins_with("Player"):
		active_player = body


func _on_player_service_area_body_exited(body: Node3D) -> void:
	if body.name.begins_with("Player"):
		active_player = null
