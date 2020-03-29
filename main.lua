io.stdout:setvbuf("no")

-- Load required packages ,tools and classes
require("source.resources")
local Renderer = require("source.tools.renderer")
local GameLoop = require("source.tools.gameLoop")
local tlm = require("source.tiles.tile_manager")
local windfield = require("source.packages.windfield")
local animation = require("source.objects.Animation")
local Person = require("source.objects.Person")
local BasicEnemy = require("source.objects.BasicEnemy")
local Player = require("source.objects.Player")
local Music = require("source.tools.music")
anim8 = require("source.packages.anim8")
renderer = Renderer:create()
gameLoop = GameLoop:create()
music = Music:new("audio/sound.mp3")


-- Create new world and set it's properties
world = windfield.newWorld()
world:setGravity(0, 100)
world:addCollisionClass("Ground")
world:addCollisionClass("Player")
world:addCollisionClass("BasicEnemy")
world:addCollisionClass("Attack")
world:setQueryDebugDrawing(true)

-- Create a ground and set it's properties
ground = world:newRectangleCollider(0, 550, 800, 50)
ground:setType("static")
ground:setCollisionClass("Ground")

-- Game Screen Settings
-- TODO: ajustar a tela para um tamanho mais adequado

g_width = love.graphics.getWidth()
g_height= love.graphics.getHeight()

love.graphics.setBackgroundColor(0.7, 0.7, 1)

g_GameTime = 0 --timer do jogo

-- love.load(): Carrega todos os objetos que forem indicados, preprando-os para fase de desenho

function love.load()
	music:load()

	bit = animation:new(250, 450, bit_image, 300, 64, '1-2', 1, music.spb)
	bit:load()

	local basicEnemy = BasicEnemy:new(400,10, 50, 50, 25,15)
	basicEnemy:load()

	local player = Player:new(250, 50, 20, 64, 15, music.spb/2)
	player:load()

	tlm:load()
end

-- love:update(): Atualiza o estado de jogo após um período de tempo

function love.update(dt)
	g_GameTime = g_GameTime + dt
	--print(g_GameTime)
	music.music:update(dt)
	gameLoop:update(dt)
	world:update(dt)
end

function love.keypressed(k)
  if k == "space" then
    -- Toggle pause
    paused = not paused
    if paused then
      music.music:pause()
    else
      music.music:play()
    end
  end
end


--love:draw(): Desenha todos os elementos que estiverem no renderer

function love.draw()
	love.graphics.setColor(0.28, 0.63, 0.05)
	love.graphics.polygon("fill", ground:getBody():getWorldPoints(ground:getShape():getPoints()))
	love.graphics.setColor(1, 1, 1)
	
	renderer:draw()
	world:draw()
end