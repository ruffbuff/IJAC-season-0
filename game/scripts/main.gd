extends Node
# Оболочка IJAC: держит панель истории и загружает выбранную версию игры
# внутрь узла World. Сами версии — отдельные сцены в res://scenes/versions/.
#
# Клавиши: H — история, F / F11 — полный экран, Esc — выход (только в exe).
# В вебе: Esc не закрывает игру, полный экран — кнопка справа сверху или клавиша F.

const VERSIONS_PATH := "res://data/versions.json"
const HistoryPanel := preload("res://scripts/history_panel.gd")

var _data: Dictionary = {}
var _panel: CanvasLayer
var _is_web := OS.has_feature("web")

@onready var _world: Node3D = $World


func _ready() -> void:
	# В браузере стартовый полный экран запрещён — стартуем в окне.
	if _is_web and DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	_data = _load_versions()
	_panel = HistoryPanel.new()
	add_child(_panel)
	_panel.version_selected.connect(open_version)
	_panel.setup(_data)
	_build_fullscreen_button()
	open_version(str(_data.get("start", "")))


func open_version(version_id: String) -> void:
	var entry := _find_version(version_id)
	if entry.is_empty():
		push_error("IJAC: unknown version '%s'" % version_id)
		return
	var scene_path := str(entry.get("scene", ""))
	var packed := load(scene_path) as PackedScene
	if packed == null:
		push_error("IJAC: cannot load scene '%s'" % scene_path)
		return
	for child in _world.get_children():
		_world.remove_child(child)
		child.queue_free()
	_world.add_child(packed.instantiate())
	_panel.set_active(version_id)


func _find_version(version_id: String) -> Dictionary:
	for v in _data.get("versions", []):
		if v is Dictionary and v.get("id", "") == version_id:
			return v
	return {}


func _load_versions() -> Dictionary:
	if not FileAccess.file_exists(VERSIONS_PATH):
		push_error("IJAC: %s not found" % VERSIONS_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(VERSIONS_PATH))
	if parsed is Dictionary:
		return parsed
	push_error("IJAC: %s is not valid JSON" % VERSIONS_PATH)
	return {}


func _build_fullscreen_button() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 11
	add_child(layer)
	var b := Button.new()
	b.text = "Fullscreen (F)"
	b.focus_mode = Control.FOCUS_NONE
	b.anchor_left = 1.0
	b.anchor_right = 1.0
	b.anchor_top = 0.0
	b.anchor_bottom = 0.0
	b.offset_left = -176
	b.offset_right = -16
	b.offset_top = 16
	b.offset_bottom = 52
	b.pressed.connect(_toggle_fullscreen)
	layer.add_child(b)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if not _is_web:
				get_tree().quit()
		elif event.keycode == KEY_F11 or event.physical_keycode == KEY_F:
			_toggle_fullscreen()


func _toggle_fullscreen() -> void:
	var mode := DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
