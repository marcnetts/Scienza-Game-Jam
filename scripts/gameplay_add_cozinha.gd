extends Node2D

@export var gameplay_node: GameplayPointClick
@export var cena_apos_gameplay: String
var tarefas_concluidas: int = 0

func _ready():
	gameplay_node.gameplay_comecou.connect(comeco_gameplay)
	gameplay_node.tarefa_concluida.connect(tarefa_concluida)
	gameplay_node.gameplay_terminou.connect(apos_gameplay)

func comeco_gameplay():
	gameplay_node.pausar_todos_timers()

func tarefa_concluida():
	tarefas_concluidas += 1
	match tarefas_concluidas:
		1:
			gameplay_node.timer_sujeira.wait_time = 3.0
			gameplay_node.timer_sujeira.paused = false
			gameplay_node.timer_sujeira.start()
		5:
			gameplay_node.timer_sujeira.wait_time = 2.0
		10:
			gameplay_node.falar_jogador('Mais ainda?')
			gameplay_node.timer_sujeira.wait_time = 0.5
		20:
			gameplay_node._on_timer_geral_timeout()
		_:
			pass

func apos_gameplay():
	gameplay_node.falar_jogador('Ufa! Chegou a hora do almoço.')
	gameplay_node.animation_player.play('mostrar_interface_cozinha')
