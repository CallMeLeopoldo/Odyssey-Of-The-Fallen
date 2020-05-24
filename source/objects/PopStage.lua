local class = require("source.packages.middleclass")
local animation = require("source.objects.Animation")
local Enemy = require("source.objects.enemy")
local MeleeEnemy = require("source.objects.melee_enemy")
local RangedEnemy = require("source.objects.ranged_enemy")
local RangedAttack = require("source.objects.RangedAttack")
local PopStage = class("PopStage")
function PopStage:initialize(x, y, w, h)
	self.collider = world:newRectangleCollider(x+w/4, y, w/2, h)
	self.animation = animation:new(self.collider:getX(), self.collider:getY(), sprites.stage, 260, 261, '1-4', 1, 1/12)
	self.collider:setCollisionClass("Stage")

end

function PopStage:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function PopStage:update(dt)
	self.animation:update(dt)
end

function PopStage:draw()
	self.animation:draw()
end

function PopStage:destroy()
	self.animation:destroy()
	self = nil;
end

return PopStage