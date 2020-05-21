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
	self.animations = {
		walk = animation:new(x - w, y, sprites.player, 64, 64, '1-4', 1, 1/12),
		stand = animation:new(x - w, y, sprites.player, 64, 64, 1, 3, 1),
		crouch = animation:new(x- w, y, sprites.player, 64, 64, 3, 3, 1),
		attackRanged = animation:new(x - w, y, sprites.player, 64, 64, '1-4', 2, attackSpeed/4),
		attackMelee = animation:new(x-w, y, sprites.player, 64, 64, '1-3', 4, attackSpeed/3),
		meleeGuitar = animation:new(x, y, sprites.player, 64, 64, 4, 4, 1),
		hearth = animation:new(x, y, sprites.hearth, 16, 16, 1, 1, 1)
	}

	Person.initialize(self, x, y, w, h, r, lowerBody, self.animations.walk, "player")

	-- Other variables required
	self.accuracy = -1
	self.lastDirection = 1
	self.attackTimming = attackSpeed
	self.lastAttack = attackSpeed
	self.mojo = 0
	self.maxMojo = 100
	self.currentDmg = 10
	self.baseDmg = 10
	self.health = 100
	self.multiplier = 0
	self.moveSpeed = 200
	self.upperBody = upperBody
	self.height = h
	self.combo = 0
	self.oncombo = false
	self.isMelee = false
	self.start_time = os.time()
	self.money = 0
	self.xis = 0
  self.accuracyanim = 0.5
	self.accuracytime = 0
	self.accuracydoing = 0
end

function Player:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Player:update(dt)
	local primaryDirection = self.lastDirection
	self.xis = 0
  if self.accuracydoing == 1 then
		self.accuracytime = self.accuracytime + dt
		if self.accuracytime > self.accuracyanim then
			self.accuracytime = 0
			self.accuracydoing = 0
			self.animations.hearth:update(dt)
		end
	end
	-- Checking variables
	Person.update(self, dt)

	self.lastAttack = self.lastAttack + dt
	if self.lastAttack < self.attackTimming then
		if self.isMelee and self.lastAttack > (2*self.attackTimming)/3 then
			local animX, animY = self.collider:getPosition()
			self.animations.meleeGuitar:setPosition(animX - self.w + self.lastDirection*64, animY - 3*self.h/4)
		end
		-- por aqui coisas que ele pode fazer enquanto está a meio da animação de ataque
		--antes de dar return

		-- inputs enquanto ataca
		if love.keyboard.isDown("left") then
			self.xis = -1

		end
		if love.keyboard.isDown("right") then
			self.xis = 1
		end
		if love.keyboard.isDown("up") then

			local x, y = self.collider:getLinearVelocity()

			if y == 0 then
				self:calculateAccuracy()
				if self.multiplier == 0 then
					self.start_time = os.time()
				end
				if os.time() - self.start_time >= 5 then
					self.multiplier = 0
					self.start_time = os.time()
				end
				local impulse = -700
				if self.multiplier >= 2 then
					impulse = impulse - (200 * 2)
				else
					impulse = impulse - (200*self.multiplier)
				end

				self.collider:applyLinearImpulse(0, impulse)

				if self.accuracy >= 0.75 then
					if self.multiplier < 2 then
						self.multiplier = self.multiplier + 1
					else
						self.multiplier = 0
					end
				else
					self.multiplier = 0
				end
			end
		end
		-- Position updates
		local velocity = self.xis*dt*300
		local newX, currentY = self.collider:getX() + velocity , self.collider:getY()

		if currentY > 700 then
			x = 50
			currentY = 400
			self.collider:setY(currentY)
			self.upperBody:setY(currentY + self.h/2)
		end

		self.collider:setX(newX)
		self.collider:setY(currentY)

		-- Animation updates
		Person.setAnimationPos(self, newX - self.w, currentY - 3*self.h/4)
		if primaryDirection ~= self.lastDirection then
			for _, anim in pairs(self.animations) do
				anim.animation:flipH()
			end
		end

		return
		-- fim de acoes que acontecem durante ataque
	end

	local beatnumb,subbeat2 = music.music:getBeat()

	-- Crouch
	local isCrouching = false
	if love.keyboard.isDown("down") then
		self.animation = self.animations.crouch
		self.upperBody:setCollisionClass("Ignore")
		isCrouching = true
	else
		self.upperBody:setCollisionClass("Player")
	end

	local x = 0
	if isCrouching == true then
		if love.keyboard.isDown("left") then
			x = -1
			self.lastDirection = -1
		end
		if love.keyboard.isDown("right") then
			x = 1
			self.lastDirection = 1
		end
	end
	if isCrouching == false then

		-- Movement
	if love.keyboard.isDown("left") then
		x = -1
		self.lastDirection = -1
	end
	if love.keyboard.isDown("right") then
		x = 1
		self.lastDirection = 1
	end
	if x == 0 then
		self.animation = self.animations.stand
	else
		self.animation = self.animations.walk
	end
	if love.keyboard.isDown("up") then

		local x, y = self.collider:getLinearVelocity()

		if y == 0 then
			self:calculateAccuracy()
			if self.multiplier == 0 then
				self.start_time = os.time()
			end
			if os.time() - self.start_time >= 5 then
				self.multiplier = 0
				self.start_time = os.time()
			end
			local impulse = -700
			if self.multiplier >= 2 then
				impulse = impulse - (200 * 2)
			else
				impulse = impulse - (200*self.multiplier)
			end

			self.collider:applyLinearImpulse(0, impulse)

			if self.accuracy >= 0.75 then
				if self.multiplier < 2 then
					self.multiplier = self.multiplier + 1
				else
					self.multiplier = 0
				end
			else
				self.multiplier = 0
			end
		end
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
		self.animation  = self.animations.attackMelee
		self.isMelee = true
	end

	if (love.keyboard.isDown("x") and self.lastAttack >= self.attackTimming) then
		self:calculateAccuracy()
		self.currentDmg = self.baseDmg * self.accuracy
		if self.combo == 2 and self.accuracy == 1 and self.mojo >= 50 then
			if (subbeat2 >= 0.875 and self.combobeat + beatpos == beatnumb) or (subbeat2 <= 0.125 and self.combobeat + 1 + beatpos == beatnumb) then
				self.combo = 0
				local combo1 = rangedAttack:new(self.collider:getX() + 32, self.collider:getY() - self.height/4, 1, self.accuracy, true, sprites.macRanged)
				combo1:load()
				local combo2 = rangedAttack:new(self.collider:getX() - 32, self.collider:getY() - self.height/4, -1, self.accuracy, true, sprites.macRanged)
				combo2:load()
				self.mojo = self.mojo - 50
			else
				self.combo = 0
				local ra = rangedAttack:new(self.collider:getX() + self.lastDirection*64, self.collider:getY() - self.height/4, self.lastDirection, self.accuracy, true, sprites.macRanged)
				ra:load()
			end
		else
			self.combo = 0
			local ra = rangedAttack:new(self.collider:getX() + self.lastDirection*64, self.collider:getY() - self.height/4, self.lastDirection, self.accuracy, true, sprites.macRanged)
			ra:load()
		end
		self.lastAttack = 0
		self.animation = self.animations.attackRanged
		self.isMelee = false
	end
	end

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

	-- Animation updates
	Person.setAnimationPos(self, newX - self.w, currentY - 3*self.h/4)
	if primaryDirection ~= self.lastDirection then
		for _, anim in pairs(self.animations) do
			anim.animation:flipH()
		end
	end
end

function Player:draw()
	Person.draw(self)
	local newX, currentY = self.collider:getX()- self.w/2 + 9, self.collider:getY() - self.h - 4
	if self.accuracy == 1 and self.accuracydoing == 1 then
		self.animations.hearth:setPosition(newX, currentY)
		self.animations.hearth:draw()
	end
	if self.lastAttack < self.attackTimming then
		if self.isMelee and self.lastAttack > (2*self.attackTimming)/3 then
			self.animations.meleeGuitar.animation:gotoFrame(1)
			self.animations.meleeGuitar:draw()
		end
	end
end

-- Callback function for collisions
function Player:interact(dmg_dealt)
	Person.interact(self, dmg_dealt)
end

function Player:calculateAccuracy()
	local _, subbeat = music.music:getBeat()
	self.accuracydoing = 1
	if subbeat >= 0.875 or subbeat < 0.125 then
		self.accuracy = 1
	elseif (subbeat >= 0.7 and subbeat < 0.875) or (subbeat < 0.3 and subbeat >= 0.125) then
		self.accuracy = 0.75
	elseif (subbeat >= 0.6 and subbeat < 0.7) or (subbeat < 0.4 and subbeat >= 0.3) then
		self.accuracy = 0.5
	else
		self.accuracy = 0.25
	end
end

function Player:getPosition()
	return self.collider:getPosition()
end

function Player:restart(x, y)
	if self.lastDirection == -1 then
		for _, anim in pairs(self.animations) do
			anim.animation:flipH()
		end
		self.lastDirection = 1
	end
	
	self.collider:setPosition(x, y)
	self.upperBody:setPosition(x, y)
	self.mojo = 0
	self.maxMojo = 100
	self.health = 100
	self.multiplier = 0
	self.combo = 0
	self.oncombo = false
	self.money = 0
end

return Player
