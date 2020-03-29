local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")

local Player = class("Player", Person)

function Player:initialize(x, y, w, h, r)

	-- Player Collider
	local collider = world:newCircleCollider(x, y, 15)
	collider:setObject(self)
	collider:setSleepingAllowed(false)
	collider:setCollisionClass("Player")
	collider:getBody():setFixedRotation(true)

	-- Player Animations
	self.animations = {}
	self.animations.walkRight = animation:new(x, y, player_image, w, h, 1, 1, 0.2)
	self.animations.walkLeft = animation:new(x, y, player_image, w, h, 1, 2, 0.2)

	Person.initialize(self, x, y, w, h, r, collider, self.animations.walkRight)

	-- Other variables required
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
	
	-- Collisions
	if self.collider:enter("Ground") then
		self.onAir = false
	end

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
	if not self.onAir and love.keyboard.isDown("a") then
		local _, subbeat = music.music:getBeat()

		self.collider:applyLinearImpulse(0, -250*subbeat)
		self.onAir = true
	end

	-- Attack
	if love.keyboard.isDown("s") and self.lastAttack >= self.attackTimming then

		local beat, subbeat = music.music:getBeat()

		self.currentDmg = self.baseDmg * subbeat

		print(self.currentDmg)

		local px, py = self.collider:getPosition()
		local colliders = world:queryCircleArea(px + self.lastDirection*35, py, 20, {"BasicEnemy"})
		for i, c in ipairs(colliders) do
			c.object:interact(self.currentDmg)
		end
		self.lastAttack = 0
	end

	-- Position Update
	local newX, currentY = self.collider:getX() + x*dt*20, self.collider:getY()
	self.collider:setX(newX)

	Person.setAnimationPos(self, newX - self.w/2, currentY - 3*self.h/4)
end

function Player:draw()
	Person.draw(self)
end

-- Callback function for collisions
function Player:interact(dmg_dealt)
	Person.interact(self, dmg_dealt)
end

return Player