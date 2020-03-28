local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")

local Player = class("Player", Person)

function Player:initialize(x, y, w, h, r)
	local collider = world:newCircleCollider(x, y, r)
	collider:setCollisionClass("Player")
	self.animations = {}
	self.animations.walkRight = animation:new(x, y, player_image, w, h, 1, 1, 0.2)
	self.animations.walkLeft = animation:new(x, y, player_image, w, h, 1, 2, 0.2)

	Person.initialize(self, x, y, w, h, r, collider, self.animations.walkRight)
	self.accuracy = 1
	self.lastDirection = 1
	self.onAir = true
	self.attackTimming = 2
	self.lastAttack = 2
end

function Player:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Player:update(dt)
	Person.update(self, dt)
	self.lastAttack = self.lastAttack + dt
	
	if self.collider:enter("Ground") then
		self.onAir = false
	end

	local x = 0

	if love.keyboard.isDown("left") then
		x = -1
		self.lastDirection = -1
		self.animation = self.animations.walkLeft
	end
	if love.keyboard.isDown("right") then
		x = 1
		self.lastDirection = 1
		self.animation = self.animations.walkRight
	end
	if not self.onAir and love.keyboard.isDown("a") then
		self.collider:applyLinearImpulse(0, -250)
		self.onAir = true
	end
	if love.keyboard.isDown("s") and self.lastAttack >= self.attackTimming then

		Player:accuracy_calc()

		self.currentDmg = self.baseDmg * self.accuracy

		local px, py = self.collider:getPosition()
		local colliders = world:queryCircleArea(px + self.lastDirection*35, py, 20, {"Enemy"})
		-- Perform the rest of the attack
		self.lastAttack = 0
	end

	local newX, currentY = self.collider:getX() + x*dt*20, self.collider:getY()
	self.collider:setX(newX)

	Person.setAnimationPos(self, newX - self.r/2, currentY - self.r/2 - self.h/2)
end

function Player:accuracy_calc()
	local time_btw_beats = g_GameTime % bpm.spb
	self.accuracy = time_btw_beats/bpm.spb
	print(self.accuracy)
end

function Player:draw()
	Person.draw(self)
end

return Player