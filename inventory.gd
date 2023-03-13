extends Control

@onready var list := $ItemList
@onready var trash_list := $ItemListTrash
@onready var label := $Label

var protoset : ItemProtoset
var inventory : InventoryStacked
var trash : InventoryStacked
var selected_item : InventoryItem

func _ready():
	protoset = ItemProtoset.new()
	inventory = InventoryStacked.new()
	trash = InventoryStacked.new()
	
#	protoset.json_data = '
#		[
#			{
#				"id": "weapon",
#				"name": "Katana",
#				"damage": 29,
#				"stack_size": 1,
#				"max_stack_size": 10,
#				"weight": 0
#			}
#		]
#	'
	
	inventory.item_protoset = protoset

	$".".add_child(inventory)

	for i in range(15):
		var item = InventoryItem.new()
		item.protoset = protoset
		item.prototype_id = 'weapon'
		item.set_property('name', 'katana')
		inventory.add_item_automerge(item)
	
	reset()

func reset():
	list.clear()
	trash_list.clear()
	for item in inventory.get_items():
		list.add_item(item.get_property('name') + " " + str(item.get_property('stack_size')))
		list.set_item_metadata(list.item_count - 1, item)
	for item in trash.get_items():
		trash_list.add_item(item.get_property('name') + " " + str(item.get_property('stack_size')))
		trash_list.set_item_metadata(list.item_count - 1, item)


func _on_button_pressed():
	var item = InventoryItem.new()
	item.protoset = protoset
	item.prototype_id = 'weapon'
	item.set_property('name', 'katana')
	inventory.add_item_automerge(item)
	reset()


func _on_button_2_pressed():
	var new_item = inventory.split(selected_item, 1)
	trash.add_item_automerge(new_item)
	reset()

func _on_item_list_item_selected(index):
	selected_item = list.get_item_metadata(index)
	label.text = str(list.get_item_metadata(index).serialize())
