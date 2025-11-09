extends CharacterBody3D
class_name Player

@export var player_id: int = 1
@export var device_id: int = -1 # >=0 means use raw gamepad axes for movement

@onready var animation_player: AnimationPlayer = $base_character/AnimationPlayer
const SPEED = 5.0
const DASH_SPEED := 15.0
const DASH_ACTIVE_DURATION := 0.18
var dash_active_time: float = 0.0
var currently_carrying: Item3D = null
var is_attempting_action: bool = false

func pickup(item: Item3D) -> void:
	if currently_carrying:
		print("Player can't pickup, is already carrying")
		return
	print("Pickup")
	item.reparent($CarryingPosition, false)
	item.position = Vector3.ZERO
	currently_carrying = item
	print("Picked up ", currently_carrying)

var action_was_down: bool = false

func _get_action_name(base: String) -> String:
	return "%s_%d" % [base, player_id]

func _get_move_input() -> Vector2:
	if device_id >= 0 and Input.is_joy_known(device_id):
		var x = Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X)
		var y = Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y)
		return Vector2(x, y)
	return Input.get_vector(_get_action_name("left"), _get_action_name("right"), _get_action_name("up"), _get_action_name("down"))

func _is_dash_pressed() -> bool:
	if device_id >= 0 and Input.is_joy_known(device_id):
		return Input.is_joy_button_pressed(device_id, JOY_BUTTON_A) and %DashTimer.is_stopped()
	return Input.is_action_just_pressed(_get_action_name("dash")) and %DashTimer.is_stopped()

func _is_action_pressed() -> float:
	if device_id >= 0 and Input.is_joy_known(device_id):
		if Input.is_joy_button_pressed(device_id, JOY_BUTTON_X):
			return 1.0
		return 0.0
	return Input.get_action_strength(_get_action_name("action"))

func _process(_delta: float) -> void:
	var action_input = _is_action_pressed()
	var action_is_down: bool = action_input > 0.5

	is_attempting_action = action_is_down and not action_was_down

	action_was_down = action_is_down


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Dash input -> use %DashTimer as cooldown only
	if _is_dash_pressed():
		%DashTimer.start()
		dash_active_time = DASH_ACTIVE_DURATION
		var forward = - transform.basis.z
		forward.y = 0
		forward = forward.normalized()
		velocity.x = forward.x * DASH_SPEED
		velocity.z = forward.z * DASH_SPEED

	var direction: Vector3 = Vector3.ZERO
	if dash_active_time > 0.0:
		# Active dash phase
		dash_active_time -= delta
		var forward = - transform.basis.z
		forward.y = 0
		forward = forward.normalized()
		velocity.x = forward.x * DASH_SPEED
		velocity.z = forward.z * DASH_SPEED
		direction = forward
	else:
		# Normal movement
		var input_dir := _get_move_input()
		var camera_forward = -%MainSceneCamera.global_transform.basis.z
		var camera_right = %MainSceneCamera.global_transform.basis.x
		camera_forward.y = 0
		camera_right.y = 0
		camera_forward = camera_forward.normalized()
		camera_right = camera_right.normalized()
		if input_dir.length() > 0:
			direction = (camera_right * input_dir.x + camera_forward * -input_dir.y).normalized()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	if not direction.is_zero_approx():
		transform.basis = Basis.looking_at(direction)
		if dash_active_time > 0.0:
			# TODO: animation_player.play("Dash")
			pass
		else:
			animation_player.play("WalkCycle")
	else:
		animation_player.play("Idle")
	move_and_slide()
