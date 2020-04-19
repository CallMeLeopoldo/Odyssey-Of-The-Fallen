class = require("source.packages.middleclass")

local Throwable = class("Throwable")

function Throwable:initialize(x, y, r, ix, iy, dmg, id)
	self.id = id or nill
	self.collider = world:newCircleCollider(x, y, r or 12)
	self.collider:setCollisionClass("EnemyAttack")
	self.collider:setObject(self)
	self.collider:applyLinearImpulse(ix or -70,iy or -40)
	self.collider:setPreSolve(
		function(collider_1, collider_2, contact)
			if collider_1.collision_class == "EnemyAttack" and (collider_2.collision_class == "EnemyAttack" or 
					collider_2.collision_class == "PlayerAttack" or	collider_2.collision_class == "Enemy") then
				contact.setActive(false)
			end
		end)
	
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
