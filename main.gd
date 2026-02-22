class_name Main
extends Control

@onready var graph_edit: GraphEdit  = $GraphEdit;
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
