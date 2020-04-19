local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")
local rangedAttack = require("source.objects.RangedAttack")

local Player = class("Player", Person)

local bool = false
local beatnumb = 0
local beatpos = 0


function Player:initialize(x, y, w, h, r, attackSpeed)

	-- Player Collider
	local upperBody = world:newRectangleCollider(x, y - h/2, w, h/2)
	upperBody:setObject(self)
	upperBody:setSleepingAllowed(false)
	upperBody:setCollisionClass("Player")
	upperBody:setFixedRotation(true)
	upperBody:setRestitution(0)
	upperBody:setInertia(50)

	upperBody:setPreSolve(
		function(collider_1, collider_2, contact)
			if collider_1.collision_class == "Ignore" and collider_2.collision_class == "EnemyAttack" then contact:setEnabled(false) end
		end)

	local lowerBody = world:newRectangleCollider(x, y, w, h/2)
	lowerBody:setObject(self)
	lowerBody:setSleepingAllowed(false)
	lowerBody:setCollisionClass("Player")
	lowerBody:setFixedRotation(true)
	lowerBody:setRestitution(0)
	lowerBody:setInertia(50)

	world:addJoint("RevoluteJoint", lowerBody, upperBody, h, w, true)

	-- Player Animations
	self.animations = {}
	self.animations.walkRight = animation:new(x - w, y, sprites.player, 64, 64, '1-4', 1, 1/12)
	self.animations.walkLeft = animation:new(x - w, y, sprites.player, 64, 64, '1-4', 2, 1/12)
	self.animations.stand = animation:new(x - w, y, sprites.player, 64, 64, 1, 3, 1/12)

	Person.initialize(self, x, y, w, h, r, lowerBody, self.animations.walkRight, "player")

	-- Other variables required
	self.accuracy = 1
	self.lastDirection = 1
	self.attackTimming = attackSpeed
	self.lastAttack = attackSpeed
	self.mojo = 5
	self.maxMojo = 10
	self.currentDmg = self.baseDmg
	self.health = 100
	self.multiplier = 0
	self.moveSpeed = 200
	self.upperBody = upperBody
	self.height = h
	self.combo = 0
	self.oncombo = false
end

function Player:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Player:update(dt)
	Person.update(self, dt)
	self.lastAttack = self.lastAttack + dt

	local beatnumb,subbeat2 = music.music:getBeat()

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
	if love.keyboard.isDown("up") then

		local x, y = self.collider:getLinearVelocity()

		if y == 0 then
			self:calculateAccuracy()

			local impulse = -500
			if self.multiplier >= 3 then
				impulse = impulse * 3
			else
				impulse = impulse*self.multiplier
			end

			self.collider:applyLinearImpulse(0, impulse)
		end
	end
	if love.keyboard.isDown("down") then
		self.upperBody:setCollisionClass("Ignore")
	else
		self.upperBody:setCollisionClass("Player")
	end

	-- Attack
	if love.keyboard.isDown("z") and self.lastAttack >= self.attackTimming then

		self:calculateAccuracy()
		self.currentDmg = self.baseDmg * self.accuracy
		if self.accuracy == 1 then
			if self.combo == 0 then
				 self.combo = 1
				 self.combobeat = beatnumb
				 if subbeat2 >= 0.875  then
	 					beatpos = 1
				 else
					 	beatpos = 0
	 			 end

			elseif self.combo == 1 then
				if (subbeat2 >= 0.875 and self.combobeat + beatpos == beatnumb) or (subbeat2 <= 0.125 and self.combobeat + 1 + beatpos == beatnumb) then
					self.combo = 2
					self.combobeat = beatnumb
					if subbeat2 >= 0.875  then
					 beatpos = 1
				  else
					 beatpos = 0
				  end
			  else
					self.combo = 0
			  end
		  else
			  self.combo = 0
			end
    else
			self.combo = 0
		end
		local px, py = self.collider:getPosition()
		local colliders = world:queryCircleArea(px + self.lastDirection*64, py - self.height/4, 25, {"Enemy"})
		for i, c in ipairs(colliders) do
			c.object:interact(self.currentDmg)
			self.mojo = self.mojo + self.currentDmg
			if self.mojo > self.maxMojo then self.mojo = self.maxMojo end
    end
		self.lastAttack = 0
	end

	if (love.keyboard.isDown("x") and self.lastAttack >= self.attackTimming) then
		self:calculateAccuracy()
		self.currentDmg = self.baseDmg * self.accuracy
		if self.combo == 2 and self.accuracy == 1 and self.mojo >= 5 then
			if (subbeat2 >= 0.875 and self.combobeat + beatpos == beatnumb) or (subbeat2 <= 0.125 and self.combobeat + 1 + beatpos == beatnumb) then
				self.combo = 0
				local combo1 = rangedAttack:new(self.collider:getX() + 32, self.collider:getY() - self.height/4, 1, self.accuracy, true)
				combo1:load()
				local combo2 = rangedAttack:new(self.collider:getX() - 32, self.collider:getY() - self.height/4, -1, self.accuracy, true)
				combo2:load()
			else
				self.combo = 0
				local ra = rangedAttack:new(self.collider:getX() + self.lastDirection*64, self.collider:getY() - self.height/4, self.lastDirection, self.accuracy, true)
				ra:load()
			end
		else
			self.combo = 0
			local ra = rangedAttack:new(self.collider:getX() + self.lastDirection*64, self.collider:getY() - self.height/4, self.lastDirection, self.accuracy, true)
			ra:load()
		end
		self.lastAttack = 0
	end



	if x == 0 then self.animation = self.animations.stand end

	-- Position Update
	local velocity = x*dt*300
	local newX, currentY = self.collider:getX() + velocity, self.collider:getY()

	if currentY > 700 then
		x = 50
		currentY = 400
		self.collider:setY(currentY)
		self.upperBody:setY(currentY + self.h/2)
	end

	self.collider:setX(newX)
	self.collider:setY(currentY)

	Person.setAnimationPos(self, newX - self.w, currentY - 3*self.h/4)
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
	elseif (subbeat >= 0.7 and subbeat < 0.875) or (subbeat < 0.3 and subbeat >= 0.125) then
		self.accuracy = 0.75
	elseif (subbeat >= 0.6 and subbeat < 0.7) or (subbeat < 0.4 and subbeat >= 0.3) then
		self.accuracy = 0.5
	else
		self.accuracy = 0.25
	end

	if self.accuracy >= 0.75 then
		self.multiplier = self.multiplier + 1
	else
		self.multiplier = 1
	end
end

function Player:getPosition()
	return self.collider:getPosition()
end

return Player
