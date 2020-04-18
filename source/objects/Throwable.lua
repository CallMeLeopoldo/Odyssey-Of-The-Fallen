class = require("source.packages.middleclass")

local Throwable = class("Throwable")

function Throwable:initialize(x, y, r, ix, iy, dmg, id)
	self.id = id or nill
	self.collider = world:newCircleCollider(x, y, r or 12)
	--self.collider:setCollisionClass("Throwable ")
	self.collider:setObject(self)
	self.collider:applyLinearImpulse(ix or -70,iy or -40)
	self.remove = false
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
		player:interact(dmg or 15)
		self:destroy()
	end
end

function Throwable:draw()

end

function Throwable:destroy()
	self.remove = true
	self.collider:destroy()
	self = nil
end

return Throwable
