class_name GameplayPointClick
extends Node2D

@export var tempo_de_jogo: float = 60.0
@export_range(0, 23) var relogio_hora = 8
@export_range(0, 30, 30) var relogio_minuto = 0
@export var segundos_mudar_horario: float = 30.0
@export var nivel_atual: int = 1 #todo
@export var is_continuar_sujando_final_jogo: bool = false
@export var fala_inicial: String

var itens_selecionaveis: Array[ItemSelecionavel]
var itens_sempre_selecionaveis: Array[ItemSelecionavel]
@export var ids_itens_ja_selecionaveis: Array[int] = []

@onready var timer_geral: Timer = $TimerGeral
@onready var timer_relogio: Timer = $TimerRelogio
@onready var timer_sujeira: Timer = $TimerTarefas
@onready var jogador: Jogador = $Jogador
@onready var label_horario: RichTextLabel = $Interface/LabelHorario
@onready var label_dica: RichTextLabel = $Interface/LabelDica
@onready var transicao_cena: ColorRect = $Interface/TransicaoCena
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var interagiu_primeira_vez: bool = false
signal gameplay_comecou
signal tarefa_concluida
signal gameplay_terminou

func _ready():
	if transicao_cena and animation_player:
		animation_player.play("fade_out_black")
		animation_player.advance(0)
		transicao_cena.visible = true
		await animation_player.animation_finished
		transicao_cena.visible = false
	
	if(tempo_de_jogo):
		timer_geral.start(tempo_de_jogo)
	if(segundos_mudar_horario):
		timer_relogio.start(segundos_mudar_horario)
	if timer_sujeira:
		timer_sujeira.start()
	
	for child in $ItensSelecionaveis.get_children():
		if is_instance_of(child, ItemSelecionavel):
			child.jogador_falando.connect(falar_jogador)
			child.tarefa_concluida.connect(validar_interacao_jogador)
			itens_selecionaveis.append(child)
	for child in $ItensSempreSelecionaveis.get_children():
		if is_instance_of(child, ItemSelecionavel):
			child.jogador_falando.connect(falar_jogador)
	for id in ids_itens_ja_selecionaveis:
		itens_selecionaveis[id].sujar()
	
	if fala_inicial:
		falar_jogador(fala_inicial)
	
	gameplay_comecou.emit()

func pausar_todos_timers():
	timer_geral.paused = true
	timer_relogio.paused = true
	timer_sujeira.paused = true

func resumir_todos_timers():
	timer_geral.paused = false
	timer_relogio.paused = false
	timer_sujeira.paused = false

func falar_jogador(fala: String):
	if jogador:
		jogador.mostrar_fala(fala)

func validar_interacao_jogador():
	tarefa_concluida.emit()
	label_dica.visible = false

func _on_timer_relogio_timeout() -> void:
	relogio_minuto += 30
	if relogio_minuto == 60:
		relogio_minuto = 0
		relogio_hora = wrapi(relogio_hora + 1, 0, 24)
	label_horario.text = "%02d:%02dh" % [relogio_hora, relogio_minuto]

func _on_timer_geral_timeout() -> void:
	if timer_relogio.time_left < 0.1:
		timer_relogio.timeout.emit()
	for item in itens_selecionaveis:
		item.concluir_limpeza()
	pausar_todos_timers()
	gameplay_terminou.emit()

func _on_timer_tarefas_timeout() -> void:
	var itens_sem_acao = itens_selecionaveis.filter(func(item): return (
		not item.is_precisa_interagir
		and item.timer_item_nao_selecionavel.is_stopped()
		and (is_continuar_sujando_final_jogo or (timer_geral.time_left > item.tempo_limpeza + 1.5))
	))
	if itens_sem_acao.size() > 0:
		itens_sem_acao.pick_random().sujar()

func _on_button_proxima_cena_pressed(cena: String) -> void:
	if transicao_cena and animation_player:
		transicao_cena.visible = true
		animation_player.play("fade_in_black")
		await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/%s.tscn" % cena)
