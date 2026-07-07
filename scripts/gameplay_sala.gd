extends Node2D

@export var tempo_de_jogo: float = 60.0
@export_range(0, 12) var relogio_hora = 8
@export_range(0, 30, 30) var relogio_minuto = 0
@export var horario_label: Label
@export var segundos_mudar_horario = 30
@export var nivel_atual = 1 #todo

@onready var itens_selecionaveis: Array[Node] = $ItensSelecionaveis.get_children()
@export var ids_itens_ja_selecionaveis: Array[int] = []

@onready var timer_geral: Timer = $TimerGeral
@onready var timer_relogio: Timer = $TimerRelogio
@onready var timer_sujeira: Timer = $TimerTarefas
@onready var sprite_jogador: Sprite2D = $SpriteInicialJogador #criar um estado?

func _ready():
	timer_geral.start(tempo_de_jogo)
	timer_relogio.start(segundos_mudar_horario)
	timer_sujeira.start()
	for id in ids_itens_ja_selecionaveis:
		itens_selecionaveis[id].sujar()

func parar_todos_timers():
	timer_geral.paused = true
	timer_relogio.paused = true
	timer_sujeira.paused = true

func resumir_todos_timers():
	timer_geral.paused = false
	timer_relogio.paused = false
	timer_sujeira.paused = false

func _on_timer_relogio_timeout() -> void:
	relogio_minuto += 30
	if relogio_minuto == 60:
		relogio_minuto = 0
		relogio_hora = wrapi(relogio_hora + 1, 0, 24)
	horario_label.text = "%02d:%02dh" % [relogio_hora, relogio_minuto]

func _on_timer_geral_timeout() -> void:
	print('parando o jogo')
	parar_todos_timers()

func _on_timer_tarefas_timeout() -> void:
	#criar delay para item ser selecionavel novamente?
	var itens_sem_acao = itens_selecionaveis.filter(func(item): return not item.is_precisa_interagir)
	print(itens_sem_acao)
	if itens_sem_acao.size() > 0:
		itens_sem_acao.pick_random().sujar()
