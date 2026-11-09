extends CanvasLayer
# Боковая панель: ACTUAL (текущая утверждённая версия) + Timeline всех версий.
# UI строится кодом, чтобы не плодить хрупкие .tscn.

signal version_selected(version_id: String)

var _data: Dictionary = {}
var _active_id := ""
var _buttons: Dictionary = {}
var _group := ButtonGroup.new()
var _panel: PanelContainer
var _detail: Label
var _hidden_hint: Label


func _init() -> void:
	layer = 10


func setup(data: Dictionary) -> void:
	_data = data
	_build()


func set_active(version_id: String) -> void:
	_active_id = version_id
	if _buttons.has(version_id):
		(_buttons[version_id] as Button).set_pressed_no_signal(true)
	_update_detail()


func _build() -> void:
	_panel = PanelContainer.new()
	_panel.anchor_left = 0.0
	_panel.anchor_right = 0.0
	_panel.anchor_top = 0.0
	_panel.anchor_bottom = 1.0
	_panel.offset_left = 16
	_panel.offset_right = 336
	_panel.offset_top = 16
	_panel.offset_bottom = -16
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.07, 0.07, 0.09, 0.85)
	sb.set_corner_radius_all(10)
	sb.set_content_margin_all(14)
	_panel.add_theme_stylebox_override("panel", sb)
	add_child(_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	_panel.add_child(box)

	var title := Label.new()
	title.text = "IJAC"
	title.add_theme_font_size_override("font_size", 30)
	box.add_child(title)

	var sub := Label.new()
	sub.text = "It's Just a Cube  -  %s" % str(_data.get("season_title", "Season"))
	sub.add_theme_font_size_override("font_size", 13)
	sub.modulate = Color(1, 1, 1, 0.6)
	box.add_child(sub)

	box.add_child(HSeparator.new())

	var current_id := str(_data.get("current", ""))
	var actual := Button.new()
	actual.text = "ACTUAL  >  %s" % current_id
	actual.focus_mode = Control.FOCUS_NONE
	actual.custom_minimum_size = Vector2(0, 40)
	actual.pressed.connect(func(): version_selected.emit(current_id))
	box.add_child(actual)

	var tl := Label.new()
	tl.text = "TIMELINE"
	tl.add_theme_font_size_override("font_size", 13)
	tl.modulate = Color(1, 1, 1, 0.6)
	box.add_child(tl)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)

	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 4)
	scroll.add_child(list)

	var versions: Array = _data.get("versions", [])
	for i in range(versions.size() - 1, -1, -1):  # новые сверху
		var v: Dictionary = versions[i]
		var vid := str(v.get("id", ""))
		var b := Button.new()
		b.toggle_mode = true
		b.button_group = _group
		b.focus_mode = Control.FOCUS_NONE
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.custom_minimum_size = Vector2(0, 32)
		var tag := "  [demo]" if str(v.get("status", "")) == "demo" else ""
		b.text = "%s   %s%s" % [vid, str(v.get("title", "")), tag]
		b.pressed.connect(func(): version_selected.emit(vid))
		list.add_child(b)
		_buttons[vid] = b

	box.add_child(HSeparator.new())

	_detail = Label.new()
	_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail.custom_minimum_size = Vector2(0, 130)
	_detail.add_theme_font_size_override("font_size", 14)
	box.add_child(_detail)

	var hint := Label.new()
	hint.text = "H hide   F11 fullscreen   Esc quit"
	hint.add_theme_font_size_override("font_size", 12)
	hint.modulate = Color(1, 1, 1, 0.45)
	box.add_child(hint)

	_hidden_hint = Label.new()
	_hidden_hint.text = "H - history"
	_hidden_hint.position = Vector2(16, 12)
	_hidden_hint.modulate = Color(1, 1, 1, 0.45)
	_hidden_hint.visible = false
	add_child(_hidden_hint)


func _update_detail() -> void:
	if _detail == null:
		return
	for v in _data.get("versions", []):
		if v is Dictionary and v.get("id", "") == _active_id:
			var status := "DEMO (simulated, not a real community PR)" if str(v.get("status", "")) == "demo" else str(v.get("status", ""))
			var is_current := "  (current)" if _active_id == str(_data.get("current", "")) else ""
			_detail.text = "%s - %s%s\n%s\n\nAuthor: %s\nDate: %s\nStatus: %s" % [
				_active_id, str(v.get("title", "")), is_current,
				str(v.get("summary", "")), str(v.get("author", "")),
				str(v.get("date", "")), status]
			return


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_H:
		_panel.visible = not _panel.visible
		_hidden_hint.visible = not _panel.visible
