extends Node3D

@export var texture: Texture
@export var item_scene: PackedScene
# Called when the node enters the scene tree for the first time.
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D


var original_material: Material = Material.new() # placeholder
var highlight_material: Material = Material.new() # placeholder

var active_player: Player = null
var coffee_cup: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_3d.texture = texture
	original_material = mesh_instance_3d.get_active_material(0).duplicate()
	highlight_material = original_material.duplicate()
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(1, 1, 0.4)

func _looks_at_this(body: Node3D) -> bool:
	var pos_vec = (self.global_position - body.global_position).normalized()
	var direction = (-body.global_transform.basis.z) # Global forward direction
	return pos_vec.dot(direction) > 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player_interacting = active_player and _looks_at_this(active_player)
	if player_interacting:
		mesh_instance_3d.set_surface_override_material(0, highlight_material)
	else:
		mesh_instance_3d.set_surface_override_material(0, original_material)

	if player_interacting and active_player.is_attempting_action:
		if not active_player.currently_carrying:
			var new_item = item_scene.instantiate()
			add_child(new_item)
			active_player.pickup(new_item)


func _on_player_service_area_body_entered(body: Node3D) -> void:
	if body.name.begins_with("Player"):
		active_player = body


func _on_player_service_area_body_exited(body: Node3D) -> void:
	if body.name.begins_with("Player"):
		active_player = null
