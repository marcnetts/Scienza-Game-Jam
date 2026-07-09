class_name ItemSelecionavel 
extends Area2D

@export var sprite_inicial: Texture2D
@export var sprite_acao: Texture2D
@export var nome_acao: String = "limpando" #mandar string ou id de index por ação?
@export var tempo_limpeza: float = 3.0
@export var segundos_timer_item_nao_selectionavel: float = 15.0
@export var fala_personagem: String
@export var precisa_segurar_mouse: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var colisao: CollisionShape2D = $CollisionShape2D
@onready var barra_progresso: TextureProgressBar = $TextureProgressBar
@onready var timer_item_nao_selecionavel: Timer = $TimerItemNaoSelecionavel

signal tarefa_concluida
signal jogador_falando(fala)
signal jogador_interagindo(interagindo, acao)

var is_precisa_interagir: bool = false
var is_mouse_por_cima: bool = false
var progresso_atual: float = 0.0

func _ready():
	if sprite_inicial:
		sprite.texture = sprite_inicial
	else:
		sprite_inicial = sprite.texture
	colisao.shape.size = sprite.texture.get_size()
	
	barra_progresso.position.y -= (sprite.texture.get_size().y / 2) + 20
	barra_progresso.visible = false
	barra_progresso.max_value = tempo_limpeza

func _process(delta):
	if is_precisa_interagir and is_mouse_por_cima and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		avancar_limpeza(delta)
	else:
		parar_limpeza()

func sujar():
	is_precisa_interagir = true
	if sprite_acao:
		sprite.texture = sprite_acao
	sprite.modulate = Color(1.5, 1.5, 0.5) #ser glow dps

func avancar_limpeza(delta):
	barra_progresso.visible = true
	progresso_atual += delta
	barra_progresso.value = progresso_atual
	
	jogador_interagindo.emit(true, nome_acao) #mudar dps?

	if progresso_atual >= tempo_limpeza:
		concluir_limpeza()

	if fala_personagem:
		jogador_falando.emit(fala_personagem)

func parar_limpeza():
	barra_progresso.visible = false
	progresso_atual = 0
	jogador_interagindo.emit(false, "")

func concluir_limpeza():
	is_precisa_interagir = false
	progresso_atual = 0.0
	barra_progresso.visible = false
	sprite.texture = sprite_inicial
	sprite.modulate = Color.WHITE #mudar para glow depois
	tarefa_concluida.emit()
	timer_item_nao_selecionavel.start(segundos_timer_item_nao_selectionavel)

func _on_mouse_entered():
	is_mouse_por_cima = true

func _on_mouse_exited():
	is_mouse_por_cima = false
