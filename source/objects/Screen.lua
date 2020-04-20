local class = require("source.packages.middleclass")

local Screen = class("Screen")

function Screen:initialize()
	self.buttons = {
		{ "Restart", function() restart() end },
		{ "Exit", function() love.event.quit(0) end }
	}
	self.currentChoice = 0
	self.pause = false
end

function Screen:load()
	--gameLoop:addLoop(self)
	renderer:addRenderer(self, 5)
end

function Screen:keypressed(k)
	if (k == "down") then
		self.currentChoice = (self.currentChoice + 1) % #self.buttons
	elseif (k == "up") then
		self.currentChoice = (self.currentChoice - 1) % #self.buttons
	elseif k == "z" or k == "return" then
		self.buttons[self.currentChoice + 1][2]()
	elseif k == "x" or k == "escape" then
		self.pause = false
	end
end

function Screen:draw()
	local cx, _ = camera:position()
	local ox = 0
	if (cx == love.graphics.getWidth()/2) then
		ox = 0
	elseif (cx == 33512) then
		ox = 32944
	else
		ox = cx - 568
	end

	local ww = love.graphics.getWidth() * 0.5
	local wh = love.graphics.getHeight() * 0.5
	local leftMargin = 10
	local topMargin = 10

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", ox + ww/2 , wh/2 ,ww, wh)

	local x, y = ox + ww/2 + leftMargin, wh/2 + topMargin
	for i, button in ipairs(self.buttons) do
		if (i == self.currentChoice + 1) then
			love.graphics.setColor(0, 0, 1)
			love.graphics.rectangle("fill", x-1, y-1, ww + 2 - leftMargin*2, 2 + ((wh-30)/2))
		end

		love.graphics.setColor(0.4, 0.4, 0.4)
		
		love.graphics.rectangle("fill", x, y, ww - leftMargin*2, (wh - 30) / 2)
		
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(button[1], x, y)

		y = y + ((wh - 30)/2) + topMargin
	end

end

function Screen:remove()
	gameLoop:removeLoop(self)
	renderer:removeRenderer(self, 5)
end

return Screen