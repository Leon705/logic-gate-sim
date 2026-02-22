extends GraphNode 
class_name BaseGate

var followers: Dictionary = {}; # {output_port: []}
var output_state: bool = false;
var input_states: Array[bool] = [];

var num_inputs: int = 0;
var num_outputs: int = 0;

func _init(p_in: int = 2, p_out: int = 1) -> void:
	num_inputs = p_in;
	num_outputs = p_out;

func _ready() -> void:
	_setup_slots();
	
func _compute(_inputs: Array[bool]) -> bool:
	return false;

func _set_input_value(port_idx: int, value: bool) -> void:
	if port_idx < input_states.size():
		input_states[port_idx] = value;
		_process_logic();
		
func _process_logic():
	var new_output = _compute(input_states);
	if new_output != output_state:
		output_state = new_output;
		_propagate_signal();
		_update_visuals();
		
func _propagate_signal() -> void: 
	if followers.has(0):
		for next in followers[0]:
			var node = next.node as BaseGate; 
			if is_instance_valid(node):
				node._set_input_value(next.port, output_state);

func _add_follower(out_port: int, target_node: BaseGate, in_port: int) -> void:
	if not followers.has(out_port):
		followers[out_port] = [];
	followers[out_port].append({"node": target_node, "port": in_port });
	
func _remove_follower(out_port: int, target_node: BaseGate, in_port: int) -> void:
	if followers.has(out_port):
		followers[out_port] = followers[out_port].filter(
			func(f):
				return f.node != target_node or f.port != in_port
		);

func _get_slot_ui_component(_idx: int) -> Control:
	var component = Control.new();
	component.custom_minimum_size.y = 20;
	component.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	return component;

func _setup_slots():
	var rows = max(num_inputs, num_outputs);
	for i in range(rows):
		var spacer = _get_slot_ui_component(i);
		add_child(spacer);
		
		var in_active = i < num_inputs;
		var out_active = i < num_outputs;
		set_slot(i, in_active, 0, Color.WHITE, out_active, 0, Color.RED);
		if in_active:
			input_states.append(false);
		
func _update_visuals():
	pass;
