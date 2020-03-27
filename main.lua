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

local Renderer = require("source.tools.renderer")
local GameLoop = require("source.tools.gameLoop")
local tlm = require("source.tiles.tile_manager")
local windfield = require("source.packages.windfield")
local animation = require("source.objects.Animation")
local Person = require("source.objects.Person")
local BasicEnemy = require("source.objects.BasicEnemy")
local Player = require("source.objects.Player")
require("source.resources")

-- Criação do renderer e do gameloop
renderer = Renderer:create()
gameLoop = GameLoop:create()

world = windfield.newWorld()
world:setGravity(0, 100)
world:addCollisionClass("Ground")
world:addCollisionClass("Player")
world:addCollisionClass("BasicEnemy")
world:addCollisionClass("Attack")
world:setQueryDebugDrawing(true)

ground = world:newRectangleCollider(0, 550, 880, 50)
ground:setType("static")
ground:setCollisionClass("Ground")

anim8 = require("source.packages.anim8")

-- Definição da tela de jogo
-- TODO: ajustar a tela para um tamanho mais adequado

g_width = love.graphics.getWidth()
g_height= love.graphics.getHeight()


g_GameTime = 0 --timer do jogo

-- love.load(): Carrega todos os objetos que forem indicados, preprando-os para fase de desenho

function love.load()
	bit = animation:new(250, 450, bit_image, 300, 64, '1-2', 1, 0.6)
	bit:load()

	paint = animation:new(x, y, paintings, 64, 64, '1-3', 1, 0.5)
	paint:load()

	local basicEnemy = BasicEnemy:new(400,10,64,64,15)
	basicEnemy:load()

	local player = Player:new(250, 50, 20, 64)
	player:load()

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