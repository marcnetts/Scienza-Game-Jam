extends Camera2D

@export var amplitude_y: float = 8.0
@export var velocidade_y: float = 0.7
@export var amplitude_x: float = 2.0
@export var velocidade_x: float = 0.2

var pocicao_base: Vector2

func _ready():
	pocicao_base = position

func _process(delta):
	var onda_x = sin(Time.get_ticks_msec() / 1000.0 * velocidade_x) 
	position.x = pocicao_base.x + (onda_x * amplitude_x)
	var onda_y = sin(Time.get_ticks_msec() / 1000.0 * velocidade_y) 
	position.y = pocicao_base.y + (onda_y * amplitude_y)
