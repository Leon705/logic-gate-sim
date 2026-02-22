# autoload
extends Node

signal registry_updated;

static var registry: Dictionary = {};

func load_definitions(path: String = "res://gate_definition/"):
	if !DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_recursive_absolute(path);
		
	var dir = DirAccess.open(path);
	if dir:
		dir.list_dir_begin();
		var file_name = dir.get_next();
		while file_name != "":
			if file_name.ends_with(".tres"):
				var res = load(path + file_name) as GateDefinition;
				registry[res.type_id] = res;
			file_name = dir.get_next();
	registry_updated.emit()

func load_definitions_from_manifest(path: String = "res://gate_manifest.txt"):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		if not content.is_empty():
			var paths = content.split(",")
			for p in paths:
				var res = load(p) as GateDefinition
				if res:
					registry[res.type_id] = res
	registry_updated.emit()

func create_gate(type_id: String) -> BaseGate:
	var def = registry[type_id];
	var gate = def.gate_script.new();
	
	gate.num_inputs = def.num_inputs;
	gate.num_outputs = def.num_outputs;
	gate.title = def.title;

	return gate;
