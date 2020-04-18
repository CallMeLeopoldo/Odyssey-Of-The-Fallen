local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")

local Player = class("Player", Person)

function Player:initialize(x, y, w, h, r, attackSpeed)

	-- Player Collider
	local collider = world:newCircleCollider(x, y, r)
	collider:setObject(self)
	collider:setSleepingAllowed(false)
	collider:setCollisionClass("Player")
	collider:getBody():setFixedRotation(true)
	collider:setRestitution(0)
	collider:setInertia(50)
	-- Player Animations
	self.animations = {}
	self.animations.walkRight = animation:new(x, y, sprites.player, w, h, 1, 1, 0.2)
	self.animations.walkLeft = animation:new(x, y, sprites.player, w, h, 1, 2, 0.2)

	Person.initialize(self, x, y, w, h, r, collider, self.animations.walkRight, "player")

	-- Other variables required
	self.accuracy = 1
	self.lastDirection = 1
	self.attackTimming = attackSpeed
	self.lastAttack = attackSpeed
	self.mojo = 0
	self.maxMojo = 10
	self.currentDmg = self.baseDmg
	self.health = 100
	self.multiplier = 0
	self.moveSpeed = 200

end

function Player:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Player:update(dt)
	Person.update(self, dt)
	self.lastAttack = self.lastAttack + dt

	-- Movement
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
	if love.keyboard.isDown("a") then

		local x, y = self.collider:getLinearVelocity()

		if y == 0 then
			self:calculateAccuracy()

			local impulse = -100
			if self.multiplier >= 3 then
				impulse = impulse * 3
			else
				impulse = impulse*self.multiplier
			end

			self.collider:applyLinearImpulse(0, impulse)
		end

	end

	-- Attack
	if love.keyboard.isDown("s") and self.lastAttack >= self.attackTimming then

		self:calculateAccuracy()
		self.currentDmg = self.baseDmg * self.accuracy

		print(self.currentDmg)

		local px, py = self.collider:getPosition()
		local colliders = world:queryCircleArea(px + self.lastDirection*35, py, 20, {"BasicEnemy"})
		for i, c in ipairs(colliders) do
			c.object:interact(self.currentDmg)
			self.mojo = self.mojo + self.currentDmg
			if self.mojo > self.maxMojo then self.mojo = self.maxMojo end
		end
		self.lastAttack = 0
	end

	-- Position Update
	local newX, currentY = self.collider:getX() + x*dt*self.moveSpeed, self.collider:getY()

	if currentY > 700 then
		x = 50
		currentY = 400
		self.collider:setY(currentY)
	end

	self.collider:setX(newX)
	self.collider:setY(currentY)

	Person.setAnimationPos(self, newX - self.w/2, currentY - 3*self.h/4)
end

function Player:draw()
	Person.draw(self)
end

-- Callback function for collisions
function Player:interact(dmg_dealt)
	Person.interact(self, dmg_dealt)
end

function Player:calculateAccuracy()
	local _, subbeat = music.music:getBeat()

	if subbeat >= 0.875 or subbeat < 0.125 then
		self.accuracy = 1
	elseif subbeat >= 0.125 and subbeat < 0.375 then
		self.accuracy = 0.25
	elseif subbeat >= 0.3755 and subbeat < 0.625 then
		self.accuracy = 0.5
	elseif subbeat >= 0.625 and subbeat < 0.875 then
		self.accuracy = 0.75
	end

	if self.accuracy >= 0.75 then
		self.multiplier = self.multiplier + 1
	else
		self.multiplier = 1
	end
end

return Player
