class_name Editor
extends GraphEdit

@onready var context_menu: PopupMenu = $PopupMenu;
var menu_id_to_gate_type: Array[String] = [];

func _ready() -> void:
	connect("connection_request", _on_connection_request);
	connect("disconnection_request", _on_disconnection_request);
	connect("popup_request", _on_popup_request);
	
	GateFactory.load_definitions_from_manifest();
	GateFactory.load_definitions("user://gates/");
	
	GateFactory.registry_updated.connect(_on_registry_updated);
	
	_init_context_menu();
	

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var target = get_node(str(to_node)) as BaseGate;
	
	for connection in get_connection_list_from_node(to_node):
		if connection["to_node"] == to_node and connection["to_port"] == to_port:
			return
	
	var source = get_node(str(from_node)) as BaseGate;
	connect_node(from_node, from_port, to_node, to_port);
	source._add_follower(from_port, target, to_port);
	target._set_input_value(to_port, source.output_state);

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port);
	
	var source = get_node(str(from_node)) as BaseGate;
	var target = get_node(str(to_node)) as BaseGate;
	
	if source and target:
		source._remove_follower(from_port, target, to_port);
		target._set_input_value(to_port, false);
		

func _init_context_menu() -> void:
	var id: int = 0;
	menu_id_to_gate_type.clear();
	
	for def: GateDefinition in GateFactory.registry.values():
		context_menu.add_item(def.type_id, id);
		menu_id_to_gate_type.append(def.type_id);
		id += 1;
		
	if !context_menu.id_pressed.is_connected(_on_context_menu_item_selected):
		context_menu.id_pressed.connect(_on_context_menu_item_selected);

func _on_context_menu_item_selected(id: int) -> void:
	var type_id = menu_id_to_gate_type[id];
	var spawn_pos = (scroll_offset + (context_menu.position as Vector2)) / zoom;
	
	var gate = GateFactory.create_gate(type_id);
	add_child(gate);
	gate.position_offset = spawn_pos;
	
func _on_popup_request(at_position: Vector2) -> void:
	context_menu.position = get_screen_transform().origin + at_position;
	context_menu.popup();
	
func _on_registry_updated() -> void:
	context_menu.clear(true);
	_init_context_menu();
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action("gate_creator"):
		$GateCreator.show();
		
