extends Node3D
# s0-v001 — "Movement" (ДЕМО-версия, симуляция PR-001)
# WASD двигает куб относительно направления камеры. Камера следует за кубом.

@export var speed := 6.0
@export var follow_smoothing := 8.0

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

	var t := 1.0 - exp(-follow_smoothing * delta)
	_rig.position.x = lerpf(_rig.position.x, position.x, t)
	_rig.position.z = lerpf(_rig.position.z, position.z, t)
