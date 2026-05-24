@tool
extends MarginContainer


func currency_to_string(c) -> String:
	match c:
		global.Currency.POOP:
			return "P"
		global.Currency.DNA:
			return "D"
		global.Currency.FOOD:
			return "F"
		_:
			assert(false)
			return ""



@export_multiline var title: String = "FILL ME IN"
@export_multiline var desc: String = "FILL ME IN"
@export var cost: float = 0.0
@export var currency = global.Currency.POOP

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	%Tooltip.visible = true
	%Tooltip.reset_size()
	await get_tree().process_frame
	%Tooltip.visible = false

func _process(_delta: float) -> void:
	%Label.text = "- %s" % title
	%Button.text = "%d %s" % [cost, currency_to_string(currency)]
	%Desc.text = desc # description
	%CostProg.text = "0/%d %s" % [cost, currency_to_string(currency)]

	if Engine.is_editor_hint(): 
		return
	%CostProg.text = "%s/%d %s" % [str(global.Get_Currency_Amount(currency)), cost, currency_to_string(currency)]



func _on_hover(control: Control) -> void:
	%Tooltip.visible = true
	#
	%Tooltip.reset_size()
	%Tooltip.force_update_transform()
	#
	%Tooltip.global_position.x = control.get_global_rect().end.x + 16
	%Tooltip.global_position.y = control.get_global_rect().position.y

	if %Tooltip.get_global_rect().end.x > get_viewport().size.x:
		#%Tooltip.global_position.x = control.get_global_rect().position.x - %Tooltip.get_size().x - 8
		%Tooltip.global_position.x = control.get_global_rect().position.x - %Tooltip.size.x - 8
	#
	%Tooltip.force_update_transform()
	#
	if %Tooltip.get_global_rect().end.y > get_viewport().size.y:
		var overhang = %Tooltip.get_global_rect().end.y - get_viewport().size.y
		%Tooltip.global_position.y -= overhang + 8

	%Tooltip.reset_size()

func _on_main_row_mouse_entered() -> void:
	_on_hover(%Label)

func _on_main_row_mouse_exited() -> void:
	%Tooltip.visible = false

func _on_button_mouse_entered() -> void:
	_on_hover(%Button)

func _on_button_mouse_exited() -> void:
	%Tooltip.visible = false


func Can_Click():
	if Engine.is_editor_hint(): 
		return false
	if global.Get_Currency_Amount(currency) >= cost:
		return true
	else:
		return false

func Upgrade():
	if Engine.is_editor_hint(): 
		return false
	# consume currency and update new cost based on Dict?
	global.Change_Currency_Amount(currency, -cost)
	# Update to new cost here
