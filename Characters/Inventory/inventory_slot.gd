extends Control

# Scene-Tree node references
# TODO: I believe it seems whatever sets the icon here is what goes to inventory
@onready var icon = $ItemBorderPurp/ItemIcon
@onready var quantity_label = $ItemBorderPurp/Quantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var assign_button = $UsagePanel/AssignButton

# signals
signal drag_start(slot)
signal drag_end()

# Slot item
var item = null
var slot_index = -1
var is_assigned = false

# Set Index
func set_slot_index(new_index):
	slot_index = new_index


func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true


func _on_item_button_mouse_exited():
	details_panel.visible = false

# Default empty slot
func set_empty():
	icon.texture = null
	quantity_label.text = ""

# TODO: Figure out how to set the frame to what the icon is in the scene
# Setting the frame to 20 works but how do i find the same as in the item script
func set_item(new_item):
	#print("Setting Item", new_item)
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str("+", item["effect"])
	else:
		item_effect.text = ""
	update_assignment_status()


func _on_drop_button_pressed():
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 50)
		drop_offset = drop_offset.rotated(Global.player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["type"], item["effect"])
		Global.remove_hotbar_item(item["type"], item["effect"])
		usage_panel.visible = false


func _on_use_button_pressed():
	usage_panel.visible = false
	if item != null and item["effect"] != "":
		if Global.player_node:
			Global.player_node.apply_item_effect(item)
			Global.remove_item(item["type"], item["effect"])
			Global.remove_hotbar_item(item["type"], item["effect"])
		else:
			print("Player could not be found")


func update_assignment_status():
	is_assigned = Global.is_item_assigned_to_hotbar(item)
	if is_assigned:
		assign_button.text = "Unassign"
	else:
		assign_button.text = "Assign"

# TODO: make it so the icon is removed when assigned
func _on_assign_button_pressed():
	if item != null:
		if is_assigned:
			Global.unassign_hotbar_item(item["type"], item["effect"])
			is_assigned = false
		else:
			Global.add_item(item, true)
			is_assigned = true
		update_assignment_status()


func _on_item_button_gui_input(event):
	if event is InputEventMouseButton:
		# Usage panel
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if item != null:
				usage_panel.visible = !usage_panel.visible
				# Dragging Item
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				# Would have to have a outer border than add the variable up top
				# This changes color though
				# outer_border.modulate = Color(1, 1, 0)
				drag_start.emit(self)
			else:
				# outer_border.modulate = Color(1, 1, 1)
				drag_end.emit()
		
