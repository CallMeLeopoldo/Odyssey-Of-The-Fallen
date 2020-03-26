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
local class = require("tools.middleclass")
local tlm = require("tiles.tile_manager")


-- Criação do renderer e do gameloop
renderer = Renderer:create()
gameLoop = GameLoop:create()

-- Definição da tela de jogo
-- TODO: ajustar a tela para um tamanho mais adequado

g_width = love.graphics.getWidth()
g_height= love.graphics.getHeight()


g_GameTime = 0 --timer do jogo


-- Objeto de teste (apenas para verificar se todos os módulos do jogo estão operacionais)

function createBox(x,y)
	local b = {}

	b.x = x or 0
	b.y = y or 0

	function b:load()
		renderer:addRenderer(self)
		gameLoop:addLoop(self)
	end

	function b:draw()
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle("fill", self.x, self.y, 64, 64)
	end

	function b:tick(dt)
		print(dt, math.random()) -- Teste de print na consola (TEMPORÁRIO)
	end	

	return b
end

-- love.load(): Carrega todos os objetos que forem indicados, preprando-os para fase de desenho

function love.load()
	r1 = createBox(64,64) -- Objeto de teste (TEMPORÁRIO)

	r1:load()

	gameLoop:addLoop(self)
	tlm:load()
end

-- love:update(): Atualiza o estado de jogo após um período de tempo

function love.update(dt)
	g_GameTime = g_GameTime + dt
	gameLoop:update(dt)
end

--love:draw(): Desenha todos os elementos que estiverem no renderer

function love.draw()
	renderer:draw()
end