extends Node2D

@export var gameplay_node: Node2D
@export var cena_apos_gameplay: String

func _ready():
	print(gameplay_node.gameplay_terminou)
	gameplay_node.gameplay_terminou.connect(apos_gameplay)

func apos_gameplay():
	await get_tree().create_timer(2).timeout
	gameplay_node._on_button_proxima_cena_pressed(cena_apos_gameplay)
