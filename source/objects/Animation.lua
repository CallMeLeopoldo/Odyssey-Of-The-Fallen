local class = require("source.packages.middleclass")

local Animation = class("Animation")

function Animation:initialize(x, y, image, w, h, columns, rows, timeframe)
	self.x = x or 0
	self.y = y or 0
	self.image = image

	local g = anim8.newGrid(w, h, image:getWidth(), image:getHeight())
	self.animation = anim8.newAnimation(g(columns, rows), timeframe)
end

function Animation:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Animation:update(dt)
	self.animation:update(dt)

end

function Animation:draw()
	self.animation:draw(self.image, self.x, self.y)
end

return Animation