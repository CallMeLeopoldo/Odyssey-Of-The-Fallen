local class = require("source.packages.middleclass")

local Beat = class("Beat")

function Beat:initialize(x, y, xLimit, orientation, times)
	self.x = x
	self.y = y
	self.xLimit = xLimit
	self.totalDistance = 60
	self.orientation = orientation
	self.times = times
	self.lastBeat = 0
end

function Beat:update(dt)
	local _, subbeat = music.music:getBeat()

	if subbeat < self.lastBeat then
		self.times = (self.times + 1) % 3
	end

	self.x = self.xLimit + (self.totalDistance/3)*self.orientation*(self.times + subbeat)
	self.lastBeat = subbeat
end

function Beat:draw(dt)
	love.graphics.setColor(0.97, 0.97, 0.97)
	love.graphics.ellipse("fill", self.x, self.y, 2, 15)
	love.graphics.setColor(1, 1, 1)
end

return Beat