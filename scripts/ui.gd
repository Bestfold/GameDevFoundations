extends CanvasLayer
class_name DebugUI

# Variable to keep trach of in runtime
@onready var var_1_label: Label = %Var1
@onready var var_2_label: Label = %Var2
@onready var var_3_label: Label = %Var3
@onready var var_4_label: Label = %Var4
@onready var var_5_label: Label = %Var5

var var1 = 0.0:
	set(new_value):
		var1 = new_value
		_update_variable_label(var_1_label, var1)

var var2 = 0.0:
	set(new_value):
		var2 = new_value
		_update_variable_label(var_2_label, var2)

var var3 = 0.0:
	set(new_value):
		var3 = new_value
		_update_variable_label(var_3_label, var3)

var var4 = 0.0:
	set(new_value):
		var4 = new_value
		_update_variable_label(var_4_label, var4)

var var5 = 0.0:
	set(new_value):
		var5 = new_value
		_update_variable_label(var_5_label, var5)



func _update_variable_label(label_to_update: Label, variable_to_updatate):
	label_to_update.text = str(variable_to_updatate)


func _monitored_value_1(value_to_monitor):
	var1 = value_to_monitor

func _monitored_value_2(value_to_monitor):
	var2 = value_to_monitor

func _monitored_value_3(value_to_monitor):
	var3 = value_to_monitor

func _monitored_value_4(value_to_monitor):
	var4 = value_to_monitor

func _monitored_value_5(value_to_monitor):
	var5 = value_to_monitor
