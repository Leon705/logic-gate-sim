class_name Main
extends Control

@onready var graph_edit: Editor = $GraphEdit;
@onready var ui_overlay_container: Control = $UiOverlayContainer;

const gate_creator_scene: PackedScene = preload("res://gate_creator/gate_creator.tscn");

var should_render_overlay: bool = true;

func _ready() -> void:
	GateFactory.load_definitions_from_manifest();
	GateFactory.load_definitions("user://gates/");

func _handle_gate_creator() -> void:
	graph_edit.hide();
	ui_overlay_container.hide();
	
	var instance: GateCreator = gate_creator_scene.instantiate();
	add_child(instance);
	await instance.closed;
	instance.queue_free();
	
	graph_edit.show();
	ui_overlay_container.visible = should_render_overlay;
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("gate_creator") and graph_edit.visible:
			_handle_gate_creator();
		if event.is_action_pressed("toggle_info"):
			should_render_overlay =! should_render_overlay;
			ui_overlay_container.visible = should_render_overlay;

func save_project(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.WRITE);
	var json = graph_edit.to_json();
	file.store_string(json);
	file.close();

func load_project(file_path: String):
	if not FileAccess.file_exists(file_path): return;

	var file = FileAccess.open(file_path, FileAccess.READ);
	var json = file.get_as_text();
	file.close();
	
	graph_edit.load_json(json);
