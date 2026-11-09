extends Node3D
# Орбитальная камера вокруг куба.
# Мышь: зажать ЛКМ или ПКМ и двигать — вращение. Колесо — приближение/отдаление.
# Стрелки на клавиатуре — тоже вращают. Дочерний Camera3D смотрит в центр рига.

@export var rotate_speed := 0.005
@export var key_speed := 1.6
@export var zoom_factor := 0.9
@export var min_distance := 3.5
@export var max_distance := 30.0
@export var min_pitch_deg := -85.0
@export var max_pitch_deg := -4.0
@export var smoothing := 14.0

var _yaw := 0.0
var _pitch := 0.0
var _distance := 9.0

@onready var _camera: Camera3D = $Camera3D


func _ready() -> void:
	_yaw = rotation.y
	_pitch = rotation.x
	_distance = _camera.position.z


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask & (MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT):
			_yaw -= event.relative.x * rotate_speed
			_pitch -= event.relative.y * rotate_speed
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_distance *= zoom_factor
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_distance /= zoom_factor


func _process(delta: float) -> void:
	var dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT):
		dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT):
		dir.x += 1.0
	if Input.is_key_pressed(KEY_UP):
		dir.y += 1.0
	if Input.is_key_pressed(KEY_DOWN):
		dir.y -= 1.0
	_yaw -= dir.x * key_speed * delta
	_pitch -= dir.y * key_speed * delta

	_pitch = clampf(_pitch, deg_to_rad(min_pitch_deg), deg_to_rad(max_pitch_deg))
	_distance = clampf(_distance, min_distance, max_distance)

	var t := 1.0 - exp(-smoothing * delta)
	rotation.y = lerp_angle(rotation.y, _yaw, t)
	rotation.x = lerpf(rotation.x, _pitch, t)
	_camera.position.z = lerpf(_camera.position.z, _distance, t)
