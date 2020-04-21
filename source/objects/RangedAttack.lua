local class = require("source.packages.middleclass")
local animation = require("source.objects.Animation")
local RangedAttack = class("RangedAttack")


function RangedAttack:initialize(x, y, orientation, accuracy, isPlayers, sprite)
	self.orientation = orientation
	self.lifeSpan = 1
	self.damage = 5 * accuracy
	self.radius = 15
	self.collider = world:newCircleCollider(x, y, self.radius)

	local collumn = 0
	if orientation == 1 then collumn = 1 else collumn = 2 end

	self.animation = animation:new(x-self.radius, y-self.radius, sprite, 32, 32, collumn, 1, 1)
	self.movementSpeed = 250
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
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function RangedAttack:update(dt)
	self.lifeSpan = self.lifeSpan - dt
	local collided = self:CheckCollisions()
	if collided or self.lifeSpan <= 0 then
		self:destroy()
		return
	end

	self.collider:setX(self.collider:getX() + self.movementSpeed*dt*self.orientation)
	self.animation.x = (self.collider:getX() - self.radius + self.movementSpeed*dt*self.orientation)
	self.animation.y = self.collider:getY() - self.radius
end

function RangedAttack:draw()
	self.animation:draw()
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
	self.animation:destroy()
end

return RangedAttack
