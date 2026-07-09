class_name Jogador
extends Node2D

@onready var sprite_jogador: Sprite2D = $SpriteJogador
@onready var balao_fala: BalaoFala = $Fala
var posicao_inicial: Vector2
var sprite_inicial: Texture2D

func _ready():
	posicao_inicial = self.position
	sprite_inicial = sprite_jogador.texture

func mudar_posicao(posicao: Vector2):
	self.position = posicao

func mudar_sprite(texture: Texture2D):
	sprite_jogador.texture = texture

func mudar_posicao_para_inicial():
	self.position = posicao_inicial

func mudar_sprite_para_inicial():
	sprite_jogador.texture = sprite_inicial

func mostrar_fala(texto: String, tempo_timer: float = 0):
	balao_fala.mostrar_texto(texto, tempo_timer)
