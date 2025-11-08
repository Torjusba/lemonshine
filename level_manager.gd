extends Node3D

@onready var score_label: Label = $CanvasLayer/ScoreLabel

var current_money: int = 0;

func add_payment(money: int) -> void:
	current_money += money
	score_label.text = "$" + str(current_money)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
