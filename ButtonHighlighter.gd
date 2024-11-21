extends ColorRect

export  var margin: = Vector2(8.0, 0.0)
export  var full_travel_duration: = 1.5

export  var group:ButtonGroup

onready  var tween:Tween = $Tween
onready  var total_width: = get_viewport_rect().size.x
onready  var viewport:Viewport = get_viewport()

var last_btn:Button


func _ready()->void :
	for btn in group.get_buttons():
		btn.connect("focus_entered", self, "_on_btn_focus_entered", [btn])


func _enter_tree()->void :
	get_tree().connect("screen_resized", self, "_on_screen_resized")


func _exit_tree()->void :
	get_tree().disconnect("screen_resized", self, "_on_screen_resized")


func _on_btn_focus_entered(btn:Button):
	focus_button(btn)


func focus_button(btn:Button):
	set_process(true)
	tween.remove_all()
	var duration: = (btn.rect_global_position - rect_global_position).length() / total_width * full_travel_duration
	duration = sin((duration * PI) / 2)
	var pos: = btn.rect_global_position - margin
	var size: = btn.rect_size + 2 * margin
	tween.interpolate_property(self, "rect_global_position", rect_global_position, pos, duration, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.interpolate_property(self, "rect_size", rect_size, size, duration, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
	last_btn = btn


func _update():
	var w: = viewport.get_visible_rect().size.x
	var x1: = rect_global_position.x / w
	var x2: = (get_global_rect().end.x) / w
	for btn in group.get_buttons():
		btn.material.set_shader_param("x1", x1)
		btn.material.set_shader_param("x2", x2)


func _on_screen_resized():
	_update()


func _process(_delta:float)->void :
	_update()
	if not is_visible_in_tree():
		set_process(false)


func _on_locale_changed(_locale:String):
	var btn: = group.get_pressed_button()
	if not btn:
		btn = group.get_buttons()[0]
	focus_button(btn)
	_update()


func _on_Tween_tween_all_completed()->void :
	if (last_btn.rect_global_position - margin) != rect_global_position:
		focus_button(last_btn)
