local class = require("source.packages.middleclass")
local animation = require("source.objects.Animation")
local Enemy = require("source.objects.enemy")
local MeleeEnemy = require("source.objects.melee_enemy")
local RangedEnemy = require("source.objects.ranged_enemy")
local RangedAttack = require("source.objects.RangedAttack")

local PopBoss = class("PopBoss", RangedEnemy)

local states = { fight = 1, spawn = 2, shield = 3 }

function PopBoss:initialize(x, y, player)

	Enemy.initialize(self, x, y, 64, 64, 30, 100, "PopBoss", 1000)

	self.states = states
	self.currentState = self.states.fight
	self.player = player
	self.health = 120
	self.healthLost = 40
	self.shield = 0
	self.enemies = {}
	self.counter = 0
	self.attack = false
	

	self.animations = {
		walkRight = animation:new(x , y, sprites.PopBoss, 64, 64, '1-4', 5, 1/3),
		walkLeft = animation:new(x , y, sprites.PopBoss, 64, 64, '1-4', 4, 1/3),
		attackRight = animation:new(x , y, sprites.PopBoss, 64, 64, '1-6', 1, 1/12),
		spawn = animation:new(x , y, sprites.PopBoss, 64, 64, '1-9', 3, 1/12),
	}

	self.animationTimer = 1
	self.animationDuration = 1

	self.animations.blood = animation:new(x , y, sprites.blood, 64, 64, '1-4', 2, 1/12)
	self.animation = self.animations.spawn
	self.killed = false
end

function PopBoss:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function PopBoss:update(dt)
	self.animationTimer = self.animationTimer + dt
	self.animation:update(dt)
	if self.animationTimer < self.animationDuration then return end

	self:updateState()

	if self.currentState == self.states.fight then
		self:updateFight(dt)
	elseif self.currentState == self.states.spawn then
		self.animation = self.animations.spawn
		self:updateSpawn(dt)
	end
	
	self.animation.x = self.collider:getX() - 32
	self.animation.y = self.collider:getY() - 32
	self.animation:update(dt)
	
end

function PopBoss:updateState()
	if self.currentState == self.states.fight then
		if self.healthLost >= 40 then

			-- Create the new enemies
			self.currentState = self.states.spawn
			self.animation = self.animations.spawn
			self.animationTimer = 0
			self.numberEnemies = 4

			table.insert(self.enemies, MeleeEnemy:new(32944 + 300, 300, 64, 64, 30))
			table.insert(self.enemies, MeleeEnemy:new(34080 - 300, 300, 64, 64, 30))
			table.insert(self.enemies, RangedEnemy:new(32944 + 100, 300, 64, 64, 30))
			table.insert(self.enemies, RangedEnemy:new(34080 - 100, 300, 64, 64, 30))

			self.healthLost = 0
			self.collider:setPosition(34020, 172)

		elseif self.health <= 0 then
			self:destroy()
		end
	elseif self.currentState == self.states.spawn then
		if table.maxn(self.enemies) == 0 then
			self.currentState = self.states.fight
			if self.player.collider:getX() >= 9032 then
				self.collider:setPosition(33144, 300)
			else
				self.collider:setPosition(33880, 300)
			end
			self.animation = self.animations.spawn
			self.animationTimer = 0
			-- TODO: change the attack it makes
		end
	end
end

function PopBoss:updateFight(dt)
	Enemy.update(self, dt)

	if self.dir == 1 then
		self.animation = self.animations.walkLeft
	else
		self.animation = self.animations.walkRight
	end

	local _, subbeat = music.music:getBeat()

	if  subbeat > 0.05 and subbeat < 0.95 then
		if not self.attack then
			self.counter = self.counter + 1
		end
		self.attack = true
	else
		self.attack = false
	end

	if self.counter == 2 then
		local accuracy = 0.5

		self.animation = self.animations.attackRight
		self.animationTimer = 0
		local orientation = (self.player.collider:getX() - self.collider:getX()) / math.abs(self.player.collider:getX() - self.collider:getX())
		local t = RangedAttack:new(self.collider:getX(), self.collider:getY()-30, orientation, accuracy, false, sprites.PopBoss, '1-3', 2, 1/9, 64, 64)
		
		t.movementSpeed = 200
    	t:load()
    	self.counter = 0
	end

end

function PopBoss:updateSpawn(dt)
	local enemiesRemoved = 0
	for k, enemy in ipairs(self.enemies) do
		if enemy.destroyed then
			table.remove(self.enemies, k - enemiesRemoved)
			enemiesRemoved = enemiesRemoved + 1
		else
			enemy:update(dt)
		end
	end

	self.animation = self.animations.walkLeft
	self.animation.animation:gotoFrame(2)
end

function PopBoss:draw()
	for _, enemy in ipairs(self.enemies) do
		if not enemy.destroyed then enemy:draw() end
	end
	print(self.animation == nil)
	self.animation:draw()
end

function PopBoss:interact(dmgDealt)
	if self.shield > 0 then
		if (dmgDealt > self.shield) then
			dmgDealt = dmgDealt - self.shield
			self.shield = 0
		end
	end
	self.health = self.health - dmgDealt
	self.healthLost = self.healthLost + dmgDealt

	if self.health <= 0 then self:destroy() end
end

function PopBoss:destroy()
	if(self.health <= 0) then
		player.nBossesDefeated = player.nBossesDefeated + 1
		self.killed = true
		RangedEnemy.destroy(self)
	end

	for _, enemy in ipairs(self.enemies) do
		enemy:destroy()
	end
end

return PopBoss
