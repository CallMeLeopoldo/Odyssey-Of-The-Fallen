local class = require("source.packages.middleclass")
local Enemy = require("source.objects.enemy")
local MeleeEnemy = require("source.objects.melee_enemy")
local RangedEnemy = require("source.objects.ranged_enemy")
local RangedAttack = require("source.objects.RangedAttack")

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
	self.counter = 0
	self.attack = false
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
			self.currentState = self.states.shield
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
			self.numberEnemies = 4

			table.insert(self.enemies, MeleeEnemy:new(32944 + 300, 450, 64, 64, 30))
			table.insert(self.enemies, MeleeEnemy:new(33960 - 300, 450, 64, 64, 30))
			table.insert(self.enemies, RangedEnemy:new(32944 + 100, 450, 64, 64, 30))
			table.insert(self.enemies, RangedEnemy:new(33960 - 100, 450, 64, 64, 30)) 

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
		if self.currentState == self.states.shield then
			accuracy = 1
		end
		
		local orientation = (self.player.collider:getX() - self.collider:getX()) / math.abs(self.player.collider:getX() - self.collider:getX()) 
		local t = RangedAttack:new(self.collider:getX(), self.collider:getY(), orientation, accuracy, false)
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