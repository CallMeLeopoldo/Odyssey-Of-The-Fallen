local class = require("source.packages.middleclass")

local RangedAttack = class("RangedAttack")


function RangedAttack:initialize(x, y, orientation, accuracy, isPlayers)
	self.orientation = orientation
	self.lifeSpan = 1
	self.damage = 5 * accuracy

	self.collider = world:newCircleCollider(x, y, 15)
	self.collider:setObject(self)
	self.collider:setSleepingAllowed(false)
	if isPlayers then
		self.collider:setCollisionClass("PlayerAttack")
	else
		self.collider:setCollisionClass("EnemyAttack")
	end
	self.collider:getBody():setFixedRotation(true)
	self.collider:setGravityScale(0)

	self.collider:setPreSolve(
		function(collider_1, collider_2, contact)
			if collider_1.collision_class == "PlayerAttack" then
				if (collider_2.collision_class == "EnemyAttack" or collider_2.collision_class == "PlayerAttack") then
					contact:setEnabled(false)
				end
			elseif collider_1.collision_class == "EnemyAttack" then
				if (collider_2.collision_class == "EnemyAttack" or collider_2.collision_class == "PlayerAttack" or 
					collider_2.collision_class == "Enemy") then
					contact:setEnabled(false)
				end
			end
		end)
end

function RangedAttack:load()
	renderer:addRenderer(self, 3)
	gameLoop:addLoop(self)
end

function RangedAttack:update(dt)
	self.lifeSpan = self.lifeSpan - dt
	local collided = self:CheckCollisions()
	if collided or self.lifeSpan <= 0 then
		self:destroy()
		return
	end

	self.collider:setX(self.collider:getX() + 150*dt*self.orientation)
end

function RangedAttack:draw()
	-- drawing the animation to be set
end

function RangedAttack:CheckCollisions() 
	if self.collider.collision_class == "PlayerAttack" and self.collider:enter('Enemy') then
		local cd = self.collider:getEnterCollisionData("Enemy")
		cd.collider:getObject():interact(self.damage)
		return true
	elseif self.collider.collision_class == "EnemyAttack" and self.collider:enter('Player') then
		local cd = self.collider:getEnterCollisionData('Player')
		cd.collider:getObject():interact(self.damage)
	end

	return false
end

function RangedAttack:destroy()
	gameLoop:removeLoop(self)
	renderer:removeRenderer(self)
	self.collider:destroy()
end

return RangedAttack