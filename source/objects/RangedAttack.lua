local class = require("source.packages.middleclass")

local RangedAttack = class("RangedAttack")


function RangedAttack:initialize(x, y, orientation, accuracy)
	self.orientation = orientation
	self.lifeSpan = 1
	self.damage = 5 * accuracy

	self.collider = world:newCircleCollider(x, y, 15)
	self.collider:setObject(self)
	self.collider:setSleepingAllowed(false)
	self.collider:setCollisionClass("Attack")
	self.collider:getBody():setFixedRotation(true)
	self.collider:setGravityScale(0)
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

	self.collider:setX(self.collider:getX() + 100*dt*self.orientation)
end

function RangedAttack:draw()
	-- drawing the animation to be set
end

function RangedAttack:CheckCollisions() 
	if self.collider:enter('BasicEnemy') then
		local cd = self.collider:getEnterCollisionData("BasicEnemy")
		cd.collider:getObject():interact(self.damage)
		return true
	end

	return false
end

function RangedAttack:destroy()
	gameLoop:removeLoop(self)
	renderer:removeRenderer(self)
	self.collider:destroy()
end

return RangedAttack