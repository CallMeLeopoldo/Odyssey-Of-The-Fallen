local class = require("source.packages.middleclass")
local beat = require("source.objects.Beat") 

local BeatBar = class("BeatBar")

function BeatBar:initialize(x, y)
	self.x = x
	self.y = y
	self.beats = {
		beat:new(self.x + 60, self.y, self.x + 60, -1, 0),
		beat:new(self.x + 40, self.y, self.x + 60, -1, 1),
		beat:new(self.x + 20, self.y, self.x + 60, -1, 2),
		beat:new(self.x - 20, self.y, self.x - 60, 1, 2),
		beat:new(self.x - 40, self.y, self.x - 60, 1, 1),
		beat:new(self.x - 60, self.y, self.x - 60, 1, 0)
	}
end

function BeatBar:load()
	--renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function BeatBar:update(dt)
	for _, beat in ipairs(self.beats) do
		beat:update(dt)
	end
end

function BeatBar:draw(dt)
	for _, beat in ipairs(self.beats) do
		beat:draw()
	end
end

return BeatBar