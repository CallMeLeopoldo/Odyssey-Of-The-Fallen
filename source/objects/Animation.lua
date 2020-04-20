local class = require("source.packages.middleclass")

local Animation = class("Animation")

-- Function used for initializing a new animation
-- x, y -> top-left posititon where the image will be drawn
-- w, h -> size of each sub-image on the grid of image
-- collums, rows -> what are sub images to be used for the animation
-- timeframe -> time until a new sub image of the grid is shown
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

function Animation:destroy()
	self.animation = nil
	self = nil
	print("animation destroyed")
end

return Animation