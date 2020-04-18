local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local BasicEnemy = require("source.object.BasicEnemy")
local RangedEnemy = require("source.object.RangedEnemy")

local PopBoss = class("PopBoss", RangedEnemy)

local states = { fight = 1, spawn = 2, shield = 3 }

function PopBoss:initialize(x, y, player)
	local collider = world:newCircleCollider(x, y, 30)
	collider:setObject(self)
	collider:setCollisionClass("ranged_enemy")

	-- RangedEnemy.initialize(self, blabla)

	self.states = states
	self.currentState = self.state.fight
	self.player = player
	self.healthLost = 0
	self.shield = 0
	self.enemies = {}
end

function PopBoss:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function PopBoss:update(dt)
	self:updateState()
	
	if self.currentState == self.state.fight or self.currentState == self.state.shield then
		self:updateFight(dt)
	elseif self.currentState == self.spawn.spawn then
		self:updateSpawn(dt)
	end
end

function PopBoss:updateState()
	if self.currentState == self.states.fight then
		if  self.health < (self.maxHealth / 3) then
			self.currentState = self.state.shield
			self.shield = 20
			-- TODO: set animation
			-- TODO: Make the music faster and adjust the bmps
		elseif self.healthLost >= 15 then

			-- Create the new enemies
			self.currentState = self.state.spawn
			self.numberEnemies = math.floor((self.maxHealth - self.health) / 15) - 1
			for i = 0, 2 + self.numberEnemies, 1 do
				table.insert(self.enemies, BasicEnemy:new()) -- need to choose the inside variables for the enemy
			end
			for i = 0, 1 + self.numberEnemies, 1 do
				table.insert(self.enemies, RangedEnemy:new()) -- need to choose the inside variables for the enemy
			end
			self.numberEnemies = (self.numberEnemies * 2) + 3
			self.healthLost = 0

			-- TODO: Put the character in the new position
		end
	elseif self.currentState == self.states.spawn then
		if table.maxn(self.enemies) == 0 then
			self.currentState = self.states.fight
			-- TODO: Put the character in the new position
			-- TODO: change the attack it makes
		end
	end
end

function PopBoss:updateFight(dt)
	RangedEnemy.update(dt)
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
end

function PopBoss:draw()
	self.animation:draw()
	for _, enemy in ipairs(self.enemies) do
		enemy:draw()
	end
end

-- TODO: tratar de colisões com o player e com ataques do player

return PopBoss