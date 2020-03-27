local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")

local Player = class("Player", Person)

function Player:initialize(x, y, w, h)
	local collider = world:newRectangleCollider(x, y, w, h)
	collider:setCollisionClass("Player")
	
	Person:initialize(x, y, w, h, collider)
	self.onAir = true
end

function Player:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Player:update(dt)
	if self.collider:enter("Ground") then
		self.onAir = false
	end

	local x = 0

	if love.keyboard.isDown("left") then
		x = -1
	end
	if love.keyboard.isDown("right") then
		x = 1
	end
	if not self.onAir and love.keyboard.isDown("a") then
		self.collider:applyLinearImpulse(0, -250)
		self.onAir = true
	end
	if love.keyboard.isDown("s") then
		local px, py = self.collider:getPosition()
		world:queryCircleArea(px, py, 80, {"Attack"})
	end

	local currentX = self.collider:getX()
	self.collider:setX(currentX + x*dt*20)
end

function Player:draw()
	px = self.collider:getX() - self.w / 2
	py = self.collider:getY() - self.h / 2
	
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", px, py, self.w, self.h)
	love.graphics.setColor(255, 255, 255)
end

return Player