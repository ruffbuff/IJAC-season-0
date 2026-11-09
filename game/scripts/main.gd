extends Node
# Оболочка IJAC: держит панель истории и загружает выбранную версию игры
# внутрь узла World. Сами версии — отдельные сцены в res://scenes/versions/.
#
# Клавиши: H — показать/скрыть историю, F11 — полный экран, Esc — выход.

const VERSIONS_PATH := "res://data/versions.json"
const HistoryPanel := preload("res://scripts/history_panel.gd")

var _data: Dictionary = {}
var _panel: CanvasLayer

@onready var _world: Node3D = $World


func _ready() -> void:
	_data = _load_versions()
	_panel = HistoryPanel.new()
	add_child(_panel)
	_panel.version_selected.connect(open_version)
	_panel.setup(_data)
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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode == KEY_F11:
			_toggle_fullscreen()


func _toggle_fullscreen() -> void:
	var mode := DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
