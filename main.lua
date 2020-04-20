io.stdout:setvbuf("no")

local animation = require("source.objects.Animation") -- to be removed
local Player = require("source.objects.Player")
local Hud = require("source.objects.Hud")
local BeatBar = require("source.objects.BeatBar")
local Camera = require("source.packages.hump-temp-master.camera")
local enemy = require("source.objects.enemy")
local melee_enemy = require("source.objects.melee_enemy")
local ranged_enemy = require("source.objects.ranged_enemy")
local popBoss = require("source.objects.PopBoss")
local Screen = require("source.objects.Screen")
-- love.load(): Carrega todos os objetos que forem indicados, preprando-os para fase de desenho

function love.load()
	require("source.startup.gameStart")
	gameStart()

	music:load()

	-- bit = animation:new(250, 450, sprites.bit, 300, 64, '1-2', 1, music.spb)
	-- bit:load()

	local meleeEnemy = melee_enemy:new(400,300,64,64,20,"melee_enemy")
	meleeEnemy:load()

	local rangedEnemy = ranged_enemy:new(1500,300,64,64,25,"ranged_enemy")
	rangedEnemy:load()

	local rangedEnemy2 = ranged_enemy:new(1400,300,64,64,25,"ranged_enemy2")
	rangedEnemy2:load()
	
	local g = world:newRectangleCollider(32944, 550, 1136, 50)
	g:setType("static")
	g:setCollisionClass("Ground")

	g = world:newRectangleCollider(33960, 350, 120, 200)
	g:setType("static")
	g:setCollisionClass("Ground")

	player = Player:new(50, 400, 32, 64, 15, music.spb/2)
	player:load()

	tlm:load("images/Pop.lua", require("images.Pop"))

	-- camera = Camera(player.collider:getX(), 320)

	local pb = popBoss:new(33300, 550, player)
	pb:load()
	
	camera = Camera(33512, 320)

	hud = Hud:new(50, 50, player, music.spb, meleeEnemy, rangedEnemy)
	hud:load()

	beatBar = BeatBar:new(love.graphics.getWidth() / 2, 7*love.graphics.getHeight()/8)
	beatBar:load()
end

-- love:update(): Atualiza o estado de jogo após um período de tempo

function love.update(dt)
	g_GameTime = g_GameTime + dt
	if not pauseScreen.paused then
		music.music:update(dt)
		gameLoop:update(dt)
		world:update(dt)
		tlm:update(dt)
		if(player.collider:getX() < love.graphics.getWidth()/2) then
			camera:lockX(love.graphics.getWidth()/2)
		elseif (player.collider:getX() >= 32944) then
			camera:lockX(33512)
		else
			camera:lockX(player.collider:getX())
		end
	end
end

function love.keypressed(k)
	if (pauseScreen.paused) then
		pauseScreen:keypressed(k)
	end
	if k == "space" then
		-- Toggle pause
		pauseScreen.paused = not pauseScreen.paused
		if pauseScreen.paused then
			pauseScreen:load()
			music.music:pause()
		else	
			pauseScreen:remove()
			music.music:play()
		end
	end
end

--love:draw(): Desenha todos os elementos que estiverem no renderer

function love.draw()
	tlm:draw()
	camera:attach()

	-- Draw map
	renderer:draw()
	world:draw()
	camera:detach()
	beatBar:draw()
	hud:draw()

end
