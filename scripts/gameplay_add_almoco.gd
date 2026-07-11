extends Node2D

@export var gameplay_node: GameplayPointClick
@export var marker_txt_almoco: Marker2D
@export var botao_almoco: Button
var tarefas_concluidas: int = 0
const APPEARING_TEXT_LABEL = preload("uid://b03lgibfar4xb")

func _ready():
	gameplay_node.gameplay_comecou.connect(comeco_gameplay)
	#gameplay_node.tarefa_concluida.connect(tarefa_concluida)
	gameplay_node.gameplay_terminou.connect(apos_gameplay)

func comeco_gameplay():
	gameplay_node.pausar_todos_timers()

func apos_gameplay():
	botao_almoco.disabled = true
	gameplay_node.falar_jogador('Round 2 agora de tarde.')
	gameplay_node.animation_player.play('mostrar_interface_cozinha')

func _on_item_selecionavel_tarefa_concluida() -> void:
	print(tarefas_concluidas)
	tarefas_concluidas += 1
	if tarefas_concluidas == 5:
		gameplay_node._on_timer_geral_timeout()


func _on_button_almoco_pressed() -> void:
	var text = APPEARING_TEXT_LABEL.instantiate() as RichTextLabel
	text.add_theme_font_size_override("normal_font_size", 24)
	text.global_position = marker_txt_almoco.position
	text.add_text('+1 Garfada')
	get_tree().current_scene.add_child(text)
	_on_item_selecionavel_tarefa_concluida()
