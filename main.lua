io.stdout:setvbuf("no")

local animation = require("source.objects.Animation") -- to be removed
local Player = require("source.objects.Player")
local Hud = require("source.objects.Hud")
local BeatBar = require("source.objects.BeatBar")
local Camera = require("source.packages.hump-temp-master.camera")
local enemy = require("source.objects.enemy")
local melee_enemy = require("source.objects.melee_enemy")
local ranged_enemy = require("source.objects.ranged_enemy")

-- love.load(): Carrega todos os objetos que forem indicados, preprando-os para fase de desenho

function love.load()
	require("source.startup.gameStart")
	gameStart()

	music:load()

	-- bit = animation:new(250, 450, sprites.bit, 300, 64, '1-2', 1, music.spb)
	-- bit:load()

	local meleeEnemy = melee_enemy:new(400,500,64,64,20,"melee_enemy")
	meleeEnemy:load()

	local rangedEnemy = ranged_enemy:new(1000,500,64,64,25,"ranged_enemy")
	rangedEnemy:load()

	local rangedEnemy2 = ranged_enemy:new(1100,500,64,64,25,"ranged_enemy2")
	rangedEnemy2:load()


	player = Player:new(50, 520, 20, 64, 15, music.spb/2)
	player:load()

	tlm:load("images/Pop.lua",0,0)

	camera = Camera(player.collider:getX(), player.collider:getY())

	hud = Hud:new(50, 50, player, music.spb, meleeEnemy, rangedEnemy)
	hud:load()

	beatBar = BeatBar:new(love.graphics.getWidth() / 2, 7*love.graphics.getHeight()/8)
	beatBar:load()
end

-- love:update(): Atualiza o estado de jogo após um período de tempo

function love.update(dt)
	g_GameTime = g_GameTime + dt
	--print(g_GameTime)
	music.music:update(dt)
	gameLoop:update(dt)
	world:update(dt)
	tlm:update(dt)
	--hud:update(dt)
	--beatBar:update(dt)
	camera:lockX(player.collider:getX())
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
	camera:attach()

	-- Draw map
	tlm:draw()

	love.graphics.setColor(0.28, 0.63, 0.05)
	love.graphics.polygon("fill", ground:getBody():getWorldPoints(ground:getShape():getPoints()))
	love.graphics.setColor(1, 1, 1)

	love.graphics.setColor(0.28, 0.63, 0.05)
	love.graphics.polygon("fill", ground2:getBody():getWorldPoints(ground2:getShape():getPoints()))
	love.graphics.setColor(1, 1, 1)
	renderer:draw()
	world:draw()
	camera:detach()
	beatBar:draw()
	hud:draw()

end
