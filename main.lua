io.stdout:setvbuf("no")


-- Declaração de atributos que vamos usar durante o jogo
-- Esses vão ser:


-- Renderer:
-- Carrega todos os objetos e prepara-os para serem desenhados assim que love:draw() for chamado

-- GameLoop:
-- Guarda todas ações (internas ou externas ao jogador) que possam ser repetidas durante o jogo

-- class:
-- Método da framework Middleclass usado para instanciar classes e subclasses
-- Para aceder à documentação desta framework, visitar: https://github.com/kikito/middleclass/wiki

-- tlm:
-- Tile Manager, responsável por manter uma tabela bidimensional que coloca as sprites pelo jogo, usados no desenho do nível, personagens, etc.

local Renderer = require("tools.renderer")
local GameLoop = require("tools.gameLoop")
local tlm = require("tiles.tile_manager")
local class = require("packages.middleclass")
local windfield = require("packages.windfield")
local anim8 = require("packages.anim8")
local Person = require("objects.Person")
local BasicEnemy = require("objects.BasicEnemy")

-- Criação do renderer e do gameloop
renderer = Renderer:create()
gameLoop = GameLoop:create()
world = windfield.newWorld()


-- Definição da tela de jogo
-- TODO: ajustar a tela para um tamanho mais adequado

g_width = love.graphics.getWidth()
g_height= love.graphics.getHeight()


g_GameTime = 0 --timer do jogo


local person = Person:new(10,10,64,64)
renderer:addRenderer(person,1)

local basicEnemy = BasicEnemy:new(60,60,64,64)
renderer:addRenderer(basicEnemy,1)

-- love.load(): Carrega todos os objetos que forem indicados, preprando-os para fase de desenho

function love.load()

	gameLoop:addLoop(self)
	tlm:load()
end

-- love:update(): Atualiza o estado de jogo após um período de tempo

function love.update(dt)
	g_GameTime = g_GameTime + dt
	gameLoop:update(dt)
	world:update(dt)
end

--love:draw(): Desenha todos os elementos que estiverem no renderer

function love.draw()
	renderer:draw()
	world:draw()
end