class_name OrGate
extends BaseGate

func _compute(inputs: Array[bool]) -> bool:
	return inputs[0] or inputs[1];
