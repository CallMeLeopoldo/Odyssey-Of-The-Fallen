io.stdout:setvbuf("no")

local tlm = require("source.tiles.tile_manager")

local animation = require("source.objects.Animation") -- to be removed

local BasicEnemy = require("source.objects.BasicEnemy")
local Player = require("source.objects.Player")

-- love.load(): Carrega todos os objetos que forem indicados, preprando-os para fase de desenho

function love.load()
	require("source.startup.gameStart")
	gameStart()

	music:load()

	bit = animation:new(250, 450, sprites.bit, 300, 64, '1-2', 1, music.spb)
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