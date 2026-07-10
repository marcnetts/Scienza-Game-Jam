extends Node2D

@export var gameplay_node: Node2D
@export var cena_apos_gameplay: String
@onready var button_proxima_cena: Button = $"../Interface/ButtonProximaCena"

func _ready() -> void:
	button_proxima_cena.visible = true
