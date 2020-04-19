local class = require("source.packages.middleclass")
local Enemy = require("source.objects.enemy")
local MeleeEnemy = require("source.objects.melee_enemy")
local RangedEnemy = require("source.objects.ranged_enemy")

local PopBoss = class("PopBoss", RangedEnemy)

local states = { fight = 1, spawn = 2, shield = 3 }

function PopBoss:initialize(x, y, player)
	
	Enemy.initialize(self, x, y, 64, 64, 30, 10, "PopBoss", 70)

	self.states = states
	self.currentState = self.states.fight
	self.player = player
	self.health = 100
	self.healthLost = 15
	self.shield = 0
	self.enemies = {}
end

function PopBoss:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function PopBoss:update(dt)
	self:updateState()
	
	if self.currentState == self.states.fight or self.currentState == self.states.shield then
		self:updateFight(dt)
	elseif self.currentState == self.states.spawn then
		self:updateSpawn(dt)
	end
end

function PopBoss:updateState()
	if self.currentState == self.states.fight then
		if  self.health < (self.maxHealth / 3) then
			self.currentState = self.state.shield
			self.shield = 20
			if self.player.collider:getX() >= 33512 then
				self.collider:setPosition(33144, 486)
			else
				self.collider:setPosition(33760, 486)
			end
			-- TODO: set animation
			-- TODO: Make the music faster and adjust the bmps
		elseif self.healthLost >= 15 then

			-- Create the new enemies
			self.currentState = self.states.spawn
			self.numberEnemies = math.floor((self.maxHealth - self.health) / 15)
			for i = 0, 2 + self.numberEnemies, 1 do
				table.insert(self.enemies, MeleeEnemy:new(32944 + 100 * (i + 1), 450, 64, 64, 30)) -- need to choose the inside variables for the enemy
			end
			for i = 0, 1 + self.numberEnemies, 1 do
				table.insert(self.enemies, RangedEnemy:new(33960 - 100 * (i + 1), 450, 64, 64, 30)) -- need to choose the inside variables for the enemy
			end
			self.numberEnemies = (self.numberEnemies * 2) + 3
			self.healthLost = 0

			self.collider:setPosition(34020, 286)
		end
	elseif self.currentState == self.states.spawn then
		if table.maxn(self.enemies) == 0 then
			self.currentState = self.states.fight
			if self.player.collider:getX() >= 33512 then
				self.collider:setPosition(33144, 486)
			else
				self.collider:setPosition(33760, 486)
			end
			-- TODO: change the attack it makes
		end
	end
end

function PopBoss:updateFight(dt)
	Enemy.update(self, dt)
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

	self.animation:update(dt)
end

function PopBoss:draw()
	self.animation:draw()
	for _, enemy in ipairs(self.enemies) do
		if not enemy.destroyed then enemy:draw() end  
	end
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
end

-- TODO: tratar de colisões com o player e com ataques do player

return PopBoss