class_name NotGate
extends BaseGate

func _ready() -> void:
	super();
	
func _add_follower(out_port: int, target_node: BaseGate, in_port: int) -> void:
	super(out_port, target_node, in_port);
	_process_logic();

func _compute(inputs: Array[bool]) -> bool:
	return !inputs[0];
