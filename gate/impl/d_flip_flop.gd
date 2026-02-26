extends BaseGate
class_name DFlipFlop

var master_state: bool = false
var last_clock: bool = false

func _compute(inputs: Array[bool]) -> bool:
	var d = inputs[0]
	var clk = inputs[1]
	
	if clk and not last_clock:
		master_state = d
	
	last_clock = clk
	return master_state
