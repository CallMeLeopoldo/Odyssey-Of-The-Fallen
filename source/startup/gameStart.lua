function gameStart()
	
	--love.window.setFullscreen(true)
	tlm = require("source.tools.tlm")
	sti  = require ("source.packages.sti")
	local windfield = require("source.packages.windfield")
	local Renderer = require("source.tools.renderer")
	local GameLoop = require("source.tools.gameLoop")
	local Music = require("source.tools.music")
	local Screen = require("source.objects.Screen")
	require("source.startup.global")
	require("source.startup.debug")

	-- Create new world and set it's properties
	world = windfield.newWorld()
	world:setGravity(0, 400)
	world:addCollisionClass("Shop")
	world:addCollisionClass("Ground")
	world:addCollisionClass("Ignore", {ignores = {"Shop", "Ground"}})
	world:addCollisionClass("Player")
	world:addCollisionClass("Enemy")
	world:addCollisionClass("PlayerAttack", {ignores = {"Player"}})
	world:addCollisionClass("EnemyAttack", {ignores = {"Enemy", "Ignore"}})
	world:addCollisionClass("Stop", {ignores = {"Player", "Shop", "PlayerAttack", "EnemyAttack"}})
	world:addCollisionClass("Stage", {ignores = {"Player", "Shop", "PlayerAttack", "EnemyAttack", "Enemy"}})
	world:setQueryDebugDrawing(true)

	-- Global packages and variables
	anim8 = require("source.packages.anim8")
	renderer = Renderer:create()
	gameLoop = GameLoop:create()
	pauseScreen = Screen:new()
	music = Music:new("audio/tutorial.mp3", 70)
	currentLevel = nil
	font = love.graphics.newFont("fonts/manaspc.ttf", 15)
	love.graphics.setFont(font)

	require("source.startup.resources")

	-- Game Screen Settings
	-- TODO: ajustar a tela para um tamanho mais adequado

	g_width = love.graphics.getWidth()
	g_height= love.graphics.getHeight()

	love.graphics.setBackgroundColor(0.7, 0.7, 1)

	g_GameTime = 0 --timer do jogo
end