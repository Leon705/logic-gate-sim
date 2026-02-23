class_name Main
extends Control

@onready var graph_edit: Editor  = $GraphEdit;
const gate_creator_scene: PackedScene = preload("res://gate_creator/gate_creator.tscn");

func _ready() -> void:
	GateFactory.load_definitions_from_manifest();
	GateFactory.load_definitions("user://gates/");

func _handle_gate_creator() -> void:
	graph_edit.hide();
	var instance: GateCreator = gate_creator_scene.instantiate();
	add_child(instance);
	await instance.closed;
	instance.queue_free();
	graph_edit.show();

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action("gate_creator") and graph_edit.visible:
			_handle_gate_creator();

func save_project(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.WRITE);
	var json = graph_edit.to_json();
	file.store_string(json);
	file.close();

#func load_project(file_path: String):
	#if not FileAccess.file_exists(file_path): return;
#
	#var file = FileAccess.open(file_path, FileAccess.READ);
	#var data = JSON.parse_string(file.get_as_text());
	#file.close();
	#
	#for node in data["nodes"]:
		#var gate = GateFactory.create_gate(node["type"]);
		#if node["script_path"].begins_with("user://"):
			#var custom_script = load(node["script_path"]);
			#gate.set_script(custom_script);
		#gate.name = node["name"];
		#graph_edit.add_child(gate);
		#gate.position_offset = Vector2(node["pos_x"], node["pos_y"]);
		#
	#for c in data["connections"]:
		#graph_edit._on_connection_request(c["from_node"], c["from_port"], c["to_node"], c["to_port"]);
