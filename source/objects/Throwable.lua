class = require("source.packages.middleclass")

local Throwable = class("Throwable")

function Throwable:initialize(x, y)
	self.collider = world:newCircleCollider(x, y, 12)
	--self.collider:setCollisionClass("Throwable ")
	self.collider:setObject(self)
	self.collider:applyLinearImpulse(-70, -40)
end

function Throwable:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Throwable:update(dt)
	if self.collider:enter("Ground") then
		self:destroy()
	elseif self.collider:enter("Player") then
		local collision_data = self.collider:getEnterCollisionData('Player')
		local player = collision_data.collider:getObject()
		player:interact(15)
		self:destroy()
	end
end

function Throwable:draw()
	
end

function Throwable:destroy()
	self.collider:destroy()
	self = nil
end

return Throwable