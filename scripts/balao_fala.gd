class_name BalaoFala
extends MarginContainer

@onready var texto_fala: RichTextLabel = $MarginContainer/TextoFala
@onready var timer: Timer = $Timer

@export var texto_incical: String
@export var tempo_timer: float = 3.0

func _ready() -> void:
	self.visible = false
	if texto_incical:
		mostrar_texto(texto_incical)

func mostrar_texto(texto: String, tempo_timer_funcao: float = 0):
	self.visible = true
	texto_fala.text = texto
	timer.start(tempo_timer_funcao if tempo_timer_funcao else tempo_timer)
	await timer.timeout
	self.visible = false
