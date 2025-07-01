extends CanvasLayer

##################################################
var object_pool_size_label_node: Label

##################################################
func _ready() -> void:
	object_pool_size_label_node = $MarginContainer/VBoxContainer/ObjectPoolSizeLabel

##################################################
func _process(delta: float) -> void:
	object_pool_size_label_node.text = "Object Pool Size: " + str(OP.get_bullet_pool_size())
