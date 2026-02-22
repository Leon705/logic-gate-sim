@tool
extends Node

func _ready() -> void:
	if Engine.is_editor_hint():
		generate_manifest();

func generate_manifest():
	var gates = []
	var dir = DirAccess.open("res://gate_definition/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				gates.append("res://gate_definition/" + file_name)
			file_name = dir.get_next()
		
		var file = FileAccess.open("res://gate_manifest.txt", FileAccess.WRITE)
		file.store_string(",".join(gates))
		print("Manifest successfully generated!")
