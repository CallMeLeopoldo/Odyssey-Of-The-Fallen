local animation = require("source.objects.Animation")
local class = require("source.packages.middleclass")

local Beat = class("Beat")

function Beat:initialize(x, y, xLimit, orientation, times)
	self.x = x
	self.y = y
	self.xLimit = xLimit
	self.totalDistance = 350
	self.orientation = orientation
	self.times = times
	self.lastBeat = 0
	self.animation = animation:new(x, y, sprites.beat, 64, 64, 1, 1, 1)
end

function Beat:update(dt)
	local _, subbeat = music.music:getBeat()

	if subbeat < self.lastBeat then
		self.times = (self.times + 1) % 5
	end

	self.x = self.xLimit + (self.totalDistance/5)*self.orientation*(self.times + subbeat)
	self.animation.x = self.x
	self.lastBeat = subbeat
end

function Beat:draw(dt)
	self.animation:draw()
end

return Beat