extends BaseGate
class_name AndGate

func _compute(_inputs: Array[bool]) -> bool:
	return _inputs[0] && _inputs[1];
