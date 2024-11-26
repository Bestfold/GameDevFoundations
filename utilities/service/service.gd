extends Node
class_name Service

# Delayed set signal
func set_delayed(target, propertyName: String, delay: float, value):
	get_tree().create_timer(delay, false).connect("timeout", target.set.bind(propertyName, value))

# Delayed call-signal
func call_delayed(callable: Callable, delay: float):
	get_tree().create_timer(delay, false).connect("timeout", callable)
