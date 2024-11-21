extends Control


var last_menu_index: = 0

onready  var tween: = $Tween
onready  var button_box:BoxContainer = $"%Buttons"
onready  var sub_menus: = $"%TabPage"


func _ready():
	for i in button_box.get_child_count():
		var btn = button_box.get_child(i)
		if btn is Button:
			btn.connect("focus_entered", self, "_on_tab_button_focus_entered", [i])
			
	_on_tab_button_focus_entered(0)
	button_box.get_child(0).grab_focus()


func _on_tab_button_focus_entered(i:int)->void :
	tween.remove_all()
	var prev = sub_menus.get_child(last_menu_index)
	var next = sub_menus.get_child(i)
	prev.hide()
	next.show()
	tween.interpolate_property(next, "modulate", Color.transparent, Color.white, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	last_menu_index = i
