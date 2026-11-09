extends Node3D
# s0-v002 — "Jump" (ДЕМО-версия, симуляция PR-002)
# WASD — движение (как в v001), Пробел — прыжок с гравитацией.

@export var speed := 6.0
@export var follow_smoothing := 8.0
@export var jump_speed := 8.0
@export var gravity := 22.0

const GROUND_Y := 1.0  # центр куба на полу (куб 2x2x2)

var _vy := 0.0

@onready var _rig: Node3D = get_node("../CameraRig")


func _process(delta: float) -> void:
	var input := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W):
		input.y += 1.0
	if Input.is_physical_key_pressed(KEY_S):
		input.y -= 1.0
	if Input.is_physical_key_pressed(KEY_D):
		input.x += 1.0
	if Input.is_physical_key_pressed(KEY_A):
		input.x -= 1.0

	if input != Vector2.ZERO:
		input = input.normalized()
		var yaw := _rig.rotation.y
		var forward := Vector3(-sin(yaw), 0.0, -cos(yaw))
		var right := Vector3(cos(yaw), 0.0, -sin(yaw))
		position += (forward * input.y + right * input.x) * speed * delta

	var grounded := position.y <= GROUND_Y + 0.001
	if grounded and Input.is_physical_key_pressed(KEY_SPACE):
		_vy = jump_speed
	_vy -= gravity * delta
	position.y += _vy * delta
	if position.y <= GROUND_Y:
		position.y = GROUND_Y
		_vy = 0.0

	var t := 1.0 - exp(-follow_smoothing * delta)
	_rig.position.x = lerpf(_rig.position.x, position.x, t)
	_rig.position.z = lerpf(_rig.position.z, position.z, t)
