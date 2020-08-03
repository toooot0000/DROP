extends ViewportContainer
class_name SlideContainer

var slide_viewport:SlideViewport

func _ready():
	if slide_viewport:
		slide_viewport.is_working = false


func _on_SlideContainer_mouse_entered():
	if slide_viewport:
		slide_viewport.is_working = true
	pass


func _on_SlideContainer_mouse_exited():
	if slide_viewport:
		slide_viewport.is_working = false
	pass

func _on_SlideContainer_hide():
	if slide_viewport:
		slide_viewport.gui_disable_input = true
	pass


func _on_SlideContainer_visibility_changed():
	if visible:
		if slide_viewport:
			slide_viewport.gui_disable_input = false
	pass
